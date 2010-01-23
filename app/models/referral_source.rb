#
# The source, or referring physician, for the referral.
#
#
#
class ReferralSource < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :referral
  belongs_to :referral_source_state
  belongs_to :workgroup
  belongs_to :user

  def status_new?
    return self.referral_source_state_id == ReferralSourceState::NEW
  end

  def status_waiting_acceptance?
    return self.referral_source_state_id == ReferralSourceState::WAITING_ACCEPTANCE
  end

  def status_in_progress?
    return self.referral_source_state_id == ReferralSourceState::IN_PROGRESS
  end

  def status_waiting_response?
    return self.referral_source_state_id == ReferralSourceState::WAITING_RESPONSE
  end

  def status_new_info?
    return self.referral_source_state_id == ReferralSourceState::NEW_INFO
  end

  def status_declined_by_target?
    return self.referral_source_state_id == ReferralSourceState::DECLINED_BY_TARGET
  end

  def status_withdrawn?
    return self.referral_source_state_id == ReferralSourceState::WITHDRAWN
  end

  def status_closed?
    return self.referral_source_state_id == ReferralSourceState::CLOSED
  end

  def has_open_requests?
    open_requests = ReferralMessage.find_open_requests_for(self.referral_id, self.id)
    return (open_requests.length > 0)
  end

  def has_unread_messages?
    unread_messages = ReferralMessage.find_unread_messages_for(self.referral_id, self.id)
    return (unread_messages.length > 0)
  end

  def display_name
    return self.workgroup.name if self.user.nil?
    return self.user.last_first unless self.user.nil?
    return "N/A"
  end

  def display_id
    return self.workgroup.id if self.user.nil?
    return self.user.id unless self.user.nil?
    return "N/A"
  end

  def is_source?(workgroup_id)
    return (self.workgroup_id == workgroup_id)
  end
end
