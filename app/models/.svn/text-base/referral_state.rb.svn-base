#
# The overall state of the referral, independent of the source and target states.
#
#
#
class ReferralState < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  NEW = 'new'
  WAITING_APPROVAL = 'waiting_approval'
  PROVISIONAL = 'provisional'
  IN_PROGRESS = 'in_progress'
  CLOSED = 'closed'
end
