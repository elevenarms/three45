#
# The target, or consultant, for the referral.
#
#
#
class ReferralTarget < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :referral
  belongs_to :referral_target_state
  belongs_to :workgroup
  belongs_to :user

  before_save :before_save

  def before_save
    self.display_name = self.workgroup.name if self.workgroup.apw? or self.user.nil?
    self.display_name = self.user.last_first unless self.workgroup.apw? or self.user.nil?
  end

  def status_new?
    return self.referral_target_state_id == ReferralTargetState::NEW
  end

  def status_waiting_acceptance?
    return self.referral_target_state_id == ReferralTargetState::WAITING_ACCEPTANCE
  end

  def status_in_progress?
    return self.referral_target_state_id == ReferralTargetState::IN_PROGRESS
  end

  def status_waiting_response?
    return self.referral_target_state_id == ReferralTargetState::WAITING_RESPONSE
  end

  def status_new_info?
    return self.referral_target_state_id == ReferralTargetState::NEW_INFO
  end

  def status_declined?
    return self.referral_target_state_id == ReferralTargetState::DECLINED
  end

  def status_withdrawn_by_source?
    return self.referral_target_state_id == ReferralTargetState::WITHDRAWN_BY_SOURCE
  end

  def status_closed?
    return self.referral_target_state_id == ReferralTargetState::CLOSED
  end

  def has_open_requests?
    open_requests = ReferralMessage.find_open_requests_for(self.referral_id, self.id)
    return (open_requests.length > 0)
  end

  def has_unread_messages?
    unread_messages = ReferralMessage.find_unread_messages_for(self.referral_id, self.id)
    return (unread_messages.length > 0)
  end

  def is_target?(workgroup_id)
    return (self.workgroup_id == workgroup_id)
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
end
