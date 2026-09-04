import { createClient } from '@supabase/supabase-js'

const url = import.meta.env.VITE_SUPABASE_URL as string
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string

if (!url || !anonKey) {
  console.error('Missing Supabase env vars. Check .env file.')
}

export const supabase = createClient(url || 'http://localhost:5173', anonKey || 'placeholder', {
  auth: { persistSession: true, autoRefreshToken: true },
})
