import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageFinance, canDeleteTransactions } from '../lib/permissions'
import { formatCurrency, monthName, currentYear } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, Trash2 } from 'lucide-react'
import type { MonthlyInterest } from '../types'

export default function InterestPage() {
  const { profile } = useAuth()
  const [rows, setRows] = useState<MonthlyInterest[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [form, setForm] = useState({ month: new Date().getMonth() + 1, year: currentYear(), amount: '', notes: '' })

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const { data } = await supabase.from('monthly_interest').select('*').order('created_at', { ascending: false })
    setRows(data ?? [])
    setLoading(false)
  }

  async function save() {
    if (!form.amount) { toast('Amount required', 'error'); return }
    const { error } = await supabase.from('monthly_interest').insert({
      month: Number(form.month), year: Number(form.year), amount: Number(form.amount),
      notes: form.notes || null, source_type: 'manual',
    })
    if (error) { toast(error.message, 'error'); return }
    toast('Interest recorded'); setShowAdd(false); load()
  }

  async function remove(id: string) {
    if (!confirm('Delete this interest record?')) return
    const { error } = await supabase.from('monthly_interest').delete().eq('id', id)
    if (error) { toast(error.message, 'error'); return }
    toast('Interest deleted'); load()
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canFinance = canManageFinance(profile?.role)
  const canDelete = canDeleteTransactions(profile?.role)
  const total = rows.reduce((s, r) => s + Number(r.amount), 0)

  return (
    <div>
      <div className="stat-grid">
        <div className="stat-card"><div className="stat-label">Total Interest</div><div className="stat-value">{formatCurrency(total)}</div></div>
        <div className="stat-card"><div className="stat-label">Records</div><div className="stat-value">{rows.length}</div></div>
      </div>
      <div className="card">
        <div className="card-header">
          <h3>Monthly Interest</h3>
          {canFinance && <button className="btn btn-primary" onClick={() => setShowAdd(true)}><Plus size={16} /> Record Interest</button>}
        </div>
        <div className="table-wrap">
          <table className="data-table">
            <thead><tr><th>Month</th><th>Year</th><th>Amount</th><th>Source</th><th>Notes</th>{canDelete && <th></th>}</tr></thead>
            <tbody>
              {rows.length === 0 && <tr><td colSpan={6} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No interest recorded</td></tr>}
              {rows.map((r) => (
                <tr key={r.id}>
                  <td>{monthName(r.month)}</td>
                  <td>{r.year}</td>
                  <td>{formatCurrency(r.amount)}</td>
                  <td><span className="badge badge-neutral">{r.source_type}</span></td>
                  <td>{r.notes ?? '—'}</td>
                  {canDelete && <td><button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(r.id)}><Trash2 size={15} /></button></td>}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      <Modal open={showAdd} onClose={() => setShowAdd(false)} title="Record Interest" footer={<>
        <button className="btn btn-secondary" onClick={() => setShowAdd(false)}>Cancel</button>
        <button className="btn btn-primary" onClick={save}>Save</button>
      </>}>
        <div className="form-row">
          <div className="form-group"><label>Month</label>
            <select value={form.month} onChange={(e) => setForm({ ...form, month: Number(e.target.value) })}>
              {Array.from({ length: 12 }, (_, i) => <option key={i + 1} value={i + 1}>{monthName(i + 1)}</option>)}
            </select></div>
          <div className="form-group"><label>Year</label><input type="number" value={form.year} onChange={(e) => setForm({ ...form, year: Number(e.target.value) })} /></div>
        </div>
        <div className="form-group"><label>Amount (KES)</label><input type="number" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} /></div>
        <div className="form-group"><label>Notes</label><input value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} /></div>
      </Modal>
    </div>
  )
}
