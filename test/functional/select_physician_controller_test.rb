require File.dirname(__FILE__) + '/../test_helper'

class SelectPhysicianControllerTest < ActionController::TestCase

  def test_show_referrer_physician_with_physician_user
    login_as(:quentin_admin)
    referral = referrals(:mccoy_to_kildare_2)
    get :show, :id => referral.id
    assert_response :success, "#{@response.body}"
    assert_template "_show"

    target_referral = assigns(:target_referral)
    assert_not_nil target_referral

    assert_match /Quentin A. Smith/, @response.body
  end

  def test_edit_referrer_physician
    login_as(:quentin_admin)
    referral = referrals(:mccoy_to_kildare_2)
    get :edit, :id => referral.id
    assert_response :success, "#{@response.body}"
    assert_template "_edit"

    target_referral = assigns(:target_referral)
    assert_not_nil target_referral

    assert_match /<strong>Referring Physician:<\/strong>/, @response.body
    assert_match /Quentin A. Smith<\/option>/, @response.body
  end

  def test_update_referrer_physician
    login_as(:quentin_admin)
    referral = referrals(:mccoy_to_kildare_2)
    quentin_jr = users(:quentin_jr)
    xhr :post, :update, :id => referral.id, :referring_physician=>quentin_jr.id
    assert_response :success, "#{@response.body}"
    assert_template "_next_step"

    target_referral = assigns(:target_referral)
    assert_not_nil target_referral

    assert_equal quentin_jr.id, target_referral.active_source.user_id
  end


  def test_update_referrer_physician_request_referral
    login_as(:quentin_admin)
    referral = referrals(:mccoy_to_kildare_2)
    # force the created_by_workgroup_id to something different to trigger the request referral logic
    referral.created_by_workgroup_id = workgroups(:workgroup_kildare).id
    referral.save!

    quentin_jr = users(:quentin_jr)
    xhr :post, :update, :id => referral.id, :referring_physician=>quentin_jr.id
    assert_response :success, "#{@response.body}"
    assert_template "_next_step"

    target_referral = assigns(:target_referral)
    assert_not_nil target_referral

    assert_equal users(:quentin).id, target_referral.active_source.user_id
    assert_equal quentin_jr.id, target_referral.active_target.user_id
  end
end
