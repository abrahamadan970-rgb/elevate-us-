import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { Eye, EyeOff, ShieldCheck, ArrowRight } from 'lucide-react'
import { useAuth } from '../contexts/AuthContext'
import { roleLabel } from '../lib/permissions'
import type { UserRole } from '../types'

const SIGNUP_ROLES: { value: UserRole; desc: string }[] = [
  { value: 'member', desc: 'View-only access' },
  { value: 'treasurer', desc: 'Manage finances' },
  { value: 'secretary', desc: 'Manage minutes & members' },
  { value: 'chairperson', desc: 'Oversee & approve' },
]

export default function AuthPage() {
  const { signIn, signUp } = useAuth()
  const navigate = useNavigate()
  const [mode, setMode] = useState<'login' | 'signup'>('login')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [fullName, setFullName] = useState('')
  const [role, setRole] = useState<UserRole>('member')
  const [showPwd, setShowPwd] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [message, setMessage] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setMessage(null)
    setBusy(true)

    try {
      if (mode === 'signup') {
        const { error: signUpError } = await signUp(email.trim(), password, fullName.trim(), role)
        if (signUpError) throw new Error(signUpError)
        setMessage('Account created! You can now sign in.')
        setMode('login')
        setPassword('')
      } else {
        const { error: signInError } = await signIn(email.trim(), password)
        if (signInError) throw new Error(signInError)
        navigate('/portal')
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Something went wrong. Please try again.')
    } finally {
      setBusy(false)
    }
  }

  return (
    <div className="auth-screen">
      <div className="auth-card">
        <div className="brand">
          <div className="logo">E</div>
          <h1>ElevateUS</h1>
          <p className="sub">Members Association Portal</p>
        </div>

        <div className="auth-tabs">
          <button
            className={mode === 'login' ? 'active' : ''}
            onClick={() => { setMode('login'); setError(null); setMessage(null) }}
          >
            Sign In
          </button>
          <button
            className={mode === 'signup' ? 'active' : ''}
            onClick={() => { setMode('signup'); setError(null); setMessage(null) }}
          >
            Create Account
          </button>
        </div>

        {error && <div className="auth-error">{error}</div>}
        {message && <div className="auth-success">{message}</div>}

        <form onSubmit={handleSubmit}>
          {mode === 'signup' && (
            <div className="form-group">
              <label>Full Name</label>
              <input
                type="text"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                required
                placeholder="John Doe"
              />
            </div>
          )}

          <div className="form-group">
            <label>Email Address</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              placeholder="you@example.com"
            />
          </div>

          <div className="form-group">
            <label>Password</label>
            <div className="input-with-icon">
              <input
                type={showPwd ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                minLength={6}
                placeholder="At least 6 characters"
                style={{ paddingRight: '40px' }}
              />
              <button
                type="button"
                className="input-action"
                onClick={() => setShowPwd(!showPwd)}
              >
                {showPwd ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
          </div>

          {mode === 'signup' && (
            <div className="form-group">
              <label>Role</label>
              <div className="role-pick" style={{ gridTemplateColumns: 'repeat(2, 1fr)' }}>
                {SIGNUP_ROLES.map((r) => (
                  <div
                    key={r.value}
                    className={`role-option ${role === r.value ? 'selected' : ''}`}
                    onClick={() => setRole(r.value)}
                  >
                    <div className="role-name">{roleLabel(r.value)}</div>
                    <div className="role-desc">{r.desc}</div>
                  </div>
                ))}
              </div>
              <p className="text-sm text-muted" style={{ marginTop: '8px', display: 'flex', alignItems: 'center', gap: '6px' }}>
                <ShieldCheck size={14} /> Admin and Leader roles are assigned by existing administrators.
              </p>
            </div>
          )}

          <button type="submit" className="btn btn-primary w-full" disabled={busy} style={{ justifyContent: 'center', padding: '12px' }}>
            {busy ? 'Please wait...' : mode === 'signup' ? 'Create Account' : 'Sign In'}
            {!busy && <ArrowRight size={16} />}
          </button>
        </form>

        <div className="auth-hint">
          {mode === 'login'
            ? "Don't have an account? Click Create Account above to register."
            : 'Already registered? Click Sign In above to log in.'}
        </div>

        <div style={{ textAlign: 'center', marginTop: '16px' }}>
          <Link to="/" className="text-sm text-muted">Back to home</Link>
        </div>
      </div>
    </div>
  )
}
