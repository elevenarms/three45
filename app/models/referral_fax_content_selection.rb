#
# Stores the type of content the fax contains
#
#
#
class ReferralFaxContentSelection < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :referral_fax
end
