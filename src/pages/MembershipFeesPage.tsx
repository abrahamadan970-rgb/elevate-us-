import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageFinance, canDeleteTransactions } from '../lib/permissions'
import { formatCurrency, formatDate, todayISO } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, Trash2 } from 'lucide-react'
import type { MembershipFee, Member } from '../types'

export default function MembershipFeesPage() {
  const { profile } = useAuth()
  const [rows, setRows] = useState<MembershipFee[]>([])
  const [members, setMembers] = useState<Member[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [form, setForm] = useState({ member_id: '', amount: '', fee_year: new Date().getFullYear(), payment_date: todayISO(), payment_method: 'cash', receipt_number: '', notes: '' })

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const [fees, mems] = await Promise.all([
      supabase.from('membership_fees').select('*, member:members(full_name)').order('payment_date', { ascending: false }),
      supabase.from('members').select('*').eq('status', 'active').order('full_name'),
    ])
    setRows(fees.data ?? [])
    setMembers(mems.data ?? [])
    setLoading(false)
  }

  async function save() {
    if (!form.member_id || !form.amount) { toast('Member and amount required', 'error'); return }
    const { error } = await supabase.from('membership_fees').insert({
      member_id: form.member_id, amount: Number(form.amount), fee_year: Number(form.fee_year),
      payment_date: form.payment_date, payment_method: form.payment_method,
      receipt_number: form.receipt_number || null, notes: form.notes || null, recorded_by: profile?.id,
    })
    if (error) { toast(error.message, 'error'); return }
    toast('Membership fee recorded'); setShowAdd(false); load()
  }

  async function remove(id: string) {
    if (!confirm('Delete this fee record?')) return
    const { error } = await supabase.from('membership_fees').delete().eq('id', id)
    if (error) { toast(error.message, 'error'); return }
    toast('Fee deleted'); load()
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canFinance = canManageFinance(profile?.role)
  const canDelete = canDeleteTransactions(profile?.role)
  const total = rows.reduce((s, r) => s + Number(r.amount), 0)

  return (
    <div>
      <div className="stat-grid">
        <div className="stat-card"><div className="stat-label">Total Collected</div><div className="stat-value">{formatCurrency(total)}</div></div>
        <div className="stat-card"><div className="stat-label">Records</div><div className="stat-value">{rows.length}</div></div>
      </div>
      <div className="card">
        <div className="card-header">
          <h3>Membership Fees</h3>
          {canFinance && <button className="btn btn-primary" onClick={() => setShowAdd(true)}><Plus size={16} /> Record Fee</button>}
        </div>
        <div className="table-wrap">
          <table className="data-table">
            <thead><tr><th>Member</th><th>Amount</th><th>Year</th><th>Date</th><th>Method</th><th>Receipt</th>{canDelete && <th></th>}</tr></thead>
            <tbody>
              {rows.length === 0 && <tr><td colSpan={7} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No fees recorded</td></tr>}
              {rows.map((r) => (
                <tr key={r.id}>
                  <td>{r.member?.full_name ?? '—'}</td>
                  <td>{formatCurrency(r.amount)}</td>
                  <td>{r.fee_year}</td>
                  <td>{formatDate(r.payment_date)}</td>
                  <td>{r.payment_method ?? 'cash'}</td>
                  <td>{r.receipt_number ?? '—'}</td>
                  {canDelete && <td><button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(r.id)}><Trash2 size={15} /></button></td>}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      <Modal open={showAdd} onClose={() => setShowAdd(false)} title="Record Membership Fee" footer={<>
        <button className="btn btn-secondary" onClick={() => setShowAdd(false)}>Cancel</button>
        <button className="btn btn-primary" onClick={save}>Save</button>
      </>}>
        <div className="form-group"><label>Member</label>
          <select value={form.member_id} onChange={(e) => setForm({ ...form, member_id: e.target.value })}>
            <option value="">Select member…</option>
            {members.map((m) => <option key={m.id} value={m.id}>{m.full_name}</option>)}
          </select></div>
        <div className="form-row">
          <div className="form-group"><label>Amount (KES)</label><input type="number" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} /></div>
          <div className="form-group"><label>Year</label><input type="number" value={form.fee_year} onChange={(e) => setForm({ ...form, fee_year: Number(e.target.value) })} /></div>
        </div>
        <div className="form-group"><label>Payment Date</label><input type="date" value={form.payment_date} onChange={(e) => setForm({ ...form, payment_date: e.target.value })} /></div>
        <div className="form-row">
          <div className="form-group"><label>Method</label>
            <select value={form.payment_method} onChange={(e) => setForm({ ...form, payment_method: e.target.value })}>
              <option value="cash">Cash</option><option value="mpesa">M-Pesa</option><option value="bank">Bank</option>
            </select></div>
          <div className="form-group"><label>Receipt No.</label><input value={form.receipt_number} onChange={(e) => setForm({ ...form, receipt_number: e.target.value })} /></div>
        </div>
      </Modal>
    </div>
  )
}
