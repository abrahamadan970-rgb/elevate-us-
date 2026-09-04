import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageEvents } from '../lib/permissions'
import { formatDate, todayISO } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, Trash2, Pencil, CalendarDays } from 'lucide-react'
import type { EventItem, EventType } from '../types'

export default function EventsPage() {
  const { profile } = useAuth()
  const [rows, setRows] = useState<EventItem[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [editing, setEditing] = useState<EventItem | null>(null)
  const [form, setForm] = useState({ title: '', description: '', event_type: 'meeting' as EventType, event_date: todayISO(), event_time: '18:00', location: '', is_recurring: false, recurrence_pattern: '' })

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const { data } = await supabase.from('events').select('*').order('event_date', { ascending: true })
    setRows(data ?? [])
    setLoading(false)
  }

  async function save() {
    if (!form.title) { toast('Title required', 'error'); return }
    const payload = {
      title: form.title, description: form.description || null, event_type: form.event_type,
      event_date: form.event_date, event_time: form.event_time || null, location: form.location || null,
      is_recurring: form.is_recurring, recurrence_pattern: form.recurrence_pattern || null, created_by: profile?.id,
    }
    if (editing) {
      const { error } = await supabase.from('events').update(payload).eq('id', editing.id)
      if (error) { toast(error.message, 'error'); return }
      toast('Event updated')
    } else {
      const { error } = await supabase.from('events').insert(payload)
      if (error) { toast(error.message, 'error'); return }
      toast('Event created')
    }
    setShowAdd(false); setEditing(null); load()
  }

  async function remove(id: string) {
    if (!confirm('Delete this event?')) return
    const { error } = await supabase.from('events').delete().eq('id', id)
    if (error) { toast(error.message, 'error'); return }
    toast('Event deleted'); load()
  }

  function openEdit(e: EventItem) {
    setEditing(e)
    setForm({ title: e.title, description: e.description ?? '', event_type: e.event_type, event_date: e.event_date, event_time: e.event_time ?? '18:00', location: e.location ?? '', is_recurring: e.is_recurring ?? false, recurrence_pattern: e.recurrence_pattern ?? '' })
    setShowAdd(true)
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canManage = canManageEvents(profile?.role)
  const upcoming = rows.filter((r) => r.event_date >= todayISO())
  const past = rows.filter((r) => r.event_date < todayISO())

  return (
    <div>
      <div className="card mb-4">
        <div className="card-header">
          <h3>Upcoming Events</h3>
          {canManage && <button className="btn btn-primary" onClick={() => { setEditing(null); setForm({ title: '', description: '', event_type: 'meeting', event_date: todayISO(), event_time: '18:00', location: '', is_recurring: false, recurrence_pattern: '' }); setShowAdd(true) }}><Plus size={16} /> New Event</button>}
        </div>
        <div className="card-body">
          {upcoming.length === 0 ? <div className="empty"><CalendarDays /> No upcoming events</div> : (
            <div className="grid-3">
              {upcoming.map((e) => (
                <div key={e.id} className="muted-box" style={{ background: 'var(--surface)' }}>
                  <div className="flex items-center justify-between mb-2">
                    <span className="badge badge-info">{e.event_type}</span>
                    {canManage && <div className="flex gap-2"><button className="btn-ghost" onClick={() => openEdit(e)}><Pencil size={14} /></button><button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(e.id)}><Trash2 size={14} /></button></div>}
                  </div>
                  <div style={{ fontWeight: 700, fontSize: 16 }}>{e.title}</div>
                  <div className="text-sm text-muted">{formatDate(e.event_date)} {e.event_time ?? ''}</div>
                  {e.location && <div className="text-sm text-muted">📍 {e.location}</div>}
                  {e.description && <div className="text-sm" style={{ marginTop: 8 }}>{e.description}</div>}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      <div className="card">
        <div className="card-header"><h3>Past Events</h3></div>
        <div className="table-wrap">
          <table className="data-table">
            <thead><tr><th>Title</th><th>Type</th><th>Date</th><th>Location</th></tr></thead>
            <tbody>
              {past.length === 0 && <tr><td colSpan={4} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No past events</td></tr>}
              {past.map((e) => (
                <tr key={e.id}>
                  <td>{e.title}</td>
                  <td><span className="badge badge-neutral">{e.event_type}</span></td>
                  <td>{formatDate(e.event_date)}</td>
                  <td>{e.location ?? '—'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <Modal open={showAdd} onClose={() => setShowAdd(false)} title={editing ? 'Edit Event' : 'New Event'} footer={<>
        <button className="btn btn-secondary" onClick={() => setShowAdd(false)}>Cancel</button>
        <button className="btn btn-primary" onClick={save}>Save</button>
      </>}>
        <div className="form-group"><label>Title</label><input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} /></div>
        <div className="form-row">
          <div className="form-group"><label>Type</label>
            <select value={form.event_type} onChange={(e) => setForm({ ...form, event_type: e.target.value as EventType })}>
              <option value="meeting">Meeting</option><option value="event">Event</option><option value="fundraiser">Fundraiser</option><option value="other">Other</option>
            </select></div>
          <div className="form-group"><label>Date</label><input type="date" value={form.event_date} onChange={(e) => setForm({ ...form, event_date: e.target.value })} /></div>
        </div>
        <div className="form-row">
          <div className="form-group"><label>Time</label><input type="time" value={form.event_time} onChange={(e) => setForm({ ...form, event_time: e.target.value })} /></div>
          <div className="form-group"><label>Location</label><input value={form.location} onChange={(e) => setForm({ ...form, location: e.target.value })} /></div>
        </div>
        <div className="form-group"><label>Description</label><textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} /></div>
      </Modal>
    </div>
  )
}
