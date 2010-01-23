#
# A subtype for a referral message that specifics the contents of the message and any attached files.
#
#
#
class ReferralMessageSubtype < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
  belongs_to :referral_message_type
end
