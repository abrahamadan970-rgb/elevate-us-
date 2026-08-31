import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageMinutes } from '../lib/permissions'
import { formatDate, todayISO } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, Trash2, Pencil, FileText, Upload, ExternalLink } from 'lucide-react'
import type { Minute } from '../types'

export default function MinutesPage() {
  const { profile } = useAuth()
  const [rows, setRows] = useState<Minute[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [editing, setEditing] = useState<Minute | null>(null)
  const [viewing, setViewing] = useState<Minute | null>(null)
  const [uploading, setUploading] = useState(false)
  const [form, setForm] = useState({ title: '', meeting_date: todayISO(), meeting_type: 'general', attendees: '', agenda: '', discussion: '', decisions: '', action_items: '', attachment_url: '' as string | null })

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const { data } = await supabase.from('minutes').select('*').order('meeting_date', { ascending: false })
    setRows(data ?? [])
    setLoading(false)
  }

  async function save() {
    if (!form.title) { toast('Title required', 'error'); return }
    const payload = {
      title: form.title, meeting_date: form.meeting_date, meeting_type: form.meeting_type,
      attendees: form.attendees || null, agenda: form.agenda || null, discussion: form.discussion || null,
      decisions: form.decisions || null, action_items: form.action_items || null, created_by: profile?.id,
      attachment_url: form.attachment_url || null,
    }
    if (editing) {
      const { error } = await supabase.from('minutes').update(payload).eq('id', editing.id)
      if (error) { toast(error.message, 'error'); return }
      toast('Minutes updated')
    } else {
      const { error } = await supabase.from('minutes').insert(payload)
      if (error) { toast(error.message, 'error'); return }
      toast('Minutes recorded')
    }
    setShowAdd(false); setEditing(null); load()
  }

  async function remove(m: Minute) {
    if (!confirm('Delete these minutes?')) return
    if (m.attachment_url) {
      const path = m.attachment_url.split('/minutes/')[1]
      if (path) await supabase.storage.from('minutes').remove([path])
    }
    const { error } = await supabase.from('minutes').delete().eq('id', m.id)
    if (error) { toast(error.message, 'error'); return }
    toast('Minutes deleted'); load()
  }

  async function uploadPDF(file: File) {
    if (file.type !== 'application/pdf') { toast('Only PDF files are allowed', 'error'); return }
    if (file.size > 10 * 1024 * 1024) { toast('File too large (max 10MB)', 'error'); return }
    setUploading(true)
    const ext = file.name.split('.').pop()
    const fileName = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}.${ext}`
    const path = `${fileName}`
    const { error: upErr } = await supabase.storage.from('minutes').upload(path, file, { contentType: 'application/pdf', upsert: false })
    if (upErr) { toast(upErr.message, 'error'); setUploading(false); return }
    const { data: pub } = supabase.storage.from('minutes').getPublicUrl(path)
    setForm((f) => ({ ...f, attachment_url: pub.publicUrl }))
    toast('PDF uploaded')
    setUploading(false)
  }

  function openEdit(m: Minute) {
    setEditing(m)
    setForm({ title: m.title, meeting_date: m.meeting_date, meeting_type: m.meeting_type, attendees: m.attendees ?? '', agenda: m.agenda ?? '', discussion: m.discussion ?? '', decisions: m.decisions ?? '', action_items: m.action_items ?? '', attachment_url: m.attachment_url })
    setShowAdd(true)
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canManage = canManageMinutes(profile?.role)

  return (
    <div>
      <div className="card">
        <div className="card-header">
          <h3>Meeting Minutes</h3>
          {canManage && <button className="btn btn-primary" onClick={() => { setEditing(null); setForm({ title: '', meeting_date: todayISO(), meeting_type: 'general', attendees: '', agenda: '', discussion: '', decisions: '', action_items: '', attachment_url: null }); setShowAdd(true) }}><Plus size={16} /> New Minutes</button>}
        </div>
        <div className="table-wrap">
          <table className="data-table">
            <thead><tr><th>Title</th><th>Date</th><th>Type</th><th>Attendees</th><th>PDF</th><th></th></tr></thead>
            <tbody>
              {rows.length === 0 && <tr><td colSpan={6} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No minutes recorded</td></tr>}
              {rows.map((m) => (
                <tr key={m.id}>
                  <td><div className="flex items-center gap-2"><FileText size={14} style={{ color: 'var(--primary)' }} /><strong>{m.title}</strong></div></td>
                  <td>{formatDate(m.meeting_date)}</td>
                  <td><span className="badge badge-neutral">{m.meeting_type}</span></td>
                  <td className="text-sm text-muted">{m.attendees ? (m.attendees.length > 40 ? m.attendees.slice(0, 40) + '…' : m.attendees) : '—'}</td>
                  <td>
                    {m.attachment_url ? (
                      <a href={m.attachment_url} target="_blank" rel="noopener noreferrer" className="btn btn-secondary btn-sm" style={{ display: 'inline-flex', alignItems: 'center', gap: 4 }}>
                        <ExternalLink size={13} /> View PDF
                      </a>
                    ) : (
                      <span style={{ color: 'var(--text-muted)', fontSize: 13 }}>—</span>
                    )}
                  </td>
                  <td>
                    <div className="flex gap-2">
                      <button className="btn btn-secondary btn-sm" onClick={() => setViewing(m)}>View</button>
                      {canManage && <button className="btn-ghost" onClick={() => openEdit(m)}><Pencil size={15} /></button>}
                      {canManage && <button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(m)}><Trash2 size={15} /></button>}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <Modal open={showAdd} onClose={() => setShowAdd(false)} title={editing ? 'Edit Minutes' : 'New Minutes'} size="lg" footer={<>
        <button className="btn btn-secondary" onClick={() => setShowAdd(false)}>Cancel</button>
        <button className="btn btn-primary" onClick={save}>Save</button>
      </>}>
        <div className="form-row">
          <div className="form-group"><label>Title</label><input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} /></div>
          <div className="form-group"><label>Meeting Date</label><input type="date" value={form.meeting_date} onChange={(e) => setForm({ ...form, meeting_date: e.target.value })} /></div>
        </div>
        <div className="form-group"><label>Meeting Type</label>
          <select value={form.meeting_type} onChange={(e) => setForm({ ...form, meeting_type: e.target.value })}>
            <option value="general">General</option><option value="agm">AGM</option><option value="emergency">Emergency</option><option value="committee">Committee</option>
          </select></div>
        <div className="form-group"><label>Attendees</label><input value={form.attendees} onChange={(e) => setForm({ ...form, attendees: e.target.value })} placeholder="Comma separated names" /></div>

        <div className="form-group">
          <label>PDF Attachment</label>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {form.attachment_url ? (
              <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 12px', background: 'var(--surface-2, var(--card-bg))', borderRadius: 8, border: '1px solid var(--border)' }}>
                <FileText size={18} color="var(--brand)" />
                <a href={form.attachment_url} target="_blank" rel="noopener noreferrer" style={{ flex: 1, fontSize: 13, color: 'var(--brand)', textDecoration: 'none' }}>View uploaded PDF</a>
                <button type="button" className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => setForm({ ...form, attachment_url: null })}><Trash2 size={15} /></button>
              </div>
            ) : (
              <label className="btn btn-secondary" style={{ cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 6, justifyContent: 'center' }}>
                <Upload size={16} /> {uploading ? 'Uploading...' : 'Upload PDF'}
                <input type="file" accept="application/pdf" style={{ display: 'none' }} onChange={(e) => { const f = e.target.files?.[0]; if (f) uploadPDF(f); e.target.value = '' }} />
              </label>
            )}
          </div>
        </div>

        <div className="form-group"><label>Agenda</label><textarea value={form.agenda} onChange={(e) => setForm({ ...form, agenda: e.target.value })} /></div>
        <div className="form-group"><label>Discussion</label><textarea value={form.discussion} onChange={(e) => setForm({ ...form, discussion: e.target.value })} /></div>
        <div className="form-group"><label>Decisions</label><textarea value={form.decisions} onChange={(e) => setForm({ ...form, decisions: e.target.value })} /></div>
        <div className="form-group"><label>Action Items</label><textarea value={form.action_items} onChange={(e) => setForm({ ...form, action_items: e.target.value })} /></div>
      </Modal>

      <Modal open={!!viewing} onClose={() => setViewing(null)} title={viewing?.title ?? ''} size="lg">
        <div style={{ display: 'grid', gap: 14 }}>
          <div className="muted-box">📅 {formatDate(viewing?.meeting_date)} · <span className="badge badge-neutral">{viewing?.meeting_type}</span></div>
          {viewing?.attachment_url && (
            <a href={viewing.attachment_url} target="_blank" rel="noopener noreferrer" className="btn btn-primary" style={{ display: 'inline-flex', alignItems: 'center', gap: 6, justifyContent: 'center' }}>
              <ExternalLink size={16} /> Open PDF Attachment
            </a>
          )}
          {viewing?.attendees && <div><strong>Attendees:</strong><p className="text-sm">{viewing.attendees}</p></div>}
          {viewing?.agenda && <div><strong>Agenda:</strong><p className="text-sm" style={{ whiteSpace: 'pre-wrap' }}>{viewing.agenda}</p></div>}
          {viewing?.discussion && <div><strong>Discussion:</strong><p className="text-sm" style={{ whiteSpace: 'pre-wrap' }}>{viewing.discussion}</p></div>}
          {viewing?.decisions && <div><strong>Decisions:</strong><p className="text-sm" style={{ whiteSpace: 'pre-wrap' }}>{viewing.decisions}</p></div>}
          {viewing?.action_items && <div><strong>Action Items:</strong><p className="text-sm" style={{ whiteSpace: 'pre-wrap' }}>{viewing.action_items}</p></div>}
        </div>
      </Modal>
    </div>
  )
}
