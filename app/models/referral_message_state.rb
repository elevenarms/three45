#
# Marks a ReferralMessage state, based on if the note is a note or a request for action.
#
#
#
class ReferralMessageState < ActiveRecord::Base
  uses_guid

  COMPLETE = 'complete'
  WAITING_RESPONSE = 'waiting_response'
  NEW_INFO = 'new_info'
  VOID = 'void'
end
