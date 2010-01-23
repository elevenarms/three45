#
# The tag indicating the type of the Referral
#
#
#
class ReferralTypeSelection < ActiveRecord::Base
  uses_guid

  belongs_to :referral
  belongs_to :tag_type
  belongs_to :tag
end
