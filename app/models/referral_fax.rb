#
# Represents a fax that is being shared between referral parties. ReferralFaxFiles represent the actual contents
# that have been received by the Fax Integration Service.
#
# The referral_fax_state determines the state of the fax and if it has been received from the third party fax service.
#
#
#
class ReferralFax < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :referral
  belongs_to :referral_fax_state
  has_many :referral_fax_content_selections
  has_many :referral_fax_files

  def status_waiting?
    return self.referral_fax_state_id == 'waiting'
  end

  def status_received_successfully?
    return self.referral_fax_state_id == 'received_successfully'
  end

  def status_received_error?
    return self.referral_fax_state_id == 'received_error'
  end
end
