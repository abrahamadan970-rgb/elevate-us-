import { createContext, useContext, useEffect, useState } from 'react'
import type { ReactNode } from 'react'
import { supabase } from '../lib/supabase'
import type { Profile } from '../types'

const AUTO_EMAIL = 'natembeatallia@gmail.com'
const AUTO_PASSWORD = 'Admin123!'

interface AuthContextValue {
  profile: Profile | null
  loading: boolean
  refreshProfile: () => Promise<void>
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [profile, setProfile] = useState<Profile | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let mounted = true
    const timeout = setTimeout(() => {
      if (mounted) setLoading(false)
    }, 6000)

    async function init() {
      const { data: sessionData } = await supabase.auth.getSession()
      if (sessionData.session?.user) {
        await loadProfile(sessionData.session.user.id)
        return
      }
      const { data, error } = await supabase.auth.signInWithPassword({
        email: AUTO_EMAIL,
        password: AUTO_PASSWORD,
      })
      if (!mounted) return
      if (error) {
        console.error('Auto sign-in error:', error.message)
        setLoading(false)
        return
      }
      if (data.user) await loadProfile(data.user.id)
    }

    init()

    const { data: sub } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) {
        loadProfile(session.user.id)
      } else {
        setProfile(null)
        setLoading(false)
      }
    })

    return () => {
      mounted = false
      clearTimeout(timeout)
      sub.subscription.unsubscribe()
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  async function loadProfile(userId: string) {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .maybeSingle()

    if (error) console.error('Profile load error:', error)
    setProfile(data as Profile | null)
    setLoading(false)
  }

  async function refreshProfile() {
    const { data: session } = await supabase.auth.getSession()
    if (session.session?.user) await loadProfile(session.session.user.id)
  }

  return (
    <AuthContext.Provider value={{ profile, loading, refreshProfile }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
