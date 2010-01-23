#
# The state of the referral relative to the ReferralSource. This state is used for sorting and filtering
# within the dashboard grid of the source.
#
#
#
class ReferralSourceState < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  NEW = 'new'
  WAITING_ACCEPTANCE = 'waiting_acceptance'
  IN_PROGRESS = 'in_progress'
  WAITING_RESPONSE = 'waiting_response'
  NEW_INFO = 'new_info'
  DECLINED_BY_TARGET = 'declined'
  WITHDRAWN = 'withdrawn'
  CLOSED = 'closed'
end
