export type UserRole = 'admin' | 'leader' | 'member' | 'treasurer' | 'secretary' | 'chairperson'
export type LoanStatus = 'pending' | 'approved' | 'rejected' | 'disbursed' | 'cleared' | 'defaulted'
export type MemberStatus = 'active' | 'inactive' | 'suspended'
export type EventType = 'meeting' | 'event' | 'fundraiser' | 'other'

export interface Profile {
  id: string
  email: string
  full_name: string
  role: UserRole
  phone: string | null
  avatar_url: string | null
  created_at: string
  updated_at: string
  must_change_password: boolean
}

export interface Member {
  id: string
  user_id: string | null
  full_name: string
  phone: string | null
  email: string | null
  join_date: string
  status: MemberStatus
  leave_date: string | null
  leave_reason: string | null
  notes: string | null
  is_defaulter: boolean
  defaulter_since: string | null
  created_at: string
  updated_at: string
}

export interface Subscription {
  id: string
  member_id: string
  amount: number
  payment_date: string
  payment_month: number
  payment_year: number
  payment_method: string | null
  receipt_number: string | null
  notes: string | null
  recorded_by: string | null
  created_at: string
  member?: Member
}

export interface MembershipFee {
  id: string
  member_id: string
  amount: number
  fee_year: number
  payment_date: string
  payment_method: string | null
  receipt_number: string | null
  notes: string | null
  recorded_by: string | null
  created_at: string
  member?: Member
}

export interface Loan {
  id: string
  member_id: string
  principal_amount: number
  interest_rate: number
  interest_amount: number
  mpesa_cost: number
  total_payable: number
  amount_repaid: number
  balance: number
  issue_date: string
  due_date: string
  status: LoanStatus
  penalty_rate: number
  penalty_amount: number
  approved_by: string | null
  notes: string | null
  is_carried_forward: boolean
  original_loan_id: string | null
  created_at: string
  updated_at: string
  member?: Member
}

export interface LoanRepayment {
  id: string
  loan_id: string
  amount: number
  payment_date: string
  payment_method: string | null
  notes: string | null
  recorded_by: string | null
  created_at: string
  repayment_type: string
  loan?: Loan
}

export interface Fine {
  id: string
  member_id: string
  fine_type: string
  amount: number
  reason: string | null
  issue_date: string
  paid: boolean
  paid_date: string | null
  recorded_by: string | null
  created_at: string
  member?: Member
}

export interface Expense {
  id: string
  category: string
  description: string
  amount: number
  expense_date: string
  receipt_url: string | null
  approved_by: string | null
  recorded_by: string | null
  notes: string | null
  created_at: string
}

export interface MonthlyInterest {
  id: string
  month: number
  year: number
  amount: number
  notes: string | null
  source_type: string
  loan_id: string | null
  created_at: string
  updated_at: string
}

export interface EventItem {
  id: string
  title: string
  description: string | null
  event_type: EventType
  event_date: string
  event_time: string | null
  location: string | null
  is_recurring: boolean
  recurrence_pattern: string | null
  created_by: string | null
  created_at: string
  updated_at: string
}

export interface Leader {
  id: string
  position: string
  position_description: string | null
  member_id: string | null
  start_date: string
  end_date: string | null
  is_active: boolean
  created_at: string
  updated_at: string
  member?: Member
}

export interface Minute {
  id: string
  title: string
  meeting_date: string
  meeting_type: string
  attendees: string | null
  agenda: string | null
  discussion: string | null
  decisions: string | null
  action_items: string | null
  attachment_url: string | null
  created_by: string | null
  created_at: string
  updated_at: string
}

export interface Settings {
  id: number
  reserve_percentage: number
  min_loan_balance: number
  default_interest_rate: number
  default_penalty_rate: number
  min_membership_months: number
  association_name: string
  association_motto: string
  association_email: string | null
  association_phone: string | null
}

export interface Constitution {
  id: number
  name: string
  motto: string
  mission: string | null
  vision: string | null
  objectives: string | null
  membership_rules: string | null
  code_of_conduct: string | null
  financial_rules: string | null
  amendment_rules: string | null
}
