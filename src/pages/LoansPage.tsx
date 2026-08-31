import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageFinance, canApproveLoans, canDeleteTransactions } from '../lib/permissions'
import { formatCurrency, formatDate, todayISO } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, Trash2, Pencil, Landmark, RefreshCw, CheckCircle2, AlertTriangle } from 'lucide-react'
import type { Loan, LoanRepayment, Member, LoanStatus } from '../types'

export default function LoansPage() {
  const { profile } = useAuth()
  const [loans, setLoans] = useState<Loan[]>([])
  const [members, setMembers] = useState<Member[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [editing, setEditing] = useState<Loan | null>(null)
  const [repaying, setRepaying] = useState<Loan | null>(null)
  const [historyFor, setHistoryFor] = useState<Loan | null>(null)
  const [repayments, setRepayments] = useState<LoanRepayment[]>([])

  const [form, setForm] = useState({
    member_id: '', principal_amount: '', interest_rate: '5', mpesa_cost: '0',
    issue_date: todayISO(), due_date: '', notes: '',
  })

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    await markDefaulters()
    const [lns, mems] = await Promise.all([
      supabase.from('loans').select('*, member:members(full_name)').order('created_at', { ascending: false }),
      supabase.from('members').select('*').eq('status', 'active').order('full_name'),
    ])
    setLoans(lns.data ?? [])
    setMembers(mems.data ?? [])
    setLoading(false)
  }

  async function markDefaulters() {
    const today = todayISO()
    const { data: overdue } = await supabase.from('loans')
      .select('id, member_id, status, balance, due_date')
      .neq('status', 'cleared')
      .lt('due_date', today)
    if (!overdue || overdue.length === 0) return
    const memberIds = Array.from(new Set(overdue.filter((l) => Number(l.balance) > 0).map((l) => l.member_id)))
    for (const l of overdue) {
      if (Number(l.balance) > 0 && l.status !== 'defaulted') {
        await supabase.from('loans').update({ status: 'defaulted' as LoanStatus }).eq('id', l.id)
      }
    }
    for (const mid of memberIds) {
      await supabase.from('members').update({ is_defaulter: true, defaulter_since: today }).eq('id', mid)
    }
  }

  function computeLoan(principal: number, rate: number, mpesa: number) {
    const interest = principal * (rate / 100)
    const total = principal + interest + mpesa
    return { interest_amount: interest, total_payable: total, balance: total }
  }

  async function save() {
    if (!form.member_id || !form.principal_amount) { toast('Member and principal required', 'error'); return }
    const principal = Number(form.principal_amount)
    const rate = Number(form.interest_rate)
    const mpesa = Number(form.mpesa_cost)
    const { interest_amount, total_payable, balance } = computeLoan(principal, rate, mpesa)

    if (editing) {
      const { error } = await supabase.from('loans').update({
        member_id: form.member_id, principal_amount: principal, interest_rate: rate,
        interest_amount, mpesa_cost: mpesa, total_payable, balance,
        issue_date: form.issue_date, due_date: form.due_date, notes: form.notes || null,
      }).eq('id', editing.id)
      if (error) { toast(error.message, 'error'); return }
      toast('Loan updated')
    } else {
      const { error } = await supabase.from('loans').insert({
        member_id: form.member_id, principal_amount: principal, interest_rate: rate,
        interest_amount, mpesa_cost: mpesa, total_payable, balance,
        issue_date: form.issue_date, due_date: form.due_date, notes: form.notes || null,
        approved_by: profile?.id, status: 'approved' as LoanStatus,
      })
      if (error) { toast(error.message, 'error'); return }
      toast('Loan created')
    }
    setShowAdd(false); setEditing(null); load()
  }

  async function remove(id: string) {
    if (!confirm('Delete this loan and all its repayments?')) return
    await supabase.from('loan_repayments').delete().eq('loan_id', id)
    const { error } = await supabase.from('loans').delete().eq('id', id)
    if (error) { toast(error.message, 'error'); return }
    toast('Loan deleted'); load()
  }

  async function loadRepayments(loan: Loan) {
    setHistoryFor(loan)
    const { data } = await supabase.from('loan_repayments').select('*').eq('loan_id', loan.id).order('payment_date', { ascending: false })
    setRepayments(data ?? [])
  }

  async function recordRepayment(amount: number, paymentDate: string, method: string, type: string, notes: string) {
    if (!repaying) return
    const { error: repErr } = await supabase.from('loan_repayments').insert({
      loan_id: repaying.id, amount, payment_date: paymentDate, payment_method: method,
      repayment_type: type, notes: notes || null, recorded_by: profile?.id,
    })
    if (repErr) { toast(repErr.message, 'error'); return }

    let updateData: Record<string, any>
    let cleared = false

    if (type === 'partial') {
      const oldPrincipal = Number(repaying.principal_amount)
      const interestAmount = Number(repaying.interest_amount)
      const mpesaCost = Number(repaying.mpesa_cost ?? 0)
      const newPrincipal = Math.max(0, oldPrincipal - amount)
      const newTotal = newPrincipal + interestAmount + mpesaCost
      const newBalance = Math.max(0, newTotal - Number(repaying.amount_repaid))
      cleared = newBalance <= 0
      updateData = {
        principal_amount: newPrincipal,
        total_payable: newTotal,
        balance: newBalance,
        status: cleared ? 'cleared' as LoanStatus : repaying.status,
      }
    } else {
      const newRepaid = Number(repaying.amount_repaid) + amount
      const newBalance = Math.max(0, Number(repaying.total_payable) - newRepaid)
      cleared = newBalance <= 0
      updateData = {
        amount_repaid: newRepaid, balance: newBalance,
        status: cleared ? 'cleared' as LoanStatus : repaying.status,
      }
    }

    const { error: loanErr } = await supabase.from('loans').update(updateData).eq('id', repaying.id)
    if (loanErr) { toast('Repayment saved but loan update failed: ' + loanErr.message, 'error'); setRepaying(null); load(); return }
    if (cleared) {
      await checkAndClearDefaulter(repaying.member_id)
    }
    toast(cleared ? 'Loan fully cleared!' : 'Repayment recorded')
    setRepaying(null); load()
  }

  async function checkAndClearDefaulter(memberId: string) {
    const { data: active } = await supabase.from('loans')
      .select('id, balance, status').eq('member_id', memberId).neq('status', 'cleared')
    const stillOwing = (active ?? []).filter((l) => Number(l.balance) > 0)
    if (stillOwing.length === 0) {
      await supabase.from('members').update({ is_defaulter: false, defaulter_since: null }).eq('id', memberId)
    }
  }

  async function carryForward(loan: Loan) {
    if (!confirm('Carry forward this loan? A new loan will be created for the remaining balance and this one marked cleared.')) return
    const remaining = Number(loan.balance)
    if (remaining <= 0) { toast('Loan has no balance to carry forward', 'error'); return }
    const rate = Number(loan.interest_rate)
    const newInterest = remaining * (rate / 100)
    const newTotal = remaining + newInterest
    const { error } = await supabase.from('loans').insert({
      member_id: loan.member_id, principal_amount: remaining, interest_rate: rate,
      interest_amount: newInterest, mpesa_cost: 0, total_payable: newTotal, balance: newTotal,
      issue_date: todayISO(), due_date: '', notes: `Carried forward from loan ${loan.id.slice(0, 8)}`,
      approved_by: profile?.id, status: 'approved' as LoanStatus,
      is_carried_forward: true, original_loan_id: loan.id,
    })
    if (error) { toast(error.message, 'error'); return }
    await supabase.from('loans').update({ status: 'cleared' as LoanStatus, balance: 0, amount_repaid: Number(loan.total_payable) }).eq('id', loan.id)
    await checkAndClearDefaulter(loan.member_id)
    toast('Loan carried forward'); load()
  }

  async function deleteRepayment(rep: LoanRepayment) {
    if (!confirm('Delete this repayment? The loan balance will be adjusted back.')) return
    const loan = loans.find((l) => l.id === rep.loan_id)
    if (!loan) return
    const newRepaid = Math.max(0, Number(loan.amount_repaid) - Number(rep.amount))
    const newBalance = Math.min(Number(loan.total_payable), Number(loan.total_payable) - newRepaid)
    const { error } = await supabase.from('loan_repayments').delete().eq('id', rep.id)
    if (error) { toast(error.message, 'error'); return }
    await supabase.from('loans').update({
      amount_repaid: newRepaid, balance: newBalance,
      status: newBalance <= 0 ? 'cleared' as LoanStatus : (loan.status === 'cleared' ? 'approved' as LoanStatus : loan.status),
    }).eq('id', loan.id)
    toast('Repayment deleted'); loadRepayments(loan); load()
  }

  function openEdit(l: Loan) {
    setEditing(l)
    setForm({
      member_id: l.member_id, principal_amount: String(l.principal_amount), interest_rate: String(l.interest_rate),
      mpesa_cost: String(l.mpesa_cost ?? 0), issue_date: l.issue_date, due_date: l.due_date, notes: l.notes ?? '',
    })
    setShowAdd(true)
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canFinance = canManageFinance(profile?.role)
  const canApprove = canApproveLoans(profile?.role)
  const canDelete = canDeleteTransactions(profile?.role)

  const totalOutstanding = loans.filter((l) => l.status !== 'cleared').reduce((s, l) => s + Number(l.balance), 0)
  const totalDisbursed = loans.reduce((s, l) => s + Number(l.principal_amount), 0)

  return (
    <div>
      <div className="stat-grid">
        <div className="stat-card"><div className="stat-label">Total Disbursed</div><div className="stat-value">{formatCurrency(totalDisbursed)}</div></div>
        <div className="stat-card"><div className="stat-label">Outstanding</div><div className="stat-value">{formatCurrency(totalOutstanding)}</div></div>
        <div className="stat-card"><div className="stat-label">Active Loans</div><div className="stat-value">{loans.filter((l) => l.status !== 'cleared').length}</div></div>
        <div className="stat-card"><div className="stat-label">Defaulted</div><div className="stat-value">{loans.filter((l) => l.status === 'defaulted').length}</div></div>
      </div>

      <div className="card">
        <div className="card-header">
          <h3>Loans</h3>
          {canFinance && <button className="btn btn-primary" onClick={() => { setEditing(null); setForm({ member_id: '', principal_amount: '', interest_rate: '5', mpesa_cost: '0', issue_date: todayISO(), due_date: '', notes: '' }); setShowAdd(true) }}><Plus size={16} /> New Loan</button>}
        </div>
        <div className="table-wrap">
          <table className="data-table">
            <thead><tr><th>Member</th><th>Principal</th><th>Interest</th><th>Total</th><th>Repaid</th><th>Balance</th><th>Due</th><th>Status</th><th></th></tr></thead>
            <tbody>
              {loans.length === 0 && <tr><td colSpan={9} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No loans yet</td></tr>}
              {loans.map((l) => (
                <tr key={l.id}>
                  <td>
                    <div style={{ fontWeight: 600 }}>{l.member?.full_name ?? '—'}</div>
                    {l.is_carried_forward && <span className="badge badge-info" style={{ marginTop: 4 }}><RefreshCw size={11} /> Carried forward</span>}
                  </td>
                  <td>{formatCurrency(l.principal_amount)}</td>
                  <td>{formatCurrency(l.interest_amount)}</td>
                  <td>{formatCurrency(l.total_payable)}</td>
                  <td>{formatCurrency(l.amount_repaid)}</td>
                  <td style={{ fontWeight: 700 }}>{formatCurrency(l.balance)}</td>
                  <td>{formatDate(l.due_date)}</td>
                  <td><span className={`badge ${l.status === 'cleared' ? 'badge-success' : l.status === 'defaulted' ? 'badge-error' : l.status === 'approved' ? 'badge-info' : 'badge-neutral'}`}>{l.status}</span></td>
                  <td>
                    <div className="flex gap-2">
                      {canApprove && l.status !== 'cleared' && <button className="btn btn-secondary btn-sm" onClick={() => setRepaying(l)} title="Record repayment"><CheckCircle2 size={14} /> Pay</button>}
                      {canApprove && l.status !== 'cleared' && Number(l.balance) > 0 && <button className="btn-ghost" onClick={() => carryForward(l)} title="Carry forward"><RefreshCw size={15} /></button>}
                      <button className="btn-ghost" onClick={() => loadRepayments(l)} title="Repayment history"><Landmark size={15} /></button>
                      {canFinance && <button className="btn-ghost" onClick={() => openEdit(l)}><Pencil size={15} /></button>}
                      {canDelete && <button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(l.id)}><Trash2 size={15} /></button>}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <Modal open={showAdd} onClose={() => setShowAdd(false)} title={editing ? 'Edit Loan' : 'New Loan'} size="lg" footer={<>
        <button className="btn btn-secondary" onClick={() => setShowAdd(false)}>Cancel</button>
        <button className="btn btn-primary" onClick={save}>Save</button>
      </>}>
        <div className="form-group"><label>Member</label>
          <select value={form.member_id} onChange={(e) => setForm({ ...form, member_id: e.target.value })}>
            <option value="">Select member…</option>
            {members.map((m) => <option key={m.id} value={m.id}>{m.full_name}</option>)}
          </select></div>
        <div className="form-row">
          <div className="form-group"><label>Principal (KES)</label><input type="number" value={form.principal_amount} onChange={(e) => setForm({ ...form, principal_amount: e.target.value })} /></div>
          <div className="form-group"><label>Interest Rate (%)</label><input type="number" step="0.1" value={form.interest_rate} onChange={(e) => setForm({ ...form, interest_rate: e.target.value })} /></div>
        </div>
        <div className="form-row">
          <div className="form-group"><label>M-Pesa Cost (KES)</label><input type="number" value={form.mpesa_cost} onChange={(e) => setForm({ ...form, mpesa_cost: e.target.value })} /></div>
          <div className="form-group"><label>Issue Date</label><input type="date" value={form.issue_date} onChange={(e) => setForm({ ...form, issue_date: e.target.value })} /></div>
        </div>
        <div className="form-group"><label>Due Date</label><input type="date" value={form.due_date} onChange={(e) => setForm({ ...form, due_date: e.target.value })} /></div>
        <div className="form-group"><label>Notes</label><textarea value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} /></div>
      </Modal>

      <RepayModal loan={repaying} onClose={() => setRepaying(null)} onSubmit={recordRepayment} />

      <Modal open={!!historyFor} onClose={() => setHistoryFor(null)} title={`Repayment History — ${historyFor?.member?.full_name ?? ''}`} size="lg">
        {repayments.length === 0 ? <div className="empty">No repayments recorded yet</div> : (
          <div className="table-wrap">
            <table className="data-table">
              <thead><tr><th>Date</th><th>Amount</th><th>Type</th><th>Method</th><th>Notes</th>{canDelete && <th></th>}</tr></thead>
              <tbody>
                {repayments.map((r) => (
                  <tr key={r.id}>
                    <td>{formatDate(r.payment_date)}</td>
                    <td>{formatCurrency(r.amount)}</td>
                    <td><span className="badge badge-neutral">{r.repayment_type}</span></td>
                    <td>{r.payment_method ?? 'cash'}</td>
                    <td>{r.notes ?? '—'}</td>
                    {canDelete && <td><button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => deleteRepayment(r)}><Trash2 size={15} /></button></td>}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Modal>
    </div>
  )
}

function RepayModal({ loan, onClose, onSubmit }: {
  loan: Loan | null
  onClose: () => void
  onSubmit: (amount: number, date: string, method: string, type: string, notes: string) => void
}) {
  const [amount, setAmount] = useState('')
  const [date, setDate] = useState(todayISO())
  const [method, setMethod] = useState('cash')
  const [type, setType] = useState('full')
  const [notes, setNotes] = useState('')

  useEffect(() => {
    if (loan) { setAmount(''); setDate(todayISO()); setMethod('cash'); setType('full'); setNotes('') }
  }, [loan])

  if (!loan) return null
  return (
    <Modal open={!!loan} onClose={onClose} title="Record Repayment" footer={<>
      <button className="btn btn-secondary" onClick={onClose}>Cancel</button>
      <button className="btn btn-primary" onClick={() => onSubmit(Number(amount), date, method, type, notes)}>Save</button>
    </>}>
      <div className="muted-box mb-4">
        Outstanding balance: <strong>{formatCurrency(loan.balance)}</strong> of {formatCurrency(loan.total_payable)}
      </div>
      <div className="form-row">
        <div className="form-group"><label>Amount (KES)</label><input type="number" value={amount} onChange={(e) => setAmount(e.target.value)} /></div>
        <div className="form-group"><label>Payment Date</label><input type="date" value={date} onChange={(e) => setDate(e.target.value)} /></div>
      </div>
      <div className="form-row">
        <div className="form-group"><label>Type</label>
          <select value={type} onChange={(e) => setType(e.target.value)}>
            <option value="full">Full payment</option><option value="interest">Interest only</option><option value="principal">Principal only</option><option value="partial">Partial</option>
          </select></div>
        <div className="form-group"><label>Method</label>
          <select value={method} onChange={(e) => setMethod(e.target.value)}>
            <option value="cash">Cash</option><option value="mpesa">M-Pesa</option><option value="bank">Bank</option>
          </select></div>
      </div>
      <div className="form-group"><label>Notes</label><input value={notes} onChange={(e) => setNotes(e.target.value)} /></div>
    </Modal>
  )
}
