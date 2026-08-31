import { useEffect, useRef, useState } from 'react'
import { Bar, Doughnut, Line } from 'react-chartjs-2'
import {
  Chart as ChartJS, CategoryScale, LinearScale, BarElement,
  Title, Tooltip, Legend, ArcElement, PointElement, LineElement,
} from 'chart.js'
import { supabase } from '../lib/supabase'
import { formatCurrency, monthName, currentYear } from '../lib/format'
import { Download, TrendingUp, TrendingDown, Wallet, AlertTriangle, Receipt, ShieldCheck, Banknote, Landmark } from 'lucide-react'

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend, ArcElement, PointElement, LineElement)

export default function ReportsPage() {
  const [year, setYear] = useState<number | 'all'>(currentYear())
  const [data, setData] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const barRef = useRef<any>(null)
  const doughnutRef = useRef<any>(null)
  const lineRef = useRef<any>(null)

  useEffect(() => { load() }, [year])

  async function load() {
    setLoading(true)
    const [subs, interest, fines, fees, expenses, loans, leftMembers] = await Promise.all([
      supabase.from('subscriptions').select('amount, payment_month, payment_year, member_id'),
      supabase.from('monthly_interest').select('amount, month, year'),
      supabase.from('fines').select('amount, paid, issue_date'),
      supabase.from('membership_fees').select('amount'),
      supabase.from('expenses').select('amount, expense_date'),
      supabase.from('loans').select('principal_amount, balance, status'),
      supabase.from('members').select('id').eq('status', 'left'),
    ])

    const leftIds = new Set((leftMembers.data ?? []).map((m: any) => m.id))
    const yearSubs = (subs.data ?? []).filter((r) => year === 'all' || r.payment_year === year)
    const activeSubs = yearSubs.filter((r) => !leftIds.has(r.member_id))
    const withdrawnSubs = yearSubs.filter((r) => leftIds.has(r.member_id))
    const withdrawnAmount = withdrawnSubs.reduce((s, r) => s + Number(r.amount), 0)

    const monthlySubs = Array(12).fill(0)
    activeSubs.forEach((r) => { monthlySubs[r.payment_month - 1] += Number(r.amount) })

    const yearInterest = (interest.data ?? []).filter((r) => year === 'all' || r.year === year)
    const monthlyInterest = Array(12).fill(0)
    yearInterest.forEach((r) => { monthlyInterest[r.month - 1] += Number(r.amount) })

    const yearExpenses = (expenses.data ?? []).filter((r) => year === 'all' || new Date(r.expense_date).getFullYear() === year)
    const monthlyExpenses = Array(12).fill(0)
    yearExpenses.forEach((r) => { monthlyExpenses[new Date(r.expense_date).getMonth()] += Number(r.amount) })

    const totalSubs = activeSubs.reduce((s, r) => s + Number(r.amount), 0)
    const totalInterest = yearInterest.reduce((s, r) => s + Number(r.amount), 0)
    const totalFines = (fines.data ?? []).filter((r) => year === 'all' || (new Date(r.issue_date).getFullYear() === year)).reduce((s, r) => s + Number(r.amount), 0)
    const totalRegistration = (fees.data ?? []).reduce((s, r) => s + Number(r.amount), 0)
    const totalExpenses = monthlyExpenses.reduce((s, v) => s + v, 0)

    const grandTotal = totalSubs + totalInterest + totalFines + totalRegistration - totalExpenses
    const unloanable = grandTotal * 0.2
    const activeLoansBalance = (loans.data ?? []).filter((l) => l.status !== 'cleared').reduce((s, l) => s + Number(l.balance), 0)
    const totalDisbursed = loans.data?.reduce((s, l) => s + Number(l.principal_amount), 0) ?? 0
    const loanable = Math.max(0, grandTotal * 0.8 - totalDisbursed)

    setData({
      monthlySubs, monthlyInterest, monthlyExpenses,
      totalSubs, totalInterest, totalFines, totalRegistration, totalExpenses,
      withdrawnAmount, grandTotal, unloanable, loanable, activeLoansBalance,
      loansDisbursed: totalDisbursed,
      loansOutstanding: activeLoansBalance,
    })
    setLoading(false)
  }

  async function downloadPDF() {
    const [{ jsPDF }, html2canvasMod] = await Promise.all([
      import('jspdf'),
      import('html2canvas'),
    ])
    const html2canvas = html2canvasMod.default
    const doc = new jsPDF('p', 'mm', 'a4')
    const pageW = 210
    const pageH = 297
    const margin = 14
    const contentW = pageW - margin * 2

    // === HEADER BANNER ===
    doc.setFillColor(3, 105, 161)
    doc.rect(0, 0, pageW, 32, 'F')
    doc.setFillColor(14, 165, 233)
    doc.rect(0, 28, pageW, 4, 'F')
    doc.setTextColor(255, 255, 255)
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(22)
    doc.text('ElevateUS Association', margin, 15)
    doc.setFont('helvetica', 'normal')
    doc.setFontSize(11)
    doc.text(`Financial Report — ${year === 'all' ? 'All Time' : year}`, margin, 22)
    doc.setFontSize(9)
    doc.text(`Generated: ${new Date().toLocaleString()}`, pageW - margin, 22, { align: 'right' })

    let y = 42

    // === FINANCIAL SUMMARY TABLE ===
    doc.setTextColor(30, 41, 59)
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(14)
    doc.text('Financial Summary', margin, y)
    y += 6

    const summaryRows: [string, string, string][] = [
      ['Registration Fees', formatCurrency(data.totalRegistration), ''],
      ['Subscriptions', formatCurrency(data.totalSubs), ''],
      ...(data.withdrawnAmount > 0 ? [['  Less: Withdrawn (left members)', `(${formatCurrency(data.withdrawnAmount)})`, ''] as [string, string, string]] : []),
      ['Interest Earned', formatCurrency(data.totalInterest), ''],
      ['Fines', formatCurrency(data.totalFines), ''],
      ['Expenses', `(${formatCurrency(data.totalExpenses)})`, ''],
      ['Grand Total', formatCurrency(data.grandTotal), 'bold'],
      ['Unloanable Reserve (20%)', formatCurrency(data.unloanable), 'highlight'],
      ['Loanable Funds (80% − Disbursed)', formatCurrency(data.loanable), 'highlight2'],
      ['Total Loans Disbursed', formatCurrency(data.loansDisbursed), ''],
      ['Loans Outstanding', formatCurrency(data.activeLoansBalance), ''],
    ]

    // Table header
    doc.setFillColor(241, 245, 249)
    doc.rect(margin, y, contentW, 8, 'F')
    doc.setFontSize(10)
    doc.setFont('helvetica', 'bold')
    doc.setTextColor(51, 65, 85)
    doc.text('Description', margin + 3, y + 5.5)
    doc.text('Amount (KES)', pageW - margin - 3, y + 5.5, { align: 'right' })
    y += 8

    doc.setFont('helvetica', 'normal')
    doc.setFontSize(10)
    for (const [label, amount, style] of summaryRows) {
      const rowH = 7
      if (style === 'bold') {
        doc.setFillColor(226, 232, 240)
        doc.rect(margin, y, contentW, rowH, 'F')
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(15, 23, 42)
      } else if (style === 'highlight') {
        doc.setFillColor(254, 243, 199)
        doc.rect(margin, y, contentW, rowH, 'F')
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(146, 64, 14)
      } else if (style === 'highlight2') {
        doc.setFillColor(220, 252, 231)
        doc.rect(margin, y, contentW, rowH, 'F')
        doc.setFont('helvetica', 'bold')
        doc.setTextColor(22, 101, 52)
      } else {
        doc.setFont('helvetica', 'normal')
        doc.setTextColor(51, 65, 85)
      }
      doc.text(label, margin + 3, y + 5)
      doc.text(amount, pageW - margin - 3, y + 5, { align: 'right' })
      y += rowH
      doc.setDrawColor(226, 232, 240)
      doc.line(margin, y, pageW - margin, y)
    }

    y += 8

    // === CHARTS SECTION ===
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(14)
    doc.setTextColor(30, 41, 59)
    doc.text('Visual Analysis', margin, y)
    y += 6

    // Capture charts from canvas refs
    const chartImgs: { img: string; w: number; h: number }[] = []

    for (const ref of [doughnutRef, barRef, lineRef]) {
      const canvas = ref.current?.canvas as HTMLCanvasElement | undefined
      if (canvas) {
        const canvasImg = await html2canvas(canvas, { backgroundColor: '#ffffff', scale: 2 })
        chartImgs.push({ img: canvasImg.toDataURL('image/png'), w: canvasImg.width, h: canvasImg.height })
      }
    }

    // Layout: doughnut on left, bar on right, line below
    if (chartImgs.length >= 1) {
      const halfW = (contentW - 4) / 2
      // Doughnut (left)
      const dAspect = chartImgs[0].h / chartImgs[0].w
      const dH = halfW * dAspect
      doc.addImage(chartImgs[0].img, 'PNG', margin, y, halfW, dH)
      doc.setFontSize(9)
      doc.setFont('helvetica', 'bold')
      doc.setTextColor(51, 65, 85)
      doc.text('Income Composition', margin + halfW / 2, y + dH + 5, { align: 'center' })

      // Bar chart (right)
      if (chartImgs.length >= 2) {
        const bAspect = chartImgs[1].h / chartImgs[1].w
        const bH = halfW * bAspect
        const bY = y + (dH - bH) / 2
        doc.addImage(chartImgs[1].img, 'PNG', margin + halfW + 4, bY, halfW, bH)
        doc.text('Monthly Cash Flow', margin + halfW + 4 + halfW / 2, y + dH + 5, { align: 'center' })
      }

      y += dH + 12
    }

    // Line chart (full width)
    if (chartImgs.length >= 3) {
      const lAspect = chartImgs[2].h / chartImgs[2].w
      const lH = contentW * lAspect
      if (y + lH > pageH - 20) { doc.addPage(); y = 20 }
      doc.addImage(chartImgs[2].img, 'PNG', margin, y, contentW, lH)
      doc.setFontSize(9)
      doc.setFont('helvetica', 'bold')
      doc.setTextColor(51, 65, 85)
      doc.text('Subscriptions Trend', pageW / 2, y + lH + 5, { align: 'center' })
      y += lH + 12
    }

    // === MONTHLY BREAKDOWN TABLE ===
    if (y > pageH - 60) { doc.addPage(); y = 20 }
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(14)
    doc.setTextColor(30, 41, 59)
    doc.text('Monthly Breakdown', margin, y)
    y += 6

    // Table header
    doc.setFillColor(3, 105, 161)
    doc.rect(margin, y, contentW, 8, 'F')
    doc.setFontSize(10)
    doc.setFont('helvetica', 'bold')
    doc.setTextColor(255, 255, 255)
    const colW = contentW / 4
    doc.text('Month', margin + 3, y + 5.5)
    doc.text('Subscriptions', margin + colW + 3, y + 5.5)
    doc.text('Interest', margin + colW * 2 + 3, y + 5.5)
    doc.text('Expenses', margin + colW * 3 + 3, y + 5.5)
    y += 8

    doc.setFont('helvetica', 'normal')
    doc.setFontSize(9)
    for (let i = 0; i < 12; i++) {
      if (y > pageH - 15) { doc.addPage(); y = 20 }
      const isAlt = i % 2 === 1
      if (isAlt) {
        doc.setFillColor(248, 250, 252)
        doc.rect(margin, y, contentW, 7, 'F')
      }
      doc.setTextColor(51, 65, 85)
      doc.text(monthName(i + 1), margin + 3, y + 5)
      doc.setTextColor(14, 165, 233)
      doc.text(formatCurrency(Math.round(data.monthlySubs[i])), margin + colW + 3, y + 5)
      doc.setTextColor(20, 184, 166)
      doc.text(formatCurrency(Math.round(data.monthlyInterest[i])), margin + colW * 2 + 3, y + 5)
      doc.setTextColor(220, 38, 38)
      doc.text(formatCurrency(Math.round(data.monthlyExpenses[i])), margin + colW * 3 + 3, y + 5)
      y += 7
    }

    // Totals row
    doc.setFillColor(226, 232, 240)
    doc.rect(margin, y, contentW, 8, 'F')
    doc.setFont('helvetica', 'bold')
    doc.setTextColor(15, 23, 42)
    doc.text('TOTAL', margin + 3, y + 5.5)
    doc.setTextColor(14, 165, 233)
    doc.text(formatCurrency(data.totalSubs), margin + colW + 3, y + 5.5)
    doc.setTextColor(20, 184, 166)
    doc.text(formatCurrency(data.totalInterest), margin + colW * 2 + 3, y + 5.5)
    doc.setTextColor(220, 38, 38)
    doc.text(formatCurrency(data.totalExpenses), margin + colW * 3 + 3, y + 5.5)

    // === FOOTER ===
    const pageCount = doc.getNumberOfPages()
    for (let i = 1; i <= pageCount; i++) {
      doc.setPage(i)
      doc.setFontSize(8)
      doc.setTextColor(148, 163, 184)
      doc.text('ElevateUS Association — Confidential', margin, pageH - 8)
      doc.text(`Page ${i} of ${pageCount}`, pageW - margin, pageH - 8, { align: 'right' })
    }

    doc.save(`elevateus-report-${year === 'all' ? 'all-time' : year}.pdf`)
  }

  if (loading || !data) return <div className="loading-center"><div className="spinner" /></div>

  const months = Array.from({ length: 12 }, (_, i) => monthName(i + 1).slice(0, 3))
  const barData = {
    labels: months,
    datasets: [
      { label: 'Subscriptions', data: data.monthlySubs, backgroundColor: '#0ea5e9' },
      { label: 'Interest', data: data.monthlyInterest, backgroundColor: '#14b8a6' },
      { label: 'Expenses', data: data.monthlyExpenses, backgroundColor: '#dc2626' },
    ],
  }
  const doughnutData = {
    labels: ['Subscriptions', 'Registration', 'Interest', 'Fines', 'Expenses'],
    datasets: [{
      data: [data.totalSubs, data.totalRegistration, data.totalInterest, data.totalFines, data.totalExpenses],
      backgroundColor: ['#0ea5e9', '#8b5cf6', '#14b8a6', '#d97706', '#dc2626'],
    }],
  }
  const lineData = {
    labels: months,
    datasets: [{ label: 'Subscriptions', data: data.monthlySubs, borderColor: '#0ea5e9', backgroundColor: 'rgba(14,165,233,0.1)', fill: true, tension: 0.3 }],
  }

  const cards = [
    { label: 'Registration Fees', value: data.totalRegistration, icon: Receipt, color: '#8b5cf6', bg: '#ede9fe' },
    { label: 'Subscriptions', value: data.totalSubs, icon: Wallet, color: '#0ea5e9', bg: '#e0f2fe' },
    { label: 'Interest', value: data.totalInterest, icon: TrendingUp, color: '#14b8a6', bg: '#ccfbf1' },
    { label: 'Fines', value: data.totalFines, icon: AlertTriangle, color: '#d97706', bg: '#fef3c7' },
    { label: 'Expenses', value: data.totalExpenses, icon: TrendingDown, color: '#dc2626', bg: '#fee2e2' },
    { label: 'Total Disbursed', value: data.loansDisbursed, icon: Landmark, color: '#0369a1', bg: '#e0f2fe' },
  ]

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <label className="text-sm font-semibold">Period:</label>
          <select value={String(year)} onChange={(e) => setYear(e.target.value === 'all' ? 'all' : Number(e.target.value))} style={{ padding: '8px 10px', borderRadius: 8, border: '1px solid var(--border)' }}>
            <option value="all">All Time</option>
            {[currentYear(), currentYear() - 1, currentYear() - 2].map((y) => <option key={y} value={y}>{y}</option>)}
          </select>
        </div>
        <button className="btn btn-primary" onClick={downloadPDF}><Download size={16} /> Download PDF</button>
      </div>

      {data.withdrawnAmount > 0 && (
        <div style={{ background: '#fef3c7', borderRadius: 10, padding: '12px 16px', marginBottom: 16, border: '1px solid #fde68a', fontSize: 13, color: '#92400e' }}>
          Subscriptions exclude <strong>KES {data.withdrawnAmount.toLocaleString()}</strong> withdrawn by members who have left the association.
        </div>
      )}

      <div className="stat-grid" style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(180px, 1fr))' }}>
        {cards.map((c) => (
          <div className="stat-card" key={c.label}>
            <div className="stat-icon" style={{ background: c.bg, color: c.color }}><c.icon size={20} /></div>
            <div className="stat-label">{c.label}</div>
            <div className="stat-value">{formatCurrency(c.value)}</div>
          </div>
        ))}
      </div>

      <div className="grid-2" style={{ marginTop: 16 }}>
        <div className="card" style={{ border: '1px solid var(--border)' }}>
          <div className="card-header"><h3>Fund Summary {year === 'all' ? '(All Time)' : year}</h3></div>
          <div style={{ padding: '4px 20px 20px' }}>
            <SummaryRow label="Registration Fees" value={data.totalRegistration} />
            <SummaryRow label="Subscriptions" value={data.totalSubs} />
            {data.withdrawnAmount > 0 && <SummaryRow label="  Less: Withdrawn (left members)" value={-data.withdrawnAmount} small />}
            <SummaryRow label="Interest Earned" value={data.totalInterest} />
            <SummaryRow label="Fines" value={data.totalFines} />
            <SummaryRow label="Expenses" value={data.totalExpenses} negative />
            <div style={{ borderTop: '2px solid var(--border)', margin: '10px 0', paddingTop: 10 }}>
              <SummaryRow label="Grand Total" value={data.grandTotal} bold />
            </div>
            <div style={{ background: '#fef3c7', borderRadius: 12, padding: 16, marginTop: 12, border: '1px solid #fde68a' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <ShieldCheck size={18} color="#b45309" />
                  <span style={{ fontWeight: 600, color: '#92400e', fontSize: 14 }}>Unloanable Reserve (20%)</span>
                </div>
                <span style={{ fontWeight: 700, color: '#92400e', fontSize: 16 }}>{formatCurrency(data.unloanable)}</span>
              </div>
              <div style={{ fontSize: 12, color: '#a16207', marginTop: 4 }}>Protected reserve — not available for lending</div>
            </div>
            <div style={{ background: '#dcfce7', borderRadius: 12, padding: 16, marginTop: 12, border: '1px solid #bbf7d0' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <Banknote size={18} color="#15803d" />
                  <span style={{ fontWeight: 600, color: '#166534', fontSize: 14 }}>Loanable Funds (80%)</span>
                </div>
                <span style={{ fontWeight: 700, color: '#166534', fontSize: 16 }}>{formatCurrency(data.loanable)}</span>
              </div>
              <div style={{ fontSize: 12, color: '#15803d', marginTop: 4 }}>
                80% of total ({formatCurrency(data.grandTotal * 0.8)}) minus total disbursed loans ({formatCurrency(data.loansDisbursed)})
              </div>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-header"><h3>Income vs Expenses</h3></div>
          <div className="card-body"><Doughnut ref={doughnutRef} data={doughnutData} options={{ responsive: true, plugins: { legend: { position: 'bottom' } } }} /></div>
        </div>
      </div>

      <div className="grid-2" style={{ marginTop: 16 }}>
        <div className="card"><div className="card-header"><h3>Monthly Cash Flow</h3></div><div className="card-body"><Bar ref={barRef} data={barData} options={{ responsive: true, plugins: { legend: { position: 'bottom' } } }} /></div></div>
        <div className="card"><div className="card-header"><h3>Subscriptions Trend</h3></div><div className="card-body"><Line ref={lineRef} data={lineData} options={{ responsive: true, plugins: { legend: { position: 'bottom' } } }} /></div></div>
      </div>
    </div>
  )
}

function SummaryRow({ label, value, bold, negative, small }: { label: string; value: number; bold?: boolean; negative?: boolean; small?: boolean }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: small ? 12 : 14, marginBottom: 6, fontWeight: bold ? 700 : 400 }}>
      <span style={{ color: 'var(--text-3)' }}>{label}</span>
      <span style={{ fontWeight: bold ? 700 : 500, color: negative ? 'var(--error)' : bold ? 'var(--brand)' : 'var(--text-2)' }}>
        {negative ? '−' : ''}{formatCurrency(Math.abs(value))}
      </span>
    </div>
  )
}
