import type { UserRole } from '../types'

export function canManageMembers(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'leader' || role === 'secretary'
}

export function canManageFinance(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'treasurer'
}

export function canApproveLoans(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'treasurer'
}

export function canManageSettings(role: UserRole | undefined): boolean {
  return role === 'admin'
}

export function canDeleteTransactions(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'treasurer'
}

export function canSendEmails(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'leader' || role === 'treasurer' || role === 'secretary'
}

export function canManageMinutes(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'leader' || role === 'secretary'
}

export function roleLabel(role: UserRole): string {
  const labels: Record<UserRole, string> = {
    admin: 'Administrator',
    leader: 'Leader',
    member: 'Member',
    treasurer: 'Treasurer',
    secretary: 'Secretary',
  }
  return labels[role] ?? role
}
