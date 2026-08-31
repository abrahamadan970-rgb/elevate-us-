import { useEffect, useState } from 'react'

let externalSetter: ((msg: string, kind?: 'success' | 'error') => void) | null = null

export function toast(message: string, kind: 'success' | 'error' = 'success') {
  if (externalSetter) externalSetter(message, kind)
}

export function ToastHost() {
  const [msg, setMsg] = useState<string | null>(null)
  const [kind, setKind] = useState<'success' | 'error'>('success')

  useEffect(() => {
    externalSetter = (m, k = 'success') => {
      setMsg(m)
      setKind(k)
      setTimeout(() => setMsg(null), 3200)
    }
    return () => { externalSetter = null }
  }, [])

  if (!msg) return null
  return <div className={`toast ${kind}`}>{msg}</div>
}
