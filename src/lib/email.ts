import { supabase } from './supabase'

const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL as string

export async function sendEmail(to: string, subject: string, html: string): Promise<boolean> {
  try {
    const res = await fetch(`${SUPABASE_URL}/functions/v1/send-email`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ to, subject, html }),
    })
    return res.ok
  } catch {
    return false
  }
}

export function welcomeEmailHtml(fullName: string, role: string): string {
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <style>
    body { font-family: Inter, -apple-system, sans-serif; background: #f8f7ff; margin: 0; padding: 40px 20px; }
    .wrap { max-width: 520px; margin: 0 auto; background: #fff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 24px rgba(124,58,237,.1); }
    .header { background: #7c3aed; padding: 32px; text-align: center; }
    .header h1 { color: #fff; font-size: 22px; font-weight: 800; margin: 0; }
    .header p  { color: rgba(255,255,255,.75); margin: 6px 0 0; font-size: 14px; }
    .body { padding: 32px; }
    .body h2 { font-size: 18px; color: #1e1b4b; margin-bottom: 12px; }
    .body p  { color: #64748b; font-size: 14px; line-height: 1.7; margin-bottom: 12px; }
    .badge { display: inline-block; padding: 4px 12px; background: #ede9fe; color: #7c3aed; border-radius: 20px; font-size: 13px; font-weight: 600; margin: 8px 0 20px; }
    .btn { display: inline-block; padding: 12px 28px; background: #7c3aed; color: #fff; border-radius: 10px; text-decoration: none; font-weight: 700; font-size: 14px; }
    .footer { padding: 20px 32px; border-top: 1px solid #f1effe; font-size: 12px; color: #94a3b8; text-align: center; }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <h1>ElevateUS Association</h1>
      <p>Membership Management System</p>
    </div>
    <div class="body">
      <h2>Welcome, ${fullName}!</h2>
      <p>Your account has been created successfully. You have been assigned the role of:</p>
      <span class="badge">${role.charAt(0).toUpperCase() + role.slice(1)}</span>
      <p>You now have access to the ElevateUS Association portal where you can view financial records, loans, subscriptions, and more based on your access level.</p>
      <p>If you have any questions, please contact your association admin.</p>
    </div>
    <div class="footer">
      This email was sent by ElevateUS Association. Do not reply to this email.
    </div>
  </div>
</body>
</html>`
}

export function loanDisbursedEmailHtml(
  memberName: string,
  principal: number,
  totalPayable: number,
  dueDate: string
): string {
  const fmt = (n: number) => `KES ${n.toLocaleString('en-KE', { minimumFractionDigits: 2 })}`
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <style>
    body { font-family: Inter, -apple-system, sans-serif; background: #f8f7ff; margin: 0; padding: 40px 20px; }
    .wrap { max-width: 520px; margin: 0 auto; background: #fff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 24px rgba(124,58,237,.1); }
    .header { background: #7c3aed; padding: 32px; text-align: center; }
    .header h1 { color: #fff; font-size: 22px; font-weight: 800; margin: 0; }
    .body { padding: 32px; }
    .body h2 { font-size: 18px; color: #1e1b4b; margin-bottom: 16px; }
    .info-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #f1effe; font-size: 14px; }
    .info-row:last-child { border-bottom: none; }
    .info-label { color: #64748b; }
    .info-value { font-weight: 700; color: #1e1b4b; }
    .total-row .info-value { color: #7c3aed; font-size: 16px; }
    .footer { padding: 20px 32px; border-top: 1px solid #f1effe; font-size: 12px; color: #94a3b8; text-align: center; }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header"><h1>Loan Disbursement Notice</h1></div>
    <div class="body">
      <h2>Dear ${memberName},</h2>
      <p style="color:#64748b;font-size:14px;margin-bottom:20px;">A loan has been disbursed to you by ElevateUS Association. Please find the details below:</p>
      <div class="info-row"><span class="info-label">Principal Amount</span><span class="info-value">${fmt(principal)}</span></div>
      <div class="info-row total-row"><span class="info-label">Total Payable</span><span class="info-value">${fmt(totalPayable)}</span></div>
      <div class="info-row"><span class="info-label">Due Date</span><span class="info-value">${dueDate}</span></div>
    </div>
    <div class="footer">ElevateUS Association · Please repay on time to avoid penalties.</div>
  </div>
</body>
</html>`
}

export async function getProfileEmail(userId: string): Promise<string | null> {
  const { data } = await supabase.from('profiles').select('email').eq('id', userId).maybeSingle()
  return data?.email ?? null
}

export async function getMemberEmail(memberId: string): Promise<string | null> {
  const { data } = await supabase.from('members').select('email').eq('id', memberId).maybeSingle()
  return data?.email ?? null
}
