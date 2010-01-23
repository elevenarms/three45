require File.dirname(__FILE__) + '/../test_helper'

class ReferralsControllerTest < ActionController::TestCase
  def test_withdraw_should_require_login
    get :withdraw
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_withdraw_should_require_referral_id
    login_as(:quentin)
    get :withdraw
    assert_response :error
  end

  def test_withdraw_success
    referral = referrals(:mccoy_to_stretch_6)
    user = users(:quentin)
    workgroup = workgroups(:workgroup_mccoy)
    engine = WorkflowEngine.new(referral, user, workgroup)
    # force the referral into the proper state
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    login_as(:quentin)
    get :withdraw, :id => referral.id
    assert_redirected_to referral_path(referral)
    assert_nil flash[:error]
  end

  def test_decline_should_require_login
    get :decline
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_decline_should_require_referral_id
    login_as(:quentin)
    get :decline
    assert_response :error
  end

  def test_decline_success
    referral = referrals(:mccoy_to_stretch_6)
    user = users(:stretch_brewster)
    workgroup = workgroups(:workgroup_phys_therapy)
    engine = WorkflowEngine.new(referral, user, workgroup)
    # force the referral into the proper state
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    login_as(:stretch_brewster)
    get :decline, :id => referral.id
    assert_redirected_to referral_path(referral)
    assert_nil flash[:error]
  end

  def test_accept_should_require_login
    get :accept
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_accept_should_require_referral_id
    login_as(:quentin)
    get :accept
    assert_response :error
  end

  def test_accept_success_with_apw_target
    referral = referrals(:mccoy_to_stretch_6)
    user = users(:stretch_brewster)
    workgroup = workgroups(:workgroup_phys_therapy)
    engine = WorkflowEngine.new(referral, user, workgroup)
    # force the referral into the proper state
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    login_as(:stretch_brewster)
    get :accept, :id => referral.id
    assert_redirected_to referral_path(referral)
    assert_nil flash[:error]
  end

  def test_accept_success_with_select_physician
    referral = referrals(:kildare_to_mccoy_new_referral)
    user = users(:quentin)
    workgroup = workgroups(:workgroup_mccoy)
    engine = WorkflowEngine.new(referral, user, workgroup)
    # force the referral into the proper state
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral
    referral.reload

    login_as(:stretch_brewster)
    get :accept, :id => referral.id, :physician_user => user.id
    assert_redirected_to referral_path(referral)
    assert_nil flash[:error]
    assert_equal user.id, referral.active_target.user.id
  end

  def test_accept_fails_with_no_selected_physician
    referral = referrals(:kildare_to_mccoy_new_referral)
    user = users(:quentin)
    workgroup = workgroups(:workgroup_mccoy)
    engine = WorkflowEngine.new(referral, user, workgroup)
    # force the referral into the proper state
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    login_as(:stretch_brewster)
    get :accept, :id => referral.id
    assert_redirected_to referral_path(referral)
    assert_not_nil flash[:error]
  end

  def test_new_info_requires_login
    get :new_info
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_new_info_displays_unread_messages
    login_as(:dr_gillespie)
    referral = referrals(:mccoy_to_kildare_3)
    get :new_info, :id=>referral.id
    assert_response :success
    assert_template "new_info"
    new_messages = assigns(:new_messages)
    assert_not_nil new_messages
    assert_equal 1, new_messages.length
  end

  def test_new_info_marks_as_read
    login_as(:dr_gillespie)
    referral = referrals(:mccoy_to_kildare_3)
    get :new_info, :id=>referral.id
    assert_response :success
    assert_template "new_info"
    new_messages = assigns(:new_messages)
    assert_not_nil new_messages
    assert_equal 1, new_messages.length
    new_messages.first.reload
    assert_not_nil new_messages.first.viewed_at
  end

  def test_all_info_requires_login
    get :all_info
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_all_info_succeeds
    login_as(:dr_gillespie)
    referral = referrals(:mccoy_to_kildare_3)
    get :all_info, :id=>referral.id
    assert_response :success
    assert_template "all_info"
  end

  def test_show_requires_login
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_show_requires_id
    login_as(:dr_gillespie)
    get :show
    assert_response :error
  end

  def test_show_displays_accept_decline_box_for_target
    referral = referrals(:mccoy_to_kildare_2)
    # force it into the provisional state
    referral.referral_state_id = 'provisional'
    referral.save!

    # now let's look at it as Dr. Gillespie, the target/consultant
    @request.host = "kildare.three45.com"
    login_as(:dr_gillespie)
    get :show, :id=>referral.id
    assert_response :success
    assert_template "show"
    assert assigns(:accept_decline_required)
    assert assigns(:accept_decline_required) == true
    assert !assigns(:withdraw_allowed)
    assert assigns(:edit_disabled)
    assert assigns(:edit_disabled) == true
    assert_match /accept\ or\ decline/, @response.body
    assert_match /<option\ value=\'dr_gillespie\'/, @response.body
  end

  def test_show_displays_withdraw_box_for_source
    referral = referrals(:mccoy_to_kildare_2)
    # force it into the provisional state
    referral.referral_state_id = 'provisional'
    referral.save!

    # now let's look at it as Quentin, the source/referring physician
    login_as(:quentin)
    get :show, :id=>referral.id
    assert_response :success
    assert_template "show"
    assert !assigns(:accept_decline_required)
    assert assigns(:withdraw_allowed)
    assert assigns(:withdraw_allowed) == true
    assert assigns(:edit_disabled)
    assert assigns(:edit_disabled) == true
    assert_match /may\ withdraw/, @response.body
  end

  def test_select_consultant_requires_login
    get :select_consultant
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_select_consultant_requires_id
    login_as(:dr_gillespie)
    get :select_consultant
    assert_response :error
  end

  def test_select_consultant_succeeds
    login_as(:dr_gillespie)
    referral = referrals(:mccoy_to_kildare_3)
    get :select_consultant, :id=> referral.id
    assert_response :success
  end

  def test_change_consultant_requires_login
    post :change_consultant
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_change_consultant_requires_id
    login_as(:dr_gillespie)
    post :change_consultant
    assert_response :error
  end


  def test_change_consultant_requires_valid_physician_user_value
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_4)
    user = users(:quentin_jr)
    post :change_consultant, :id=> referral.id, :physician_user=> ""
    assert_redirected_to referral_url(referral)
    referral.reload
    assert_equal users(:quentin).id, referral.active_target.user_id
  end

  def test_change_consultant_requires_referral_in_progress
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_new_referral)
    user = users(:quentin_jr)
    post :change_consultant, :id=> referral.id, :physician_user=> user.id
    assert_redirected_to referral_url(referral)
    assert_not_nil flash[:error]
    referral.reload
    assert_nil referral.active_target.user_id
  end

  def test_change_consultant_succeeds
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_4)
    user = users(:quentin_jr)
    post :change_consultant, :id=> referral.id, :physician_user => user.id
    assert_redirected_to referral_url(referral)
    assert_not_nil flash[:notice]
    referral.active_target.reload
    assert_equal user.id, referral.active_target.user_id
  end

  def test_closed_requires_referral_in_progress
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_new_referral)
    user = users(:quentin_jr)
    post :close, :id=> referral.id
    assert_redirected_to referral_url(referral)
    assert_not_nil flash[:error]
    referral.reload
    assert referral.status_new?
  end

  def test_closed_succeeds
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_4)
    user = users(:quentin_jr)
    post :close, :id=> referral.id
    assert_redirected_to referral_url(referral)
    assert_not_nil flash[:notice]
    referral.reload
    assert referral.status_closed?
  end

  def test_reopen_requires_referral_in_progress
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_new_referral)
    user = users(:quentin_jr)
    post :close, :id=> referral.id
    assert_redirected_to referral_url(referral)
    assert_not_nil flash[:error]
    referral.reload
    assert referral.status_new?
  end

  def test_reopen_succeeds
    login_as(:quentin)
    referral = referrals(:kildare_to_mccoy_4)
    user = users(:quentin_jr)
    post :close, :id=> referral.id
    post :reopen, :id=> referral.id
    assert_redirected_to referral_url(referral)
    assert_not_nil flash[:notice]
    referral.reload
    assert referral.status_in_progress?
  end
end
