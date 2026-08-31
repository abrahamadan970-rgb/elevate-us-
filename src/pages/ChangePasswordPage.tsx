import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { toast } from '../components/Toast'
import { KeyRound } from 'lucide-react'

export default function ChangePasswordPage() {
  const { profile, refreshProfile } = useAuth()
  const navigate = useNavigate()
  const [current, setCurrent] = useState('')
  const [next, setNext] = useState('')
  const [confirm, setConfirm] = useState('')
  const [busy, setBusy] = useState(false)

  async function submit() {
    if (!next || next.length < 6) { toast('New password must be at least 6 characters', 'error'); return }
    if (next !== confirm) { toast('Passwords do not match', 'error'); return }
    setBusy(true)
    try {
      const { error: authErr } = await supabase.auth.updateUser({ password: next })
      if (authErr) { toast(authErr.message, 'error'); return }
      if (profile?.must_change_password) {
        await supabase.from('profiles').update({ must_change_password: false }).eq('id', profile.id)
        await refreshProfile()
      }
      toast('Password changed successfully')
      navigate('/portal')
    } finally {
      setBusy(false)
    }
  }

  return (
    <div style={{ maxWidth: 460, margin: '40px auto' }}>
      <div className="card">
        <div className="card-header"><h3><KeyRound size={18} style={{ display: 'inline', marginRight: 8 }} />Change Password</h3></div>
        <div className="card-body">
          {profile?.must_change_password && <div className="muted-box mb-4">You must change your temporary password before continuing.</div>}
          <div className="form-group"><label>Current Password</label><input type="password" value={current} onChange={(e) => setCurrent(e.target.value)} /></div>
          <div className="form-group"><label>New Password</label><input type="password" value={next} onChange={(e) => setNext(e.target.value)} /></div>
          <div className="form-group"><label>Confirm New Password</label><input type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} /></div>
          <button className="btn btn-primary w-full" onClick={submit} disabled={busy}>{busy ? <span className="spinner" /> : 'Update Password'}</button>
        </div>
      </div>
    </div>
  )
}
