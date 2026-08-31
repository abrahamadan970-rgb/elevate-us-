import React, { useState } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

export default function AuthPage() {
  const { signIn } = useAuth();
  const [isSignUp, setIsSignUp] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setMessage(null);
    setBusy(true);

    try {
      if (isSignUp) {
        // Self-registration for members
        const { data, error: signUpError } = await supabase.auth.signUp({
          email: email.trim(),
          password,
          options: {
            data: {
              full_name: fullName.trim(),
              role: 'member',
            },
          },
        });

        if (signUpError) throw signUpError;

        // If email confirmation is disabled in Supabase, session is created immediately
        if (data.session) {
          setMessage('Account created successfully!');
        } else {
          setMessage('Registration successful! Check your email to confirm your account.');
        }
      } else {
        const { error: signInError } = await signIn(email.trim(), password);
        if (signInError) throw signInError;
      }
    } catch (err: any) {
      setError(err.message || 'An error occurred during authentication.');
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="auth-container" style={{ maxWidth: '400px', margin: '40px auto', padding: '20px' }}>
      <h2>{isSignUp ? 'Create Member Account' : 'Sign In'}</h2>

      {error && <div style={{ color: 'red', marginBottom: '10px' }}>{error}</div>}
      {message && <div style={{ color: 'green', marginBottom: '10px' }}>{message}</div>}

      <form onSubmit={handleSubmit}>
        {isSignUp && (
          <div style={{ marginBottom: '15px' }}>
            <label>Full Name</label>
            <input
              type="text"
              value={fullName}
              onChange={(e) => setFullName(e.target.value)}
              required
              style={{ width: '100%', padding: '8px' }}
            />
          </div>
        )}

        <div style={{ marginBottom: '15px' }}>
          <label>Email Address</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            style={{ width: '100%', padding: '8px' }}
          />
        </div>

        <div style={{ marginBottom: '15px' }}>
          <label>Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            style={{ width: '100%', padding: '8px' }}
          />
        </div>

        <button type="submit" disabled={busy} style={{ width: '100%', padding: '10px' }}>
          {busy ? 'Processing...' : isSignUp ? 'Register Account' : 'Sign In'}
        </button>
      </form>

      <div style={{ marginTop: '20px', textAlign: 'center' }}>
        <button
          type="button"
          onClick={() => {
            setIsSignUp(!isSignUp);
            setError(null);
            setMessage(null);
          }}
          style={{ background: 'none', border: 'none', color: '#2563eb', cursor: 'pointer' }}
        >
          {isSignUp ? 'Already have an account? Sign In' : "Don't have an account? Register"}
        </button>
      </div>
    </div>
  );
}