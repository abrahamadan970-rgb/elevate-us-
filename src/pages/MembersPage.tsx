import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageMembers, canManageFinance } from '../lib/permissions'
import { formatCurrency, formatDate, todayISO } from '../lib/format'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Plus, UserPlus, Trash2, Pencil, AlertTriangle, Mail } from 'lucide-react'
import type { Member, MemberStatus, UserRole } from '../types'

export default function MembersPage() {
  const { profile } = useAuth()
  const [members, setMembers] = useState<Member[]>([])
  const [loading, setLoading] = useState(true)
  const [showAdd, setShowAdd] = useState(false)
  const [editing, setEditing] = useState<Member | null>(null)
  const [creatingAccountFor, setCreatingAccountFor] = useState<Member | null>(null)
  const [accountPassword, setAccountPassword] = useState('ElevateUS2024!')
  const [accountRole, setAccountRole] = useState<UserRole>('member')
  const [accountBusy, setAccountBusy] = useState(false)
  const [sendingEmails, setSendingEmails] = useState(false)

  async function sendAllCredentials() {
    setSendingEmails(true)
    try {
      const url = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-credentials`
      const res = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
        },
        body: JSON.stringify({}),
      })
      const data = await res.json()
      if (data.sent > 0) toast(`Sent ${data.sent} credential email(s) successfully`)
      if (data.failed > 0) toast(`${data.failed} email(s) failed — verify your domain at resend.com/domains`, 'error')
      if (data.sent === 0 && data.failed > 0) toast('Emails could not be sent — you need to verify a sending domain in Resend', 'error')
    } catch {
      toast('Failed to send credentials emails', 'error')
    } finally {
      setSendingEmails(false)
    }
  }

  const [form, setForm] = useState({
    full_name: '', phone: '', email: '', join_date: todayISO(), status: 'active' as MemberStatus, notes: '',
  })

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const { data } = await supabase.from('members').select('*').order('full_name')
    setMembers(data ?? [])
    setLoading(false)
  }

  async function save() {
    if (!form.full_name.trim()) { toast('Name is required', 'error'); return }
    if (editing) {
      const { error } = await supabase.from('members').update({
        full_name: form.full_name, phone: form.phone || null, email: form.email || null,
        join_date: form.join_date, status: form.status, notes: form.notes || null,
      }).eq('id', editing.id)
      if (error) { toast(error.message, 'error'); return }
      toast('Member updated')
    } else {
      const { error } = await supabase.from('members').insert({
        full_name: form.full_name, phone: form.phone || null, email: form.email || null,
        join_date: form.join_date, status: form.status, notes: form.notes || null,
      })
      if (error) { toast(error.message, 'error'); return }
      toast('Member added')
    }
    setShowAdd(false); setEditing(null); resetForm(); load()
  }

  async function remove(m: Member) {
    if (!confirm(`Delete member "${m.full_name}"? This cannot be undone.`)) return
    const { error } = await supabase.from('members').delete().eq('id', m.id)
    if (error) { toast(error.message, 'error'); return }
    toast('Member deleted'); load()
  }

  async function createAccount() {
    if (!creatingAccountFor?.email) { toast('Member needs an email to create an account', 'error'); return }
    setAccountBusy(true)
    try {
      const { data: session } = await supabase.auth.getSession()
      const url = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/create-member-account`
      const res = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${session.session?.access_token ?? import.meta.env.VITE_SUPABASE_ANON_KEY}`,
        },
        body: JSON.stringify({
          email: creatingAccountFor.email,
          full_name: creatingAccountFor.full_name,
          role: accountRole,
          phone: creatingAccountFor.phone,
          default_password: accountPassword,
        }),
      })
      const data = await res.json()
      if (!res.ok) { toast(data.error || 'Failed to create account', 'error'); return }
      const wasAlreadyLinked = !!creatingAccountFor.user_id
      await supabase.from('members').update({ user_id: data.user_id }).eq('id', creatingAccountFor.id)
      toast(wasAlreadyLinked ? 'Account already existed — profile synced and linked to member' : `Account created. Temporary password: ${accountPassword}`)
      setCreatingAccountFor(null); load()
    } finally {
      setAccountBusy(false)
    }
  }

  function resetForm() {
    setForm({ full_name: '', phone: '', email: '', join_date: todayISO(), status: 'active', notes: '' })
  }

  function openEdit(m: Member) {
    setEditing(m)
    setForm({
      full_name: m.full_name, phone: m.phone ?? '', email: m.email ?? '',
      join_date: m.join_date, status: m.status, notes: m.notes ?? '',
    })
    setShowAdd(true)
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canManage = canManageMembers(profile?.role)
  const canFinance = canManageFinance(profile?.role)

  return (
    <div>
      <div className="card">
        <div className="card-header">
          <h3>Members ({members.length})</h3>
          <div className="flex gap-2">
            {canManage && (
              <button className="btn btn-secondary" onClick={sendAllCredentials} disabled={sendingEmails}>
                <Mail size={16} /> {sendingEmails ? 'Sending...' : 'Send Credentials'}
              </button>
            )}
            {canManage && (
              <button className="btn btn-primary" onClick={() => { resetForm(); setEditing(null); setShowAdd(true) }}>
                <Plus size={16} /> Add Member
              </button>
            )}
          </div>
        </div>
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr>
                <th>Name</th><th>Phone</th><th>Email</th><th>Joined</th><th>Status</th><th>Account</th>
                {canManage && <th></th>}
              </tr>
            </thead>
            <tbody>
              {members.length === 0 && (
                <tr><td colSpan={7} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No members yet</td></tr>
              )}
              {members.map((m) => (
                <tr key={m.id}>
                  <td>
                    <div style={{ fontWeight: 600 }}>{m.full_name}</div>
                    {m.is_defaulter && <span className="badge badge-error" style={{ marginTop: 4 }}><AlertTriangle size={11} /> Defaulter</span>}
                  </td>
                  <td>{m.phone ?? '—'}</td>
                  <td>{m.email ?? '—'}</td>
                  <td>{formatDate(m.join_date)}</td>
                  <td><span className={`badge ${m.status === 'active' ? 'badge-success' : 'badge-neutral'}`}>{m.status}</span></td>
                  <td>
                    {m.user_id ? (
                      <span className="badge badge-success">Linked</span>
                    ) : canManage && m.email ? (
                      <button className="btn btn-secondary btn-sm" onClick={() => { setCreatingAccountFor(m); setAccountPassword('ElevateUS2024!'); setAccountRole('member') }}>
                        <UserPlus size={13} /> Create
                      </button>
                    ) : '—'}
                  </td>
                  {canManage && (
                    <td>
                      <div className="flex gap-2">
                        <button className="btn-ghost" onClick={() => openEdit(m)}><Pencil size={15} /></button>
                        <button className="btn-ghost" style={{ color: 'var(--error)' }} onClick={() => remove(m)}><Trash2 size={15} /></button>
                      </div>
                    </td>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <Modal
        open={showAdd}
        onClose={() => setShowAdd(false)}
        title={editing ? 'Edit Member' : 'Add Member'}
        footer={<>
          <button className="btn btn-secondary" onClick={() => setShowAdd(false)}>Cancel</button>
          <button className="btn btn-primary" onClick={save}>Save</button>
        </>}
      >
        <div className="form-group"><label>Full Name</label>
          <input value={form.full_name} onChange={(e) => setForm({ ...form, full_name: e.target.value })} /></div>
        <div className="form-row">
          <div className="form-group"><label>Phone</label>
            <input value={form.phone} onChange={(e) => setForm({ ...form, phone: e.target.value })} /></div>
          <div className="form-group"><label>Email</label>
            <input value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} /></div>
        </div>
        <div className="form-row">
          <div className="form-group"><label>Join Date</label>
            <input type="date" value={form.join_date} onChange={(e) => setForm({ ...form, join_date: e.target.value })} /></div>
          <div className="form-group"><label>Status</label>
            <select value={form.status} onChange={(e) => setForm({ ...form, status: e.target.value as MemberStatus })}>
              <option value="active">Active</option><option value="inactive">Inactive</option><option value="suspended">Suspended</option>
            </select></div>
        </div>
        <div className="form-group"><label>Notes</label>
          <textarea value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} /></div>
      </Modal>

      <Modal
        open={!!creatingAccountFor}
        onClose={() => setCreatingAccountFor(null)}
        title="Create Login Account"
        size="sm"
        footer={<>
          <button className="btn btn-secondary" onClick={() => setCreatingAccountFor(null)}>Cancel</button>
          <button className="btn btn-primary" onClick={createAccount} disabled={accountBusy}>{accountBusy ? <span className="spinner" /> : 'Create Account'}</button>
        </>}
      >
        <p className="text-sm text-muted mb-4">
          Create a login account for <strong>{creatingAccountFor?.full_name}</strong> using their email <strong>{creatingAccountFor?.email}</strong>.
          They can sign in immediately with the temporary password below and will be prompted to change it.
        </p>
        <div className="form-group"><label>Temporary Password</label>
          <input value={accountPassword} onChange={(e) => setAccountPassword(e.target.value)} /></div>
        <div className="form-group"><label>Role</label>
          <select value={accountRole} onChange={(e) => setAccountRole(e.target.value as UserRole)}>
            <option value="member">Member</option>
            <option value="leader">Leader</option>
            <option value="secretary">Secretary</option>
            <option value="treasurer">Treasurer</option>
            <option value="admin">Admin</option>
          </select>
          <p className="text-sm text-muted" style={{ marginTop: 6 }}>The member will be prompted to change this password on first login.</p>
        </div>
      </Modal>
    </div>
  )
}
