#
# A message from the referral source or target to the other referral party. Anyone with access
# to the referral may read the message (i.e. there are no direct messages to a specific user).
#
# The ReferralMessage has a type, such as a note, or may be a request for the other party to take action.
#
# ReferralFiles and ReferralFaxes may be associated to a message.
#
#
class ReferralMessage < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
  belongs_to :referral
  belongs_to :referral_message_type
  belongs_to :referral_message_state
  belongs_to :created_by, :foreign_key=>"created_by_user_id", :class_name=>"User"
  belongs_to :reply_to_message, :foreign_key=>"reply_to_message_id", :class_name=>"ReferralMessage"
  has_many :referral_message_subtype_selections
  has_many :referral_files
  has_many :referral_faxes

  validates_presence_of :created_by_user_id
  validates_presence_of :referral_message_type_id
  validates_presence_of :subject
  validates_presence_of :response_required_by, :if=>:validate_response_required

  def self.find_eager(id)
    return ReferralMessage.find(:first, :conditions=>["referral_messages.id = ?", id], :include=>[:referral, :referral_message_type, :referral_message_subtype_selections, :created_by])
  end

  # Perform a search of all messages for a specific referral using the given filter
  # (ignores replies, since they are shown inline with the original message)
  def self.search_and_filter(filter, results_per_page)
    page_number = (filter.page_number || "1").to_i
    offset = page_number == 1 ? nil : (page_number-1) * results_per_page
    order_by = filter.to_order_by
    count = ReferralMessage.count('id', :conditions=>["referral_id = ? AND reply_to_message_id IS NULL", filter.referral_id], :include=>[:referral_message_type, :referral_message_state], :order=>order_by)
    results = ReferralMessage.find(:all, :conditions=>["referral_id = ? AND reply_to_message_id IS NULL", filter.referral_id], :include=>[:referral_message_type, :referral_message_state], :order=>order_by, :limit=>results_per_page, :offset=>offset)

    total_pages = (count / results_per_page)
    total_pages += 1 if (count % results_per_page) != 0

    return results, total_pages
  end

  def self.find_open_requests_for(referral_id, referral_source_or_target_id)
    return ReferralMessage.find(:all, :conditions=>["(referral_message_type_id = 'request' OR referral_message_type_id = 'reply_request' OR referral_message_type_id = 'referral_request') AND responded_at IS NULL AND referral_id = ? AND referral_source_or_target_id = ? AND referral_message_state_id != 'void'", referral_id, referral_source_or_target_id])
  end

  def self.find_unread_messages_for(referral_id, referral_source_or_target_id)
    return ReferralMessage.find(:all, :conditions=>["viewed_at IS NULL AND referral_id = ? AND referral_source_or_target_id = ? AND referral_message_state_id != 'void'", referral_id, referral_source_or_target_id])
  end

  def self.find_all_top_level_messages_for(referral_id)
    return ReferralMessage.find(:all, :conditions=>["referral_id = ? AND reply_to_message_id IS NULL", referral_id], :include=>[:referral_message_type, :referral_message_state], :order=>"referral_messages.created_at DESC")
  end

  def self.count_open_requests_for(referral_id, referral_source_or_target_id)
    return ReferralMessage.count('id', :conditions=>["referral_message_state_id = 'waiting_response' AND responded_at IS NULL AND referral_id = ? AND referral_source_or_target_id = ? AND referral_message_state_id != 'void'", referral_id, referral_source_or_target_id])
  end

  def self.count_new_info_for(referral_id, referral_source_or_target_id)
    return ReferralMessage.count('id', :conditions=>["referral_message_state_id = 'new_info' AND referral_id = ? AND referral_source_or_target_id = ? AND referral_message_state_id != 'void'", referral_id, referral_source_or_target_id])
  end

  def validate_response_required
    return (!referral_message_type_id.nil? and request?)
  end

  def request?
    return (self.referral_message_type_id == 'request' or
            self.referral_message_type_id == 'reply_request' or
            self.referral_message_type_id == 'referral_request')
  end

  def note?
    return !request?
  end

  def reply?
    return !self.reply_to_message_id.nil?
  end

  def status_complete?
    return referral_message_state_id == ReferralMessageState::COMPLETE
  end

  def status_waiting_response?
    return referral_message_state_id == ReferralMessageState::WAITING_RESPONSE
  end

  def status_new_info?
    return referral_message_state_id == ReferralMessageState::NEW_INFO
  end

  def status_void?
    return referral_message_state_id == ReferralMessageState::VOID
  end

  def can_reply?
    # can only reply if this is a top-level message (1 reply limit)
    return (self.reply_to_message_id.nil? and !has_reply?)
  end

  def has_reply?
    return (reply_message != nil)
  end

  def is_reply?
    return (reply_to_message_id != nil)
  end

  def is_original_message?
    return (reply_to_message_id == nil)
  end

  def reply_message
    # if null, will always try to fetch to ensure one hasn't been created. Otherwise, return previously loaded version
    @reply_message = ReferralMessage.find(:first, :conditions=>["reply_to_message_id = ?", self.id]) if @reply_message.nil?
    return @reply_message
  end

  def has_documents_or_faxes?
    return (!referral_files.empty? or !referral_faxes.empty?)
  end

  def display_status
    return referral_message_state.name if referral_message_state
    return "N/A"
  end

  def display_type
    return referral_message_type.name if referral_message_type
    return "N/A"
  end

  def display_created_at
    return created_at.strftime("%m/%d/%Y") if !created_at.nil?
    return "N/A"
  end

  def display_created_at_with_time
    return created_at.strftime("%m/%d/%Y %I:%M %p") if !created_at.nil?
    return "N/A"
  end

  def display_response_required_by
    return response_required_by.strftime("%m/%d/%Y") if !response_required_by.nil?
    return "N/A"
  end

  def display_message_text
    return message_text if !message_text.nil?
    return "N/A"
  end

  def display_subject
    return subject if !subject.nil?
    return "N/A"
  end
end
