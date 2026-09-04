import { useState } from 'react'
import { NavLink, Outlet, Link, useNavigate } from 'react-router-dom'
import { LayoutDashboard, Users, Wallet, BadgeDollarSign, Landmark, TrendingUp, TriangleAlert as AlertTriangle, Receipt, CalendarDays, Crown, FileText, Mail, ChartBar as BarChart3, ScrollText, Settings, Menu, X, KeyRound, Chrome as Home, LogOut } from 'lucide-react'
import { useAuth } from '../contexts/AuthContext'
import { roleLabel } from '../lib/permissions'
import type { UserRole } from '../types'

const allSections: {
  title: string
  items: { to: string; label: string; icon: typeof LayoutDashboard; roles?: UserRole[] }[]
}[] = [
  {
    title: 'Overview',
    items: [
      { to: '/portal', label: 'Dashboard', icon: LayoutDashboard },
    ],
  },
  {
    title: 'Membership',
    items: [
      { to: '/portal/members', label: 'Members', icon: Users },
      { to: '/portal/leaders', label: 'Leaders', icon: Crown },
      { to: '/portal/membership-fees', label: 'Membership Fees', icon: BadgeDollarSign },
    ],
  },
  {
    title: 'Finance',
    items: [
      { to: '/portal/subscriptions', label: 'Subscriptions', icon: Wallet, roles: ['admin', 'treasurer', 'chairperson', 'secretary', 'leader'] },
      { to: '/portal/loans', label: 'Loans', icon: Landmark, roles: ['admin', 'treasurer', 'chairperson', 'secretary', 'leader'] },
      { to: '/portal/interest', label: 'Interest', icon: TrendingUp, roles: ['admin', 'treasurer'] },
      { to: '/portal/fines', label: 'Fines', icon: AlertTriangle, roles: ['admin', 'treasurer', 'chairperson', 'secretary', 'leader'] },
      { to: '/portal/expenses', label: 'Expenses', icon: Receipt, roles: ['admin', 'treasurer'] },
    ],
  },
  {
    title: 'Engagement',
    items: [
      { to: '/portal/events', label: 'Events', icon: CalendarDays },
      { to: '/portal/minutes', label: 'Minutes', icon: FileText },
      { to: '/portal/email', label: 'Email Center', icon: Mail, roles: ['admin', 'treasurer', 'secretary', 'chairperson', 'leader'] },
    ],
  },
  {
    title: 'Insights',
    items: [
      { to: '/portal/reports', label: 'Reports', icon: BarChart3 },
      { to: '/portal/constitution', label: 'Constitution', icon: ScrollText },
      { to: '/portal/settings', label: 'Settings', icon: Settings, roles: ['admin'] },
    ],
  },
]

export default function AppLayout() {
  const { profile, signOut } = useAuth()
  const navigate = useNavigate()
  const [open, setOpen] = useState(false)

  const initials = profile?.full_name?.split(' ').map((s) => s[0]).slice(0, 2).join('') ?? '?'
  const role = profile?.role

  const sections = allSections
    .map((section) => ({
      ...section,
      items: section.items.filter((item) => !item.roles || (role && item.roles.includes(role))),
    }))
    .filter((section) => section.items.length > 0)

  async function handleSignOut() {
    await signOut()
    navigate('/')
  }

  return (
    <div className="app-shell">
      <aside className={`sidebar ${open ? 'open' : ''}`}>
        <div className="sidebar-brand">
          <div className="logo">E</div>
          <div>
            <h1>ElevateUS</h1>
            <p>Members Portal</p>
          </div>
        </div>
        <nav className="nav-scroll">
          {sections.map((section) => (
            <div className="nav-section" key={section.title}>
              <div className="nav-section-title">{section.title}</div>
              {section.items.map((item) => (
                <NavLink
                  key={item.to}
                  to={item.to}
                  end={item.to === '/portal'}
                  className={({ isActive }) => `nav-item ${isActive ? 'active' : ''}`}
                  onClick={() => setOpen(false)}
                >
                  <item.icon />
                  <span>{item.label}</span>
                </NavLink>
              ))}
            </div>
          ))}
        </nav>
        <div className="sidebar-footer">
          <div className="user-chip">
            <div className="avatar">{initials}</div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontWeight: 600, color: '#fff', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                {profile?.full_name}
              </div>
              <span className="role-badge">{roleLabel(profile?.role ?? 'member')}</span>
            </div>
          </div>
          <div className="sidebar-footer-links">
            <Link to="/" className="sidebar-footer-link">
              <Home size={15} /> Home
            </Link>
            <Link to="/portal/change-password" className="sidebar-footer-link">
              <KeyRound size={15} /> Password
            </Link>
            <button onClick={handleSignOut} className="sidebar-footer-link" style={{ background: 'none', border: 'none', cursor: 'pointer' }}>
              <LogOut size={15} /> Sign Out
            </button>
          </div>
        </div>
      </aside>

      <div className="main">
        <header className="topbar">
          <button className="btn-ghost" onClick={() => setOpen(!open)} style={{ display: open ? 'none' : 'block' }}>
            <Menu size={22} />
          </button>
          <button className="btn-ghost" onClick={() => setOpen(false)} style={{ display: open ? 'block' : 'none' }}>
            <X size={22} />
          </button>
          <div style={{ flex: 1 }}>
            <h2>ElevateUS Association</h2>
            <span className="sub">Rise together, achieve more</span>
          </div>
          <Link to="/" className="btn btn-secondary btn-sm">
            <Home size={15} /> Home
          </Link>
          <button onClick={handleSignOut} className="btn btn-secondary btn-sm">
            <LogOut size={15} /> Sign Out
          </button>
        </header>
        <main className="content">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
