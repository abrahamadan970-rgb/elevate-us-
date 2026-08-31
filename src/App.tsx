import { Routes, Route, Navigate } from 'react-router-dom'
import { useAuth } from './contexts/AuthContext'
import LandingPage from './pages/LandingPage'
import AppLayout from './pages/AppLayout'
import Dashboard from './pages/Dashboard'
import MembersPage from './pages/MembersPage'
import SubscriptionsPage from './pages/SubscriptionsPage'
import MembershipFeesPage from './pages/MembershipFeesPage'
import LoansPage from './pages/LoansPage'
import InterestPage from './pages/InterestPage'
import FinesPage from './pages/FinesPage'
import ExpensesPage from './pages/ExpensesPage'
import EventsPage from './pages/EventsPage'
import LeadersPage from './pages/LeadersPage'
import MinutesPage from './pages/MinutesPage'
import EmailPage from './pages/EmailPage'
import ReportsPage from './pages/ReportsPage'
import ConstitutionPage from './pages/ConstitutionPage'
import SettingsPage from './pages/SettingsPage'
import ChangePasswordPage from './pages/ChangePasswordPage'

export default function App() {
  const { loading } = useAuth()

  if (loading) {
    return (
      <div className="loading-center" style={{ minHeight: '100vh' }}>
        <div className="spinner" />
      </div>
    )
  }

  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/portal" element={<AppLayout />}>
        <Route index element={<Dashboard />} />
        <Route path="members" element={<MembersPage />} />
        <Route path="subscriptions" element={<SubscriptionsPage />} />
        <Route path="membership-fees" element={<MembershipFeesPage />} />
        <Route path="loans" element={<LoansPage />} />
        <Route path="interest" element={<InterestPage />} />
        <Route path="fines" element={<FinesPage />} />
        <Route path="expenses" element={<ExpensesPage />} />
        <Route path="events" element={<EventsPage />} />
        <Route path="leaders" element={<LeadersPage />} />
        <Route path="minutes" element={<MinutesPage />} />
        <Route path="email" element={<EmailPage />} />
        <Route path="reports" element={<ReportsPage />} />
        <Route path="constitution" element={<ConstitutionPage />} />
        <Route path="settings" element={<SettingsPage />} />
        <Route path="change-password" element={<ChangePasswordPage />} />
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
