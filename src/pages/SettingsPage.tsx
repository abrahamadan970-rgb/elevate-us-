import { useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { canManageSettings } from '../lib/permissions'
import { toast } from '../components/Toast'
import type { Settings } from '../types'

export default function SettingsPage() {
  const { profile } = useAuth()
  const [data, setData] = useState<Settings | null>(null)
  const [loading, setLoading] = useState(true)
  const [form, setForm] = useState<Partial<Settings>>({})

  useEffect(() => { load() }, [])

  async function load() {
    setLoading(true)
    const { data: row } = await supabase.from('settings').select('*').eq('id', 1).maybeSingle()
    setData(row as Settings)
    setForm(row ?? {})
    setLoading(false)
  }

  async function save() {
    const { error } = await supabase.from('settings').update({
      reserve_percentage: Number(form.reserve_percentage),
      min_loan_balance: Number(form.min_loan_balance),
      default_interest_rate: Number(form.default_interest_rate),
      default_penalty_rate: Number(form.default_penalty_rate),
      min_membership_months: Number(form.min_membership_months),
      association_name: form.association_name,
      association_motto: form.association_motto,
      association_email: form.association_email,
      association_phone: form.association_phone,
    }).eq('id', 1)
    if (error) { toast(error.message, 'error'); return }
    toast('Settings saved'); load()
  }

  if (loading) return <div className="loading-center"><div className="spinner" /></div>
  if (!canManageSettings(profile?.role)) {
    return <div className="card"><div className="card-body"><div className="empty">Only administrators can change settings.</div></div></div>
  }

  return (
    <div>
      <div className="card">
        <div className="card-header"><h3>Association Settings</h3><button className="btn btn-primary" onClick={save}>Save Changes</button></div>
        <div className="card-body">
          <div className="form-row">
            <div className="form-group"><label>Association Name</label><input value={form.association_name ?? ''} onChange={(e) => setForm({ ...form, association_name: e.target.value })} /></div>
            <div className="form-group"><label>Motto</label><input value={form.association_motto ?? ''} onChange={(e) => setForm({ ...form, association_motto: e.target.value })} /></div>
          </div>
          <div className="form-row">
            <div className="form-group"><label>Association Email</label><input value={form.association_email ?? ''} onChange={(e) => setForm({ ...form, association_email: e.target.value })} /></div>
            <div className="form-group"><label>Association Phone</label><input value={form.association_phone ?? ''} onChange={(e) => setForm({ ...form, association_phone: e.target.value })} /></div>
          </div>
        </div>
      </div>
      <div className="card mt-4">
        <div className="card-header"><h3>Financial Rules</h3></div>
        <div className="card-body">
          <div className="form-row">
            <div className="form-group"><label>Reserve Percentage (%)</label><input type="number" step="0.1" value={form.reserve_percentage ?? 0} onChange={(e) => setForm({ ...form, reserve_percentage: Number(e.target.value) })} /></div>
            <div className="form-group"><label>Minimum Loan Balance (KES)</label><input type="number" value={form.min_loan_balance ?? 0} onChange={(e) => setForm({ ...form, min_loan_balance: Number(e.target.value) })} /></div>
          </div>
          <div className="form-row">
            <div className="form-group"><label>Default Interest Rate (%)</label><input type="number" step="0.1" value={form.default_interest_rate ?? 0} onChange={(e) => setForm({ ...form, default_interest_rate: Number(e.target.value) })} /></div>
            <div className="form-group"><label>Default Penalty Rate (%)</label><input type="number" step="0.1" value={form.default_penalty_rate ?? 0} onChange={(e) => setForm({ ...form, default_penalty_rate: Number(e.target.value) })} /></div>
          </div>
          <div className="form-group"><label>Minimum Membership Months (before loan eligibility)</label><input type="number" value={form.min_membership_months ?? 0} onChange={(e) => setForm({ ...form, min_membership_months: Number(e.target.value) })} /></div>
        </div>
      </div>
    </div>
  )
}
