require File.dirname(__FILE__) + '/../test_helper'

class PatientControllerTest < ActionController::TestCase
  def test_show_should_require_login
    # get :show
    xhr :get, :show
    assert_response :success
    assert_match /document\.location/, @response.body
  end

  def test_show_should_require_referral_id
    login_as(:quentin)
    # get :show
    xhr :get, :show
    assert_response :error
  end

  def test_show_should_succeed
    # login_as(:quentin)
    # # get :show, :create_referral_id=>referrals(:kildare_to_mccoy_new_referral)
    # xhr :get, :show, :create_referral_id=>referrals(:kildare_to_mccoy_new_referral)
    # assert_response :success
  end

  def test_create_should_succeed
    audit_count = AuditLog.count
    audit_message_count = ReferralMessage.count
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_new_referral)
    xhr :post, :create, :create_referral_id=> referral.id, :first_name=>"Bob", :date=>{ }
    assert_equal audit_count+1, AuditLog.count
    assert_equal audit_message_count, ReferralMessage.count
    #assert_response :success, "#{@response.body}"
  end

end
