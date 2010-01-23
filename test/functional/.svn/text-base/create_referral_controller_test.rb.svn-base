require File.dirname(__FILE__) + '/../test_helper'

class CreateReferralControllerTest < ActionController::TestCase
  def test_show_should_redirect_to_login
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_create_should_load_target_profile
    login_as(:quentin)
    post :create, :id => 'profile_aaron'
    assert_redirected_to :action=>"show"

    profile = assigns(:profile)
    assert_not_nil profile
    assert_equal profiles(:profile_quentin).id, profile.id

    workgroup = assigns(:workgroup)
    assert_not_nil workgroup
    assert_equal workgroups(:workgroup_mccoy).id, workgroup.id

    target_profile = assigns(:target_profile)
    assert_not_nil target_profile
    assert_equal profiles(:profile_aaron).id, target_profile.id

    target_workgroup = assigns(:target_workgroup)
    assert_not_nil target_workgroup
    assert_equal workgroups(:workgroup_welby).id, target_workgroup.id

    target_referral = assigns(:target_referral)
    assert_not_nil target_referral
    assert_not_nil target_referral.created_by_workgroup_id
    assert_equal workgroups(:workgroup_mccoy).id, target_referral.created_by_workgroup_id

    active_source = target_referral.active_source
    assert_not_nil active_source
    assert_equal users(:quentin).id, active_source.user_id

    active_target = target_referral.active_target
    assert_not_nil active_target
    assert_equal users(:aaron).id, active_target.user_id
  end

  def test_create_should_load_target_profile_request_referral
    login_as(:quentin)
    post :create, :id => 'profile_aaron', :type=>"request_referral"
    assert_redirected_to :action=>"show"

    profile = assigns(:profile)
    assert_not_nil profile
    assert_equal profiles(:profile_quentin).id, profile.id

    workgroup = assigns(:workgroup)
    assert_not_nil workgroup
    assert_equal workgroups(:workgroup_mccoy).id, workgroup.id

    target_profile = assigns(:target_profile)
    assert_not_nil target_profile
    assert_equal profiles(:profile_aaron).id, target_profile.id

    target_workgroup = assigns(:target_workgroup)
    assert_not_nil target_workgroup
    assert_equal workgroups(:workgroup_welby).id, target_workgroup.id

    target_referral = assigns(:target_referral)
    assert_not_nil target_referral
    assert_not_nil target_referral.created_by_workgroup_id
    assert_equal workgroups(:workgroup_mccoy).id, target_referral.created_by_workgroup_id
    assert_equal 1, target_referral.referral_targets.length


    active_source = target_referral.active_source
    assert_not_nil active_source
    assert_equal users(:aaron).id, active_source.user_id

    active_target = target_referral.active_target
    assert_not_nil active_target
    assert_equal users(:quentin).id, active_target.user_id
  end

  def test_show_should_create_referral_and_assign_consultant
    login_as(:quentin)
    get :show, :id => referrals(:kildare_to_mccoy_new_referral).id
    assert_response :success
    assert_template "show"

    target_profile = assigns(:target_profile)
    assert_not_nil target_profile

    target_referral = assigns(:target_referral)
    assert_not_nil target_referral
    assert_equal 1, target_referral.referral_targets.length
    assert_equal workgroups(:workgroup_mccoy).id, target_referral.referral_targets.first.workgroup.id
  end
end
