import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageFinance, canDeleteTransactions } from '../lib/permissions'
import { formatCurrency, formatDate, todayISO } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, Trash2 } from 'lucide-react'
import type { Expense } from '../types'

export default function ExpensesPage() {
  const { profile } = useAuth()
  const [rows, setRows] = useState<Expense[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [form, setForm] = useState({ category: 'operations', description: '', amount: '', expense_date: todayISO(), notes: '' })

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const { data } = await supabase.from('expenses').select('*').order('expense_date', { ascending: false })
    setRows(data ?? [])
    setLoading(false)
  }

  async function save() {
    if (!form.description || !form.amount) { toast('Description and amount required', 'error'); return }
    const { error } = await supabase.from('expenses').insert({
      category: form.category, description: form.description, amount: Number(form.amount),
      expense_date: form.expense_date, notes: form.notes || null, recorded_by: profile?.id, approved_by: profile?.id,
    })
    if (error) { toast(error.message, 'error'); return }
    toast('Expense recorded'); setShowAdd(false); load()
  }

  async function remove(id: string) {
    if (!confirm('Delete this expense?')) return
    const { error } = await supabase.from('expenses').delete().eq('id', id)
    if (error) { toast(error.message, 'error'); return }
    toast('Expense deleted'); load()
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canFinance = canManageFinance(profile?.role)
  const canDelete = canDeleteTransactions(profile?.role)
  const total = rows.reduce((s, r) => s + Number(r.amount), 0)

  return (
    <div>
      <div className="stat-grid">
        <div className="stat-card"><div className="stat-label">Total Expenses</div><div className="stat-value">{formatCurrency(total)}</div></div>
        <div className="stat-card"><div className="stat-label">Records</div><div className="stat-value">{rows.length}</div></div>
      </div>
      <div className="card">
        <div className="card-header">
          <h3>Expenses</h3>
          {canFinance && <button className="btn btn-primary" onClick={() => setShowAdd(true)}><Plus size={16} /> Record Expense</button>}
        </div>
        <div className="table-wrap">
          <table className="data-table">
            <thead><tr><th>Category</th><th>Description</th><th>Amount</th><th>Date</th><th>Notes</th>{canDelete && <th></th>}</tr></thead>
            <tbody>
              {rows.length === 0 && <tr><td colSpan={6} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No expenses recorded</td></tr>}
              {rows.map((r) => (
                <tr key={r.id}>
                  <td><span className="badge badge-neutral">{r.category}</span></td>
                  <td>{r.description}</td>
                  <td>{formatCurrency(r.amount)}</td>
                  <td>{formatDate(r.expense_date)}</td>
                  <td>{r.notes ?? '—'}</td>
                  {canDelete && <td><button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(r.id)}><Trash2 size={15} /></button></td>}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      <Modal open={showAdd} onClose={() => setShowAdd(false)} title="Record Expense" footer={<>
        <button className="btn btn-secondary" onClick={() => setShowAdd(false)}>Cancel</button>
        <button className="btn btn-primary" onClick={save}>Save</button>
      </>}>
        <div className="form-row">
          <div className="form-group"><label>Category</label>
            <select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })}>
              <option value="operations">Operations</option><option value="admin">Administration</option>
              <option value="welfare">Welfare</option><option value="events">Events</option><option value="other">Other</option>
            </select></div>
          <div className="form-group"><label>Amount (KES)</label><input type="number" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} /></div>
        </div>
        <div className="form-group"><label>Description</label><input value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} /></div>
        <div className="form-group"><label>Date</label><input type="date" value={form.expense_date} onChange={(e) => setForm({ ...form, expense_date: e.target.value })} /></div>
        <div className="form-group"><label>Notes</label><input value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} /></div>
      </Modal>
    </div>
  )
}
