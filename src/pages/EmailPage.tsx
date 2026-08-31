import { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import { canSendEmails } from '../lib/permissions'
import { toast } from '../components/Toast'
import Modal from '../components/Modal'
import { Mail, Send, Users, FileText, AlertTriangle, Wallet, Landmark, CalendarDays, Sparkles } from 'lucide-react'

interface EmailTemplate {
  key: string
  label: string
  subject: string
  body: (name: string, extra?: string) => string
  icon: any
  needsAmount?: boolean
  needsDate?: boolean
}

const templates: EmailTemplate[] = [
  {
    key: 'welcome',
    label: 'Welcome Message',
    subject: 'Welcome to ElevateUS!',
    icon: Sparkles,
    body: (n) => `Hello ${n},\n\nWelcome to ElevateUS Association! We're thrilled to have you join our community of rising achievers. Our motto is "Rise together, achieve more".\n\nAs a member, you'll participate in monthly subscriptions, access loans, and attend our meetings and events.\n\nIf you have any questions, please reach out to the leadership team.\n\nWarm regards,\nElevateUS Leadership`,
  },
  {
    key: 'subscription_reminder',
    label: 'Subscription Reminder',
    subject: 'Subscription Payment Reminder',
    icon: Wallet,
    body: (n) => `Hello ${n},\n\nThis is a friendly reminder that your monthly subscription payment is due. Please make your contribution via M-Pesa or cash to the treasurer before the end of the month.\n\nThank you for keeping our association strong.\n\nElevateUS Treasury`,
  },
  {
    key: 'loan_reminder',
    label: 'Loan Repayment Reminder',
    subject: 'Loan Repayment Due',
    icon: Landmark,
    body: (n, due) => `Hello ${n},\n\nThis is a reminder that your loan repayment is due${due ? ` on ${due}` : ''}. Please ensure the payment is made on time to avoid penalties.\n\nIf you've already paid, please disregard this message.\n\nElevateUS Treasury`,
    needsDate: true,
  },
  {
    key: 'meeting_notice',
    label: 'Meeting Notice',
    subject: 'Upcoming Meeting Notice',
    icon: Users,
    body: (n, date) => `Hello ${n},\n\nYou're invited to attend the upcoming ElevateUS meeting${date ? ` scheduled for ${date}` : ''}. Please confirm your attendance.\n\nAgenda and venue will be communicated closer to the date.\n\nElevateUS Leadership`,
    needsDate: true,
  },
  {
    key: 'defaulter_notice',
    label: 'Defaulter Notice',
    subject: 'Urgent: Outstanding Balance Notice',
    icon: AlertTriangle,
    body: (n) => `Hello ${n},\n\nOur records indicate that you have an outstanding balance with ElevateUS. Please make arrangements to clear your dues as soon as possible.\n\nFailure to do so may result in additional penalties per our financial rules.\n\nElevateUS Treasury`,
  },
  {
    key: 'event_invitation',
    label: 'Event Invitation',
    subject: 'You\'re Invited!',
    icon: CalendarDays,
    body: (n, date) => `Hello ${n},\n\nElevateUS is hosting an upcoming event${date ? ` on ${date}` : ''} and we'd love to see you there!\n\nMore details will follow. Mark your calendar.\n\nElevateUS Events Team`,
    needsDate: true,
  },
]

export default function EmailPage() {
  const { profile } = useAuth()
  const [showCompose, setShowCompose] = useState(false)
  const [selectedTemplate, setSelectedTemplate] = useState<EmailTemplate | null>(null)
  const [to, setTo] = useState('')
  const [recipientName, setRecipientName] = useState('')
  const [extraDate, setExtraDate] = useState('')
  const [subject, setSubject] = useState('')
  const [body, setBody] = useState('')
  const [sending, setSending] = useState(false)
  const [history, setHistory] = useState<any[]>([])

  function openTemplate(t: EmailTemplate) {
    setSelectedTemplate(t)
    setSubject(t.subject)
    setBody(t.body('', ''))
    setExtraDate('')
    setRecipientName('')
    setShowCompose(true)
  }

  function updateBody(name: string, date: string) {
    if (selectedTemplate) setBody(selectedTemplate.body(name, date))
  }

  async function send() {
    if (!to || !subject || !body) { toast('Recipient, subject and body required', 'error'); return }
    setSending(true)
    try {
      const url = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/send-email`
      const res = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
        },
        body: JSON.stringify({ to, subject, text: body }),
      })
      const data = await res.json()
      if (!res.ok) { toast(data.error || 'Failed to send email', 'error'); return }
      const entry = { to, subject, sent_at: new Date().toISOString(), template: selectedTemplate?.key }
      setHistory([entry, ...history])
      toast('Email sent successfully')
      setShowCompose(false)
    } finally {
      setSending(false)
    }
  }

  if (!canSendEmails(profile?.role)) {
    return <div className="card"><div className="card-body"><div className="empty"><Mail /> You don't have permission to send emails.</div></div></div>
  }

  return (
    <div>
      <div className="card mb-4">
        <div className="card-header"><h3>Email Templates</h3></div>
        <div className="card-body">
          <div className="grid-3">
            {templates.map((t) => (
              <button key={t.key} className="muted-box" style={{ background: 'var(--surface)', border: '1px solid var(--border)', cursor: 'pointer', textAlign: 'left' }} onClick={() => openTemplate(t)}>
                <div className="flex items-center gap-2 mb-2"><t.icon size={18} style={{ color: 'var(--primary)' }} /><strong>{t.label}</strong></div>
                <div className="text-sm text-muted">{t.subject}</div>
              </button>
            ))}
          </div>
        </div>
      </div>

      <div className="card">
        <div className="card-header"><h3>Compose Custom Email</h3></div>
        <div className="card-body">
          <button className="btn btn-primary" onClick={() => { setSelectedTemplate(null); setSubject(''); setBody(''); setTo(''); setExtraDate(''); setRecipientName(''); setShowCompose(true) }}>
            <Mail size={16} /> New Email
          </button>
        </div>
      </div>

      {history.length > 0 && (
        <div className="card mt-4">
          <div className="card-header"><h3>Recently Sent</h3></div>
          <div className="table-wrap">
            <table className="data-table">
              <thead><tr><th>To</th><th>Subject</th><th>Template</th><th>Sent</th></tr></thead>
              <tbody>
                {history.map((h, i) => (
                  <tr key={i}><td>{h.to}</td><td>{h.subject}</td><td>{h.template ?? 'custom'}</td><td>{new Date(h.sent_at).toLocaleString()}</td></tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      <Modal open={showCompose} onClose={() => setShowCompose(false)} title={selectedTemplate ? selectedTemplate.label : 'New Email'} size="lg" footer={<>
        <button className="btn btn-secondary" onClick={() => setShowCompose(false)}>Cancel</button>
        <button className="btn btn-primary" onClick={send} disabled={sending}>{sending ? <span className="spinner" /> : <><Send size={15} /> Send</>}</button>
      </>}>
        <div className="form-group"><label>To (email)</label><input type="email" value={to} onChange={(e) => setTo(e.target.value)} placeholder="member@example.com" /></div>
        <div className="form-row">
          <div className="form-group"><label>Recipient Name</label>
            <input value={recipientName} onChange={(e) => { setRecipientName(e.target.value); updateBody(e.target.value, extraDate) }} placeholder="Jane" /></div>
          {selectedTemplate?.needsDate && (
            <div className="form-group"><label>{selectedTemplate.key === 'loan_reminder' ? 'Due Date' : 'Event Date'}</label>
              <input type="date" value={extraDate} onChange={(e) => { setExtraDate(e.target.value); updateBody(recipientName, e.target.value) }} /></div>
          )}
        </div>
        <div className="form-group"><label>Subject</label><input value={subject} onChange={(e) => setSubject(e.target.value)} /></div>
        <div className="form-group"><label>Message</label><textarea value={body} onChange={(e) => setBody(e.target.value)} style={{ minHeight: 220, fontFamily: 'monospace' }} /></div>
      </Modal>
    </div>
  )
}
