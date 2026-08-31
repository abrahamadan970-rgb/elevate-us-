import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageMembers } from '../lib/permissions'
import { formatDate, todayISO } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, Trash2, Pencil, Crown } from 'lucide-react'
import type { Leader, Member } from '../types'

export default function LeadersPage() {
  const { profile } = useAuth()
  const [rows, setRows] = useState<Leader[]>([])
  const [members, setMembers] = useState<Member[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [editing, setEditing] = useState<Leader | null>(null)
  const [form, setForm] = useState({ position: '', position_description: '', member_id: '', start_date: todayISO(), end_date: '', is_active: true })

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const [ldrs, mems] = await Promise.all([
      supabase.from('leaders').select('*, member:members(full_name)').order('start_date', { ascending: false }),
      supabase.from('members').select('*').eq('status', 'active').order('full_name'),
    ])
    setRows(ldrs.data ?? [])
    setMembers(mems.data ?? [])
    setLoading(false)
  }

  async function save() {
    if (!form.position) { toast('Position required', 'error'); return }
    const payload = {
      position: form.position, position_description: form.position_description || null,
      member_id: form.member_id || null, start_date: form.start_date,
      end_date: form.end_date || null, is_active: form.is_active,
    }
    if (editing) {
      const { error } = await supabase.from('leaders').update(payload).eq('id', editing.id)
      if (error) { toast(error.message, 'error'); return }
      toast('Leader updated')
    } else {
      const { error } = await supabase.from('leaders').insert(payload)
      if (error) { toast(error.message, 'error'); return }
      toast('Leader added')
    }
    setShowAdd(false); setEditing(null); load()
  }

  async function remove(id: string) {
    if (!confirm('Delete this leadership record?')) return
    const { error } = await supabase.from('leaders').delete().eq('id', id)
    if (error) { toast(error.message, 'error'); return }
    toast('Leader deleted'); load()
  }

  function openEdit(l: Leader) {
    setEditing(l)
    setForm({ position: l.position, position_description: l.position_description ?? '', member_id: l.member_id ?? '', start_date: l.start_date, end_date: l.end_date ?? '', is_active: l.is_active })
    setShowAdd(true)
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canManage = canManageMembers(profile?.role)

  return (
    <div>
      <div className="card">
        <div className="card-header">
          <h3>Leadership</h3>
          {canManage && <button className="btn btn-primary" onClick={() => { setEditing(null); setForm({ position: '', position_description: '', member_id: '', start_date: todayISO(), end_date: '', is_active: true }); setShowAdd(true) }}><Plus size={16} /> Add Leader</button>}
        </div>
        <div className="table-wrap">
          <table className="data-table">
            <thead><tr><th>Position</th><th>Holder</th><th>Description</th><th>Since</th><th>Until</th><th>Status</th>{canManage && <th></th>}</tr></thead>
            <tbody>
              {rows.length === 0 && <tr><td colSpan={7} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No leaders recorded</td></tr>}
              {rows.map((l) => (
                <tr key={l.id}>
                  <td><div className="flex items-center gap-2"><Crown size={14} style={{ color: '#d97706' }} /><strong>{l.position}</strong></div></td>
                  <td>{l.member?.full_name ?? '—'}</td>
                  <td className="text-sm text-muted">{l.position_description ?? '—'}</td>
                  <td>{formatDate(l.start_date)}</td>
                  <td>{formatDate(l.end_date)}</td>
                  <td>{l.is_active ? <span className="badge badge-success">Active</span> : <span className="badge badge-neutral">Past</span>}</td>
                  {canManage && <td><div className="flex gap-2"><button className="btn-ghost" onClick={() => openEdit(l)}><Pencil size={15} /></button><button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(l.id)}><Trash2 size={15} /></button></div></td>}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      <Modal open={showAdd} onClose={() => setShowAdd(false)} title={editing ? 'Edit Leader' : 'Add Leader'} footer={<>
        <button className="btn btn-secondary" onClick={() => setShowAdd(false)}>Cancel</button>
        <button className="btn btn-primary" onClick={save}>Save</button>
      </>}>
        <div className="form-group"><label>Position</label><input value={form.position} onChange={(e) => setForm({ ...form, position: e.target.value })} placeholder="e.g. Chairperson" /></div>
        <div className="form-group"><label>Member</label>
          <select value={form.member_id} onChange={(e) => setForm({ ...form, member_id: e.target.value })}>
            <option value="">—</option>
            {members.map((m) => <option key={m.id} value={m.id}>{m.full_name}</option>)}
          </select></div>
        <div className="form-group"><label>Description</label><input value={form.position_description} onChange={(e) => setForm({ ...form, position_description: e.target.value })} /></div>
        <div className="form-row">
          <div className="form-group"><label>Start Date</label><input type="date" value={form.start_date} onChange={(e) => setForm({ ...form, start_date: e.target.value })} /></div>
          <div className="form-group"><label>End Date</label><input type="date" value={form.end_date} onChange={(e) => setForm({ ...form, end_date: e.target.value })} /></div>
        </div>
        <div className="form-group"><label><input type="checkbox" checked={form.is_active} onChange={(e) => setForm({ ...form, is_active: e.target.checked })} /> Active</label></div>
      </Modal>
    </div>
  )
}
