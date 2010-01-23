#
# Represents one of possibly multiple diagnosis selections for a referral.
#
#
#
class ReferralDiagnosisSelection < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :referral_diagnosis_option
  belongs_to :referral
end
