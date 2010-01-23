#
# Stores the insurance carrier/plan tags and other details related to the patient.
#
#
#
class ReferralInsurancePlan < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
  belongs_to :referral
  belongs_to :insurance_carrier_tag, :class_name=>"Tag", :foreign_key=>"insurance_carrier_tag_id"
  belongs_to :insurance_carrier_plan_tag, :class_name=>"Tag", :foreign_key=>"insurance_carrier_plan_tag_id"

  def self.find_eager(id)
    return ReferralInsurancePlan.find(:first, :conditions=>["referral_insurance_plans.id = ?",id], :include=>[:insurance_carrier_tag, :insurance_carrier_plan_tag])
  end

  def display_carrier_name
    return insurance_carrier_tag.name if !insurance_carrier_tag.nil?
    return nil
  end

  def display_plan
    return insurance_carrier_plan_tag.name if !insurance_carrier_plan_tag.nil?
    return nil
  end

  def display_details
    return policy_details
  end
end
