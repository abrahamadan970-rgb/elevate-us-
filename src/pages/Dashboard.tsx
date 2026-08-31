import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { Wallet, Landmark, AlertTriangle, TrendingUp, Users, Receipt, CalendarDays, FileText, ShieldCheck, Banknote } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { formatCurrency, formatDate } from '../lib/format'

interface Stats {
  totalSubscriptions: number
  totalInterest: number
  totalFines: number
  totalRegistration: number
  totalExpenses: number
  activeLoansBalance: number
  totalDisbursed: number
  activeLoansCount: number
  totalMembers: number
  defaulters: number
  upcomingEvents: number
  grandTotal: number
  unloanable: number
  loanable: number
}

export default function Dashboard() {
  const [stats, setStats] = useState<Stats | null>(null)
  const [recent, setRecent] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    (async () => {
      const [subs, interest, fines, fees, expenses, loans, members, events, leftMembers] = await Promise.all([
        supabase.from('subscriptions').select('amount,member_id'),
        supabase.from('monthly_interest').select('amount'),
        supabase.from('fines').select('amount,paid'),
        supabase.from('membership_fees').select('amount'),
        supabase.from('expenses').select('amount'),
        supabase.from('loans').select('id,status,balance,principal_amount'),
        supabase.from('members').select('id,is_defaulter,status').eq('status', 'active'),
        supabase.from('events').select('id,event_date').gte('event_date', new Date().toISOString().split('T')[0]),
        supabase.from('members').select('id').eq('status', 'left'),
      ])

      const leftIds = new Set((leftMembers.data ?? []).map((m) => m.id))
      const activeSubs = (subs.data ?? []).filter((r) => !leftIds.has(r.member_id))
      const totalSubscriptions = activeSubs.reduce((s, r) => s + Number(r.amount), 0)
      const totalInterest = interest.data?.reduce((s, r) => s + Number(r.amount), 0) ?? 0
      const totalFines = fines.data?.reduce((s, r) => s + (r.paid ? Number(r.amount) : 0), 0) ?? 0
      const totalRegistration = fees.data?.reduce((s, r) => s + Number(r.amount), 0) ?? 0
      const totalExpenses = expenses.data?.reduce((s, r) => s + Number(r.amount), 0) ?? 0
      const activeLoans = loans.data?.filter((l) => l.status !== 'cleared') ?? []
      const activeLoansBalance = activeLoans.reduce((s, l) => s + Number(l.balance), 0)
      const totalDisbursed = loans.data?.reduce((s, l) => s + Number(l.principal_amount), 0) ?? 0

      const grandTotal = totalSubscriptions + totalInterest + totalFines + totalRegistration - totalExpenses
      const unloanable = grandTotal * 0.2
      const loanable = Math.max(0, grandTotal * 0.8 - totalDisbursed)

      setStats({
        totalSubscriptions, totalInterest, totalFines, totalRegistration, totalExpenses,
        activeLoansBalance, totalDisbursed, activeLoansCount: activeLoans.length,
        totalMembers: members.data?.length ?? 0,
        defaulters: members.data?.filter((m) => m.is_defaulter).length ?? 0,
        upcomingEvents: events.data?.length ?? 0,
        grandTotal, unloanable, loanable,
      })

      const { data: recentLoans } = await supabase
        .from('loans')
        .select('id, principal_amount, balance, status, issue_date, member:members(full_name)')
        .order('created_at', { ascending: false })
        .limit(5)
      setRecent(recentLoans ?? [])

      setLoading(false)
    })()
  }, [])

  if (loading) return <div className="loading-center"><div className="spinner" /></div>

  const cards = [
    { label: 'Subscriptions', value: formatCurrency(stats?.totalSubscriptions), icon: Wallet, color: '#0ea5e9', bg: '#e0f2fe' },
    { label: 'Interest', value: formatCurrency(stats?.totalInterest), icon: TrendingUp, color: '#14b8a6', bg: '#ccfbf1' },
    { label: 'Registration Fees', value: formatCurrency(stats?.totalRegistration), icon: Receipt, color: '#8b5cf6', bg: '#ede9fe' },
    { label: 'Expenses', value: formatCurrency(stats?.totalExpenses), icon: Receipt, color: '#dc2626', bg: '#fee2e2' },
    { label: 'Paid Fines', value: formatCurrency(stats?.totalFines), icon: AlertTriangle, color: '#d97706', bg: '#fef3c7' },
    { label: 'Total Disbursed', value: formatCurrency(stats?.totalDisbursed), icon: Landmark, color: '#0369a1', bg: '#e0f2fe' },
    { label: 'Members', value: stats?.totalMembers ?? 0, icon: Users, color: '#0f172a', bg: '#f1f5f9' },
    { label: 'Defaulters', value: stats?.defaulters ?? 0, icon: AlertTriangle, color: '#b91c1c', bg: '#fee2e2' },
  ]

  return (
    <div>
      <div className="stat-grid" style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(220px, 1fr))' }}>
        {cards.map((c) => (
          <div className="stat-card" key={c.label}>
            <div className="stat-icon" style={{ background: c.bg, color: c.color }}>
              <c.icon size={20} />
            </div>
            <div className="stat-label">{c.label}</div>
            <div className="stat-value">{c.value}</div>
          </div>
        ))}
      </div>

      <div className="grid-2" style={{ marginTop: 16 }}>
        <div className="card" style={{ border: '1px solid var(--border)' }}>
          <div className="card-header"><h3>Fund Summary (All Time)</h3></div>
          <div style={{ padding: '4px 20px 20px' }}>
            <SummaryRow label="Subscriptions" value={stats?.totalSubscriptions} />
            <SummaryRow label="Interest Earned" value={stats?.totalInterest} />
            <SummaryRow label="Registration Fees" value={stats?.totalRegistration} />
            <SummaryRow label="Paid Fines" value={stats?.totalFines} />
            <SummaryRow label="Expenses" value={stats?.totalExpenses} negative />
            <div style={{ borderTop: '2px solid var(--border)', margin: '10px 0', paddingTop: 10 }}>
              <SummaryRow label="Grand Total" value={stats?.grandTotal} bold />
            </div>
            <div style={{ background: '#fef3c7', borderRadius: 12, padding: 16, marginTop: 12, border: '1px solid #fde68a' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <ShieldCheck size={18} color="#b45309" />
                  <span style={{ fontWeight: 600, color: '#92400e', fontSize: 14 }}>Unloanable Reserve (20%)</span>
                </div>
                <span style={{ fontWeight: 700, color: '#92400e', fontSize: 16 }}>{formatCurrency(stats?.unloanable)}</span>
              </div>
              <div style={{ fontSize: 12, color: '#a16207', marginTop: 4 }}>Protected reserve — not available for lending</div>
            </div>
            <div style={{ background: '#dcfce7', borderRadius: 12, padding: 16, marginTop: 12, border: '1px solid #bbf7d0' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <Banknote size={18} color="#15803d" />
                  <span style={{ fontWeight: 600, color: '#166534', fontSize: 14 }}>Loanable Funds (80%)</span>
                </div>
                <span style={{ fontWeight: 700, color: '#166534', fontSize: 16 }}>{formatCurrency(stats?.loanable)}</span>
              </div>
              <div style={{ fontSize: 12, color: '#15803d', marginTop: 4 }}>
                80% of total ({formatCurrency((stats?.grandTotal ?? 0) * 0.8)}) minus total disbursed loans ({formatCurrency(stats?.totalDisbursed)})
              </div>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-header">
            <h3>Recent Loans</h3>
            <Link to="/portal/loans" className="btn btn-secondary btn-sm">View all</Link>
          </div>
          <div className="table-wrap">
            <table className="data-table">
              <thead>
                <tr><th>Member</th><th>Principal</th><th>Balance</th><th>Status</th><th>Issued</th></tr>
              </thead>
              <tbody>
                {recent.length === 0 && (
                  <tr><td colSpan={5} style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No loans yet</td></tr>
                )}
                {recent.map((l) => (
                  <tr key={l.id}>
                    <td>{l.member?.full_name ?? '—'}</td>
                    <td>{formatCurrency(l.principal_amount)}</td>
                    <td>{formatCurrency(l.balance)}</td>
                    <td><span className={`badge ${l.status === 'cleared' ? 'badge-success' : l.status === 'defaulted' ? 'badge-error' : 'badge-info'}`}>{l.status}</span></td>
                    <td>{formatDate(l.issue_date)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div style={{ padding: '12px 20px' }}>
            <div style={{ display: 'grid', gap: 8 }}>
              <Link to="/portal/members" className="btn btn-secondary"><Users size={16} /> Manage Members</Link>
              <Link to="/portal/subscriptions" className="btn btn-secondary"><Wallet size={16} /> Record Subscription</Link>
              <Link to="/portal/loans" className="btn btn-secondary"><Landmark size={16} /> Manage Loans</Link>
              <Link to="/portal/reports" className="btn btn-secondary"><TrendingUp size={16} /> View Reports</Link>
            </div>
          </div>
        </div>
      </div>

      {stats && stats.upcomingEvents > 0 && (
        <div className="card" style={{ marginTop: 16 }}>
          <div className="card-header"><h3><CalendarDays size={18} style={{ display: 'inline', marginRight: 6 }} />Upcoming Events ({stats.upcomingEvents})</h3>
            <Link to="/portal/events" className="btn btn-secondary btn-sm">View all</Link>
          </div>
        </div>
      )}
    </div>
  )
}

function SummaryRow({ label, value, bold, negative }: { label: string; value: number | undefined; bold?: boolean; negative?: boolean }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 14, marginBottom: 6, fontWeight: bold ? 700 : 400 }}>
      <span style={{ color: 'var(--text-3)' }}>{label}</span>
      <span style={{ fontWeight: bold ? 700 : 500, color: negative ? 'var(--error)' : bold ? 'var(--brand)' : 'var(--text-2)' }}>
        {negative ? '−' : ''}{formatCurrency(value)}
      </span>
    </div>
  )
}
