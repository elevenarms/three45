require File.dirname(__FILE__) + '/../test_helper'

class InsuranceControllerTest < ActionController::TestCase
  def test_index_should_require_login
    # get :index
    xhr :get, :index
    assert_response :success
    assert_match /document\.location/, @response.body
  end

  def test_index_should_require_referral_id
    login_as(:quentin)
    # get :index
    xhr :get, :index
    assert_response :error
  end

  def test_new_should_succeed
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_new_referral)
    xhr :get, :new, :id=> referral.id
    assert_response :success
  end

  def test_create_should_succeed
    audit_count = AuditLog.count
    audit_message_count = ReferralMessage.count
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_new_referral)
    xhr :post, :create, :create_referral_id=> referral.id, :provider=> tags(:tag_carrier_blue_cross).id, :plan=>tags(:tag_carrier_blue_cross_1).id, :details=>"Details go here"
    assert_equal audit_count+1, AuditLog.count
    assert_equal audit_message_count, ReferralMessage.count
  end

  def test_create_should_succeed_with_additional_details
    audit_count = AuditLog.count
    audit_message_count = ReferralMessage.count
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_new_referral)
    xhr :post, :create, :create_referral_id=> referral.id, :provider=> tags(:tag_carrier_blue_cross).id, :plan=>tags(:tag_carrier_blue_cross_1).id, :details=>"Details go here", :authorization => "Auth", :number_of_visits => "22", :patient_carrier_plan=> { :expiration_date => "2008-01-01" }
    assert_equal audit_count+1, AuditLog.count
    assert_equal audit_message_count, ReferralMessage.count
    referral = assigns(:engine).referral
    insurance = referral.referral_insurance_plans.first
    assert_equal "Auth", insurance.authorization
    assert_equal 22, insurance.number_of_visits
    assert_not_nil insurance.expiration_date
    assert_equal "2008-01-01", insurance.expiration_date.strftime("%Y-%m-%d")
  end

  def test_update_should_succeed
    audit_count = AuditLog.count
    audit_message_count = ReferralMessage.count
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_new_referral)
    xhr :post, :update, :create_referral_id=> referral.id, :patient_carrier_plan_id=>referral_insurance_plans(:welby_to_stretch_plan).id, :provider=> tags(:tag_carrier_blue_cross).id, :plan=>tags(:tag_carrier_blue_cross_1).id, :details=>"Details go here", :authorization => "Auth", :number_of_visits => "22", :patient_carrier_plan=> { :expiration_date => "2008-01-01" }
    assert_equal audit_count+1, AuditLog.count
    assert_equal audit_message_count, ReferralMessage.count
    insurance = referral_insurance_plans(:welby_to_stretch_plan)
    insurance.reload
    assert_equal "Auth", insurance.authorization
    assert_equal 22, insurance.number_of_visits
    assert_not_nil insurance.expiration_date
    assert_equal "2008-01-01", insurance.expiration_date.strftime("%Y-%m-%d")
  end

  def test_update_should_succeed_in_progress
    audit_count = AuditLog.count
    audit_message_count = ReferralMessage.count
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_4)
    insurance = ReferralInsurancePlan.create!({ :referral_id=> referral.id, :insurance_carrier_tag_id => 'tag_carrier_blue_cross', :insurance_carrier_plan_tag_id => 'tag_carrier_blue_cross_1' })
    xhr :post, :update, :create_referral_id=> referral.id, :patient_carrier_plan_id=>insurance.id, :provider=> tags(:tag_carrier_blue_cross).id, :plan=>tags(:tag_carrier_blue_cross_1).id, :details=>"Details go here", :authorization => "Auth", :number_of_visits => "22", :patient_carrier_plan=> { :expiration_date => "2008-01-01" }
    assert_equal audit_count+1, AuditLog.count
    assert_equal audit_message_count+1, ReferralMessage.count
    insurance.reload
    assert_equal "Auth", insurance.authorization
    assert_equal 22, insurance.number_of_visits
    assert_not_nil insurance.expiration_date
    assert_equal "2008-01-01", insurance.expiration_date.strftime("%Y-%m-%d")
  end
end
