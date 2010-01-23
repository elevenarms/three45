#
# The state of the referral relative to the ReferralTarget. This state is used for sorting and filtering
# within the dashboard grid of the target.
#
#
#
class ReferralTargetState < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  NEW = 'new'
  WAITING_ACCEPTANCE = 'waiting_acceptance'
  IN_PROGRESS = 'in_progress'
  WAITING_RESPONSE = 'waiting_response'
  NEW_INFO = 'new_info'
  DECLINED = 'declined'
  WITHDRAWN_BY_SOURCE = 'withdrawn_by_source'
  CLOSED = 'closed'

end
