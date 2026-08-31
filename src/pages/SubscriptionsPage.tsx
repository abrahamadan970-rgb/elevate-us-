import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageFinance, canDeleteTransactions } from '../lib/permissions'
import { formatCurrency, formatDate, monthName, currentMonth, currentYear, todayISO } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, Trash2, Download, Pencil, ChevronDown, ChevronRight } from 'lucide-react'
import type { Subscription, Member } from '../types'

export default function SubscriptionsPage() {
  const { profile } = useAuth()
  const [rows, setRows] = useState<Subscription[]>([])
  const [members, setMembers] = useState<Member[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [editing, setEditing] = useState<Subscription | null>(null)
  const [filterYear, setFilterYear] = useState<number | 'all'>(currentYear())
  const [grandTotal, setGrandTotal] = useState(0)
  const [withdrawnTotal, setWithdrawnTotal] = useState(0)
  const [allTimeRecords, setAllTimeRecords] = useState(0)
  const [expandedMonths, setExpandedMonths] = useState<Set<string>>(new Set())

  const [form, setForm] = useState({
    member_id: '', amount: '', payment_date: todayISO(),
    payment_month: currentMonth(), payment_year: currentYear(),
    payment_method: 'cash', receipt_number: '', notes: '',
  })

  useEffect(() => { load() }, [filterYear])

  async function load() {
    setLoading(true)
    const [allSubs, mems] = await Promise.all([
      supabase.from('subscriptions').select('*, member:members(full_name,status)').order('payment_date', { ascending: false }),
      supabase.from('members').select('*').eq('status', 'active').order('full_name'),
    ])
    const all = allSubs.data ?? []
    const leftSubs = all.filter((r) => r.member?.status === 'left')
    const activeSubs = all.filter((r) => r.member?.status !== 'left')
    setAllTimeRecords(activeSubs.length)
    setWithdrawnTotal(leftSubs.reduce((s, r) => s + Number(r.amount), 0))
    setGrandTotal(activeSubs.reduce((s, r) => s + Number(r.amount), 0))
    setRows(filterYear === 'all' ? activeSubs : activeSubs.filter((r) => r.payment_year === filterYear))
    setMembers(mems.data ?? [])
    setLoading(false)
  }

  function openAdd() {
    setEditing(null)
    setForm({
      member_id: '', amount: '', payment_date: todayISO(),
      payment_month: currentMonth(), payment_year: currentYear(),
      payment_method: 'cash', receipt_number: '', notes: '',
    })
    setShowAdd(true)
  }

  function openEdit(r: Subscription) {
    setEditing(r)
    setForm({
      member_id: r.member_id, amount: String(r.amount), payment_date: r.payment_date,
      payment_month: r.payment_month, payment_year: r.payment_year,
      payment_method: r.payment_method ?? 'cash', receipt_number: r.receipt_number ?? '',
      notes: r.notes ?? '',
    })
    setShowAdd(true)
  }

  async function save() {
    if (!form.member_id || !form.amount) { toast('Member and amount required', 'error'); return }
    const payload = {
      member_id: form.member_id,
      amount: Number(form.amount),
      payment_date: form.payment_date,
      payment_month: Number(form.payment_month),
      payment_year: Number(form.payment_year),
      payment_method: form.payment_method,
      receipt_number: form.receipt_number || null,
      notes: form.notes || null,
    }
    if (editing) {
      const { error } = await supabase.from('subscriptions').update(payload).eq('id', editing.id)
      if (error) { toast(error.message, 'error'); return }
      toast('Subscription updated')
    } else {
      const { error } = await supabase.from('subscriptions').insert({ ...payload, recorded_by: profile?.id })
      if (error) { toast(error.message, 'error'); return }
      toast('Subscription recorded')
    }
    setShowAdd(false); setEditing(null); load()
  }

  async function remove(id: string) {
    if (!confirm('Delete this subscription record?')) return
    const { error } = await supabase.from('subscriptions').delete().eq('id', id)
    if (error) { toast(error.message, 'error'); return }
    toast('Subscription deleted'); load()
  }

  function exportCSV() {
    const headers = ['Member', 'Amount', 'Date', 'Month', 'Year', 'Method', 'Receipt']
    const lines = rows.map((r) => [r.member?.full_name, r.amount, r.payment_date, monthName(r.payment_month), r.payment_year, r.payment_method, r.receipt_number])
    const csv = [headers, ...lines].map((l) => l.map((c) => `"${String(c ?? '').replace(/"/g, '""')}"`).join(',')).join('\n')
    const blob = new Blob([csv], { type: 'text/csv' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a'); a.href = url; a.download = `subscriptions-${filterYear === 'all' ? 'all-time' : filterYear}.csv`; a.click()
    URL.revokeObjectURL(url)
  }

  function toggleMonth(key: string) {
    setExpandedMonths((prev) => {
      const next = new Set(prev)
      if (next.has(key)) next.delete(key)
      else next.add(key)
      return next
    })
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canFinance = canManageFinance(profile?.role)
  const canDelete = canDeleteTransactions(profile?.role)
  const total = rows.reduce((s, r) => s + Number(r.amount), 0)

  const grouped: { key: string; label: string; items: Subscription[]; subtotal: number }[] = []
  const map = new Map<string, Subscription[]>()
  for (const r of rows) {
    const key = `${r.payment_year}-${String(r.payment_month).padStart(2, '0')}`
    if (!map.has(key)) map.set(key, [])
    map.get(key)!.push(r)
  }
  for (const [key, items] of Array.from(map.entries()).sort().reverse()) {
    const [yr, mo] = key.split('-').map(Number)
    grouped.push({ key, label: `${monthName(mo)} ${yr}`, items, subtotal: items.reduce((s, r) => s + Number(r.amount), 0) })
  }

  const allExpanded = grouped.length > 0 && grouped.every((g) => expandedMonths.has(g.key))

  return (
    <div>
      <div className="stat-grid">
        <div className="stat-card"><div className="stat-label">Total Subscriptions (All Time)</div><div className="stat-value">{formatCurrency(grandTotal)}</div></div>
        {withdrawnTotal > 0 && <div className="stat-card"><div className="stat-label">Withdrawn (Left Members)</div><div className="stat-value" style={{ color: 'var(--error)' }}>−{formatCurrency(withdrawnTotal)}</div></div>}
        <div className="stat-card"><div className="stat-label">Total {filterYear === 'all' ? 'All Time' : filterYear}</div><div className="stat-value">{formatCurrency(total)}</div></div>
        <div className="stat-card"><div className="stat-label">Contributors</div><div className="stat-value">{new Set(rows.map((r) => r.member_id)).size}</div></div>
        <div className="stat-card"><div className="stat-label">Records {filterYear === 'all' ? '(All Time)' : ''}</div><div className="stat-value">{filterYear === 'all' ? allTimeRecords : rows.length}</div></div>
      </div>

      <div className="card">
        <div className="card-header">
          <h3>Subscriptions</h3>
          <div className="flex items-center gap-2">
            <select value={String(filterYear)} onChange={(e) => setFilterYear(e.target.value === 'all' ? 'all' : Number(e.target.value))} style={{ padding: '8px 10px', borderRadius: 8, border: '1px solid var(--border)' }}>
              <option value="all">All Time</option>
              {[currentYear(), currentYear() - 1, currentYear() - 2].map((y) => <option key={y} value={y}>{y}</option>)}
            </select>
            <button className="btn btn-secondary btn-sm" onClick={exportCSV}><Download size={15} /> CSV</button>
            {canFinance && <button className="btn btn-primary" onClick={openAdd}><Plus size={16} /> Record</button>}
          </div>
        </div>

        {grouped.length === 0 ? (
          <div style={{ textAlign: 'center', color: 'var(--text-muted)', padding: '40px 0' }}>No subscriptions recorded</div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8, padding: '0 4px' }}>
            <button className="btn-ghost" style={{ alignSelf: 'flex-start', fontSize: 13, color: 'var(--text-muted)' }} onClick={() => {
              if (allExpanded) setExpandedMonths(new Set())
              else setExpandedMonths(new Set(grouped.map((g) => g.key)))
            }}>
              {allExpanded ? 'Collapse all' : 'Expand all'}
            </button>
            {grouped.map((g) => {
              const isExpanded = expandedMonths.has(g.key)
              return (
                <div key={g.key} style={{ border: '1px solid var(--border)', borderRadius: 10, overflow: 'hidden' }}>
                  <div
                    onClick={() => toggleMonth(g.key)}
                    style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 16px', cursor: 'pointer', background: 'var(--surface-2, var(--card-bg))', userSelect: 'none' }}
                  >
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      {isExpanded ? <ChevronDown size={18} color="var(--text-muted)" /> : <ChevronRight size={18} color="var(--text-muted)" />}
                      <span style={{ fontWeight: 600, fontSize: 15 }}>{g.label}</span>
                      <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>{g.items.length} {g.items.length === 1 ? 'record' : 'records'}</span>
                    </div>
                    <span style={{ fontWeight: 700, color: 'var(--brand)' }}>{formatCurrency(g.subtotal)}</span>
                  </div>
                  {isExpanded && (
                    <div className="table-wrap" style={{ margin: 0 }}>
                      <table className="data-table">
                        <thead><tr><th>Member</th><th>Amount</th><th>Date</th><th>Method</th><th>Receipt</th>{canFinance && <th></th>}{canDelete && <th></th>}</tr></thead>
                        <tbody>
                          {g.items.map((r) => (
                            <tr key={r.id}>
                              <td>{r.member?.full_name ?? '—'}</td>
                              <td>{formatCurrency(r.amount)}</td>
                              <td>{formatDate(r.payment_date)}</td>
                              <td>{r.payment_method ?? 'cash'}</td>
                              <td>{r.receipt_number ?? '—'}</td>
                              {canFinance && <td><button className="btn-ghost" onClick={() => openEdit(r)} title="Edit"><Pencil size={15} /></button></td>}
                              {canDelete && <td><button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(r.id)}><Trash2 size={15} /></button></td>}
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  )}
                </div>
              )
            })}
          </div>
        )}
      </div>

      <Modal open={showAdd} onClose={() => setShowAdd(false)} title={editing ? 'Edit Subscription' : 'Record Subscription'} footer={<>
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
          <div className="form-group"><label>Payment Date</label><input type="date" value={form.payment_date} onChange={(e) => setForm({ ...form, payment_date: e.target.value })} /></div>
        </div>
        <div className="form-row">
          <div className="form-group"><label>Month</label>
            <select value={form.payment_month} onChange={(e) => setForm({ ...form, payment_month: Number(e.target.value) })}>
              {Array.from({ length: 12 }, (_, i) => <option key={i + 1} value={i + 1}>{monthName(i + 1)}</option>)}
            </select></div>
          <div className="form-group"><label>Year</label><input type="number" value={form.payment_year} onChange={(e) => setForm({ ...form, payment_year: Number(e.target.value) })} /></div>
        </div>
        <div className="form-row">
          <div className="form-group"><label>Method</label>
            <select value={form.payment_method} onChange={(e) => setForm({ ...form, payment_method: e.target.value })}>
              <option value="cash">Cash</option><option value="mpesa">M-Pesa</option><option value="bank">Bank</option>
            </select></div>
          <div className="form-group"><label>Receipt No.</label><input value={form.receipt_number} onChange={(e) => setForm({ ...form, receipt_number: e.target.value })} /></div>
        </div>
        <div className="form-group"><label>Notes</label><input value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} /></div>
      </Modal>
    </div>
  )
}
