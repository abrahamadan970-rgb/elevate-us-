import type { UserRole } from '../types'

export function canManageMembers(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'leader' || role === 'secretary' || role === 'chairperson'
}

export function canManageFinance(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'treasurer'
}

export function canApproveLoans(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'treasurer' || role === 'chairperson'
}

export function canManageSettings(role: UserRole | undefined): boolean {
  return role === 'admin'
}

export function canDeleteTransactions(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'treasurer'
}

export function canSendEmails(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'leader' || role === 'treasurer' || role === 'secretary' || role === 'chairperson'
}

export function canManageMinutes(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'leader' || role === 'secretary' || role === 'chairperson'
}

export function canManageEvents(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'leader' || role === 'secretary' || role === 'chairperson'
}

export function canManageLeaders(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'chairperson'
}

export function canManageConstitution(role: UserRole | undefined): boolean {
  return role === 'admin' || role === 'chairperson'
}

export function isMember(role: UserRole | undefined): boolean {
  return role === 'member'
}

export function canEditData(role: UserRole | undefined): boolean {
  return role !== 'member' && role !== undefined
}

export function roleLabel(role: UserRole): string {
  const labels: Record<UserRole, string> = {
    admin: 'Administrator',
    leader: 'Leader',
    member: 'Member',
    treasurer: 'Treasurer',
    secretary: 'Secretary',
    chairperson: 'Chairperson',
  }
  return labels[role] ?? role
}
