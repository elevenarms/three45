#
# Tracks studies associated to the Referral.
#
#
#
class ReferralStudy < ActiveRecord::Base
  uses_guid

  belongs_to :referral
  belongs_to :study_type_tag, :class_name=>"Tag"
  belongs_to :study_modality_tag, :class_name=>"Tag"
  belongs_to :location_tag, :class_name=>"Tag"
  belongs_to :location_detail_tag, :class_name=>"Tag"

end
