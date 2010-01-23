require File.dirname(__FILE__) + '/../test_helper'

class ReferralInsurancePlanTest < ActiveSupport::TestCase
  def test_fixtures_should_load
    assert ReferralInsurancePlan.count > 0
  end

  def test_should_load_eager
    plan = ReferralInsurancePlan.find_eager(referral_insurance_plans(:welby_to_stretch_plan).id)
    assert_not_nil plan
    assert_not_nil plan.referral
    assert_not_nil plan.insurance_carrier_tag
    assert_not_nil plan.insurance_carrier_plan_tag
  end
end
