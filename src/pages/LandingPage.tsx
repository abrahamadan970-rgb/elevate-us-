import { Link } from 'react-router-dom'
import { ArrowRight, Users, Wallet, Landmark, TrendingUp, ShieldCheck, CalendarDays, FileText, Mail, ChartBar as BarChart3, CircleCheck as CheckCircle2, Quote } from 'lucide-react'

export default function LandingPage() {
  return (
    <div className="landing">
      {/* Nav */}
      <nav className="landing-nav">
        <div className="landing-nav-inner">
          <div className="landing-brand">
            <div className="logo">E</div>
            <span>ElevateUS</span>
          </div>
          <Link to="/portal" className="btn btn-primary btn-sm landing-cta-nav">
            Sign In <ArrowRight size={16} />
          </Link>
        </div>
      </nav>

      {/* Hero */}
      <section className="landing-hero">
        <div className="landing-hero-bg" />
        <div className="landing-hero-content">
          <div className="landing-hero-badge">
            <ShieldCheck size={15} /> Members Association Platform
          </div>
          <h1>
            Rise together, <br />
            <span className="hero-accent">achieve more</span>
          </h1>
          <p className="landing-hero-sub">
            Manage memberships, subscriptions, loans, and finances — all in one place.
            Built for associations that value transparency and growth.
          </p>
          <div className="landing-hero-actions">
            <Link to="/portal" className="btn btn-primary landing-cta-big">
              Sign In to Portal <ArrowRight size={18} />
            </Link>
            <a href="#features" className="btn btn-secondary landing-cta-ghost">
              Explore Features
            </a>
          </div>
          <div className="landing-hero-stats">
            <div className="hero-stat">
              <div className="hero-stat-num">9+</div>
              <div className="hero-stat-label">Members</div>
            </div>
            <div className="hero-stat-divider" />
            <div className="hero-stat">
              <div className="hero-stat-num">15+</div>
              <div className="hero-stat-label">Tools</div>
            </div>
            <div className="hero-stat-divider" />
            <div className="hero-stat">
              <div className="hero-stat-num">100%</div>
              <div className="hero-stat-label">Transparent</div>
            </div>
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="landing-section" id="features">
        <div className="landing-section-head">
          <h2>Everything your association needs</h2>
          <p>A complete toolkit to manage every aspect of your group — from people to money.</p>
        </div>
        <div className="feature-grid">
          <FeatureCard icon={Users} title="Member Management" desc="Track members, leaders, and roles. Keep records of join dates, status, and contact info." color="#0ea5e9" bg="#e0f2fe" />
          <FeatureCard icon={Wallet} title="Subscriptions" desc="Record monthly contributions and track payment history with receipts." color="#14b8a6" bg="#ccfbf1" />
          <FeatureCard icon={Landmark} title="Loans & Repayments" desc="Approve, disburse, and track loans with automatic interest calculation." color="#0369a1" bg="#e0f2fe" />
          <FeatureCard icon={TrendingUp} title="Interest Tracking" desc="Monthly interest from loans is calculated and recorded automatically." color="#d97706" bg="#fef3c7" />
          <FeatureCard icon={CalendarDays} title="Events" desc="Schedule meetings, fundraisers, and association events with reminders." color="#8b5cf6" bg="#ede9fe" />
          <FeatureCard icon={FileText} title="Meeting Minutes" desc="Document decisions, action items, and agendas for every meeting." color="#0891b2" bg="#cffafe" />
          <FeatureCard icon={BarChart3} title="Reports & Insights" desc="Full financial overview with fund summaries, reserves, and loanable amounts." color="#16a34a" bg="#dcfce7" />
          <FeatureCard icon={Mail} title="Email Center" desc="Send announcements, reminders, and statements directly to members." color="#dc2626" bg="#fee2e2" />
        </div>
      </section>

      {/* How it works */}
      <section className="landing-section landing-section-alt">
        <div className="landing-section-head">
          <h2>How it works</h2>
          <p>Three simple steps to keep your association running smoothly.</p>
        </div>
        <div className="steps-grid">
          <StepCard num="01" title="Enter the Portal" desc="Click through to the dashboard — no sign-in hassle, just instant access to your association hub." />
          <StepCard num="02" title="Manage Your Data" desc="Add members, record subscriptions, approve loans, and track every shilling that flows in and out." />
          <StepCard num="03" title="Stay Informed" desc="Generate reports, send emails, and keep everyone in the loop with meeting minutes and event updates." />
        </div>
      </section>

      {/* Testimonial */}
      <section className="landing-section">
        <div className="testimonial-card">
          <Quote size={36} className="quote-icon" />
          <blockquote>
            "ElevateUS has transformed how we manage our association. Everything from subscriptions
            to loans is now transparent and organized. We can see exactly where every shilling is."
          </blockquote>
          <div className="testimonial-author">
            <div className="testimonial-avatar">TN</div>
            <div>
              <div className="testimonial-name">Talia Natembea</div>
              <div className="testimonial-role">Association Administrator</div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="landing-cta-section">
        <div className="landing-cta-box">
          <h2>Ready to manage your association?</h2>
          <p>Jump straight into the dashboard and start managing your members, finances, and events.</p>
          <Link to="/portal" className="btn btn-primary landing-cta-big">
            Sign In to Portal <ArrowRight size={18} />
          </Link>
        </div>
      </section>

      {/* Footer */}
      <footer className="landing-footer">
        <div className="landing-footer-inner">
          <div className="landing-brand">
            <div className="logo">E</div>
            <span>ElevateUS</span>
          </div>
          <p>© 2026 ElevateUS Association. Rise together, achieve more.</p>
        </div>
      </footer>
    </div>
  )
}

function FeatureCard({ icon: Icon, title, desc, color, bg }: {
  icon: React.ComponentType<{ size?: number; className?: string }>
  title: string; desc: string; color: string; bg: string
}) {
  return (
    <div className="feature-card">
      <div className="feature-icon" style={{ background: bg, color }}>
        <Icon size={24} />
      </div>
      <h3>{title}</h3>
      <p>{desc}</p>
    </div>
  )
}

function StepCard({ num, title, desc }: { num: string; title: string; desc: string }) {
  return (
    <div className="step-card">
      <div className="step-num">{num}</div>
      <h3>{title}</h3>
      <p>{desc}</p>
    </div>
  )
}
