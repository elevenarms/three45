require File.dirname(__FILE__) + '/../test_helper'

class ReferralPatientTest < ActiveSupport::TestCase
  def test_fixtures_should_load
    assert ReferralPatient.count > 0
  end

  def test_find_eager_should_load_patient
    patient = ReferralPatient.find_eager(referral_patients(:welby_to_stretch_patient).id)
    assert_not_nil patient
    assert_not_nil patient.referral
  end

end
