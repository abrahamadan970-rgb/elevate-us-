import { useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { formatCurrency } from '../lib/format'
import { toast } from './Toast'
import type { Loan } from '../types'
import Modal from './Modal'

interface Props { loan: Loan; onClose: () => void; onSaved: () => void }

export default function LoanRepaymentModal({ loan, onClose, onSaved }: Props) {
  const { profile } = useAuth()
  const [amount, setAmount] = useState(String(loan.balance))
  const [paymentDate, setPaymentDate] = useState(new Date().toISOString().split('T')[0])
  const [paymentMethod, setPaymentMethod] = useState('mpesa')
  const [notes, setNotes] = useState('')
  const [saving, setSaving] = useState(false)

  const repayAmount = parseFloat(amount) || 0
  const isPartial = repayAmount > 0 && repayAmount < Number(loan.balance)
  const newPrincipal = isPartial ? Math.max(0, Number(loan.principal_amount) - repayAmount) : Number(loan.principal_amount)
  const interestAmount = Number(loan.interest_amount)
  const mpesaCost = Number(loan.mpesa_cost ?? 0)
  const newTotal = isPartial ? newPrincipal + interestAmount + mpesaCost : Number(loan.total_payable)
  const newBalance = isPartial ? Math.max(0, newTotal - Number(loan.amount_repaid)) : Math.max(0, Number(loan.total_payable) - (Number(loan.amount_repaid) + repayAmount))
  const isFullRepayment = newBalance <= 0.01

  async function handleSave() {
    if (repayAmount <= 0) { toast('Enter a valid amount', 'error'); return }
    setSaving(true)
    try {
      const { error: repErr } = await supabase.from('loan_repayments').insert({
        loan_id: loan.id, amount: repayAmount, payment_date: paymentDate,
        payment_method: paymentMethod, notes: notes || null,
        repayment_type: isFullRepayment ? 'full' : 'partial',
        recorded_by: profile?.id,
      })
      if (repErr) { toast(repErr.message, 'error'); setSaving(false); return }

      let updateData: Record<string, any>
      if (isPartial && !isFullRepayment) {
        updateData = {
          principal_amount: newPrincipal,
          total_payable: newTotal,
          balance: newBalance,
        }
      } else {
        const newRepaid = Number(loan.amount_repaid) + repayAmount
        updateData = {
          amount_repaid: newRepaid, balance: newBalance,
          status: isFullRepayment ? 'cleared' : 'disbursed',
        }
      }
      if (isFullRepayment) updateData.status = 'cleared'

      const { error: loanErr } = await supabase.from('loans').update(updateData).eq('id', loan.id)
      if (loanErr) { toast(loanErr.message, 'error'); setSaving(false); return }

      toast(isFullRepayment ? 'Loan fully cleared!' : 'Partial payment recorded — principal reduced')
      onSaved(); onClose()
    } catch {
      toast('Failed to record repayment', 'error')
    } finally { setSaving(false) }
  }

  return (
    <Modal title="Record Repayment" onClose={onClose}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 13 }}>
        <div style={{ background: 'var(--input-bg)', borderRadius: 12, padding: 14, border: '1px solid var(--border)' }}>
          <div style={{ fontSize: 11, fontWeight: 700, color: 'var(--text-3)', marginBottom: 8, letterSpacing: '.05em' }}>LOAN DETAILS</div>
          <Row label="Total Payable" value={formatCurrency(loan.total_payable)} />
          <Row label="Already Repaid" value={formatCurrency(loan.amount_repaid)} />
          <Row label="Balance" value={formatCurrency(loan.balance)} bold />
        </div>

        <div><label className="field-label">Amount (KES)</label><input className="field-input" type="number" value={amount} onChange={e => setAmount(e.target.value)} /></div>
        <div><label className="field-label">Payment Date</label><input className="field-input" type="date" value={paymentDate} onChange={e => setPaymentDate(e.target.value)} /></div>
        <div><label className="field-label">Payment Method</label><select className="field-input" value={paymentMethod} onChange={e => setPaymentMethod(e.target.value)} style={{ appearance: 'none' }}><option value="mpesa">M-Pesa</option><option value="cash">Cash</option><option value="bank_transfer">Bank Transfer</option></select></div>
        <div><label className="field-label">Notes</label><textarea className="field-input" value={notes} onChange={e => setNotes(e.target.value)} rows={2} style={{ resize: 'vertical' }} /></div>

        {repayAmount > 0 && (
          <div style={{ background: isFullRepayment ? 'var(--success-bg)' : 'var(--info-bg)', borderRadius: 12, padding: 14, border: `1px solid ${isFullRepayment ? 'var(--success-text)' : 'var(--info-text)'}` }}>
            {isPartial && !isFullRepayment && (
              <>
                <Row label="Principal (before)" value={formatCurrency(Number(loan.principal_amount))} />
                <Row label="Principal (after)" value={formatCurrency(newPrincipal)} bold />
                <div style={{ borderTop: '1px solid var(--border)', margin: '6px 0', paddingTop: 6 }} />
                <Row label="Interest (unchanged)" value={formatCurrency(interestAmount)} />
                <Row label="New Total Payable" value={formatCurrency(newTotal)} />
              </>
            )}
            <Row label="New Balance After Repayment" value={formatCurrency(Math.max(0, newBalance))} bold />
            {isPartial && !isFullRepayment && (
              <div style={{ fontSize: 12, color: 'var(--text-3)', marginTop: 6 }}>Partial payment reduces the principal directly — interest stays the same.</div>
            )}
          </div>
        )}

        <div style={{ display: 'flex', gap: 10, justifyContent: 'flex-end' }}>
          <button className="btn btn-ghost" onClick={onClose}>Cancel</button>
          <button className="btn btn-primary" onClick={handleSave} disabled={saving || repayAmount <= 0} style={{ background: 'var(--green)' }}>{saving ? 'Saving...' : 'Record Payment'}</button>
        </div>
      </div>
    </Modal>
  )
}

function Row({ label, value, bold }: { label: string; value: string; bold?: boolean }) {
  return <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, marginBottom: 4 }}><span style={{ color: 'var(--text-3)' }}>{label}</span><span style={{ fontWeight: bold ? 700 : 500, color: bold ? 'var(--brand)' : 'var(--text-2)' }}>{value}</span></div>
}
