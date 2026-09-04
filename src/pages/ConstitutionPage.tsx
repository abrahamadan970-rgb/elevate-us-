import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageConstitution } from '../lib/permissions'
import { toast } from '../components/Toast'
import type { Constitution } from '../types'

export default function ConstitutionPage() {
  const { profile } = useAuth()
  const [data, setData] = useState<Constitution | null>(null)
  const [loading, setLoading] = useState(true)
  const [editing, setEditing] = useState(false)
  const [form, setForm] = useState<Partial<Constitution>>({})

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const { data: row } = await supabase.from('constitution').select('*').eq('id', 1).maybeSingle()
    setData(row as Constitution)
    setForm(row ?? {})
    setLoading(false)
  }

  async function save() {
    const { error } = await supabase.from('constitution').update({
      name: form.name, motto: form.motto, mission: form.mission, vision: form.vision,
      objectives: form.objectives, membership_rules: form.membership_rules,
      code_of_conduct: form.code_of_conduct, financial_rules: form.financial_rules,
      amendment_rules: form.amendment_rules,
    }).eq('id', 1)
    if (error) { toast(error.message, 'error'); return }
    toast('Constitution updated'); setEditing(false); load()
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  const canManage = canManageConstitution(profile?.role)

  const fields = [
    { key: 'name', label: 'Association Name' },
    { key: 'motto', label: 'Motto' },
    { key: 'mission', label: 'Mission' },
    { key: 'vision', label: 'Vision' },
    { key: 'objectives', label: 'Objectives' },
    { key: 'membership_rules', label: 'Membership Rules' },
    { key: 'code_of_conduct', label: 'Code of Conduct' },
    { key: 'financial_rules', label: 'Financial Rules' },
    { key: 'amendment_rules', label: 'Amendment Rules' },
  ] as const

  return (
    <div>
      <div className="card">
        <div className="card-header">
          <h3>Constitution</h3>
          {canManage && !editing && <button className="btn btn-primary" onClick={() => setEditing(true)}>Edit</button>}
          {editing && <div className="flex gap-2"><button className="btn btn-secondary" onClick={() => { setEditing(false); setForm(data ?? {}) }}>Cancel</button><button className="btn btn-primary" onClick={save}>Save</button></div>}
        </div>
        <div className="card-body" style={{ display: 'grid', gap: 18 }}>
          {fields.map((f) => (
            <div key={f.key}>
              <div className="text-sm font-semibold text-muted mb-2">{f.label}</div>
              {editing ? (
                <textarea value={String(form[f.key] ?? '')} onChange={(e) => setForm({ ...form, [f.key]: e.target.value })} style={{ width: '100%', padding: 10, borderRadius: 8, border: '1px solid var(--border)', minHeight: 80 }} />
              ) : (
                <p style={{ whiteSpace: 'pre-wrap' }}>{data?.[f.key] ?? '—'}</p>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
