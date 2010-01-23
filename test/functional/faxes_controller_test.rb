require File.dirname(__FILE__) + '/../test_helper'

class FaxesControllerTest < ActionController::TestCase
  def test_no_login_should_redirect_to_login
    get :index
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_index_should_list_faxes
    login_as(:quentin)
    get :index, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id

    faxes = assigns(:target_referral).referral_faxes

    assert_response :success
    # assert_template "_index"

    assert_not_nil faxes
    assert_equal 2, faxes.length
  end

  def test_index_should_list_faxes_in_edit_mode
    login_as(:quentin)
    get :index, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id, :edit_mode => true

    faxes = assigns(:target_referral).referral_faxes

    assert_response :success
    assert_template "_edit_index"

    assert_not_nil faxes
    assert_equal 2, faxes.length
  end

  def test_nested_routing
    assert_routing 'create_referral/kildare_to_mccoy_new_referral/faxes', {:controller=>'faxes',:action=>'index',:create_referral_id=>'kildare_to_mccoy_new_referral'}
    assert_routing 'create_referral/kildare_to_mccoy_new_referral/faxes/new', {:controller=>'faxes',:action=>'new',:create_referral_id=>'kildare_to_mccoy_new_referral'}
    assert_routing 'create_referral/kildare_to_mccoy_new_referral/faxes/test_referral_fax_one/edit', {:controller=>'faxes',:action=>'edit',:create_referral_id=>'kildare_to_mccoy_new_referral',:id=>'test_referral_fax_one'}
  end

  def test_new_returns_unfilled_form
    login_as(:quentin)
    get :new, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id

    assert_response :success
    assert_template "_edit_new_fax_detail"
  end

  def test_create_new_fax
    login_as(:quentin)
    get :create, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id

    faxes = assigns(:target_referral).referral_faxes

    assert_response :success
    assert_template "_edit_index"

    assert_not_nil faxes
    assert_equal 3, faxes.length
  end

  def test_audit_log_entry_created_when_create_succeeds_new_referral
    audit_count = AuditLog.count
    login_as(:quentin)
    referral = referrals(:mccoy_to_kildare_1)
    post :create, :create_referral_id=> referral.id, :page_count=>"1"
    assert_response :success
    assert_nil flash[:partial]
    assert_equal audit_count+1, AuditLog.count
    log = AuditLog.find(:first, :order=>"created_at DESC")
    assert_equal "fax_created", log.audit_category_id
    assert_equal "initial", log.long_description
  end

  def test_audit_log_entry_created_when_create_succeeds_in_progress
    audit_count = AuditLog.count
    login_as(:quentin)
    referral = referrals(:mccoy_to_kildare_3)
    post :create, :create_referral_id=> referral.id, :page_count=>"1"
    assert_response :success
    assert_nil flash[:partial]
    assert_equal audit_count+1, AuditLog.count
    log = AuditLog.find(:first, :order=>"created_at DESC")
    assert_equal "fax_created", log.audit_category_id
    assert_equal "edit", log.long_description
  end

  def test_edit_returns_prefilled_form
    login_as(:quentin)
    get :edit, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id, :id => referral_faxes(:test_referral_fax_one).id

    assert_response :success
    assert_template "_edit_fax_detail"
  end

  def test_update_existing_fax
    login_as(:quentin)
    get :update, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id, :id => referral_faxes(:test_referral_fax_one).id

    assert_response :success
    assert_template "_fax_detail"
  end

  def test_delete_existing_fax
    login_as(:quentin)
    get :destroy, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id, :id => referral_faxes(:test_referral_fax_one).id

    faxes = assigns(:target_referral).referral_faxes

    assert_response :success
    assert_template "_edit_index"

    assert_not_nil faxes
    assert_equal 1, faxes.length
  end


  def test_update_status_success
    login_as(:quentin)
    fax = referral_faxes(:test_referral_fax_one)
    count = ReferralFax.count
    assert_equal referral_fax_states(:waiting).id, fax.referral_fax_state_id
    post :update_status, :id=> referral_faxes(:test_referral_fax_one).id, :new_fax_state_id=>referral_fax_states(:received_successfully).id, :error_details=>"Testing error_details"
    assert_response :success, "#{@response.body}"
    target_fax = assigns(:target_fax)
    assert_not_nil target_fax
    assert count, ReferralFax.count
    fax.reload
    assert_equal referral_fax_states(:received_successfully).id, fax.referral_fax_state_id
    assert_equal "Testing error_details", fax.error_details
  end

end
