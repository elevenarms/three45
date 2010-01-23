require File.dirname(__FILE__) + '/../test_helper'

class FilesControllerTest < ActionController::TestCase
  def test_no_login_should_redirect_to_login
    get :index
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_index_should_list_files
    # login_as(:quentin)
    # get :index, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id
    #
    # files = assigns(:target_referral).referral_files
    #
    # assert_response :success
    # assert_template "_index"
    #
    # assert_not_nil files
  end

  def test_index_should_list_files_in_edit_mode
    login_as(:quentin)
    get :index, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id, :edit_mode => true

    files = assigns(:target_referral).referral_files

    assert_response :success
    assert_template "_edit_index"

    assert_not_nil files
  end

  def test_nested_routing
    assert_routing 'create_referral/kildare_to_mccoy_new_referral/files', {:controller=>'files',:action=>'index',:create_referral_id=>'kildare_to_mccoy_new_referral'}
    assert_routing 'create_referral/kildare_to_mccoy_new_referral/files/new', {:controller=>'files',:action=>'new',:create_referral_id=>'kildare_to_mccoy_new_referral'}
    assert_routing 'create_referral/kildare_to_mccoy_new_referral/files/test_referral_file_one/edit', {:controller=>'files',:action=>'edit',:create_referral_id=>'kildare_to_mccoy_new_referral',:id=>'test_referral_file_one'}
  end

  def test_new_returns_unfilled_form
    login_as(:quentin)
    get :new, :create_referral_id => referrals(:kildare_to_mccoy_new_referral).id

    assert_response :success
    assert_template "_edit_new_file_detail"
  end

  def test_download_requires_login
    get :download
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_download_requires_id
    login_as(:quentin)
    get :download
    assert_response :error
  end

  def test_download_fails_missing_file
    login_as(:quentin)
    get :download, :id=>referral_files(:file_missing).id
    assert_response :error
  end

  def test_audit_log_entry_created_when_create_succeeds_new_referral
    audit_count = AuditLog.count
    login_as(:quentin)
    referral = referrals(:mccoy_to_kildare_1)
    # passing a nil for uploaded_data will cause it to fail
    fdata = fixture_file_upload('files/fax.tiff', 'image/tiff')
    post :create, :create_referral_id=> referral.id, :referral_file=>{ :uploaded_data => fdata }, :file_type_id=>referral_file_types(:lab_report).id, :html => { :multipart => true }
    assert_response :success
    assert_nil flash[:partial]
    assert_equal audit_count+1, AuditLog.count
    log = AuditLog.find(:first, :order=>"created_at DESC")
    assert_equal "file_uploaded", log.audit_category_id
    assert_equal "initial", log.long_description
  end

  def test_audit_log_entry_created_when_create_succeeds_in_progress
    audit_count = AuditLog.count
    login_as(:quentin)
    referral = referrals(:mccoy_to_kildare_3)
    # passing a nil for uploaded_data will cause it to fail
    fdata = fixture_file_upload('files/fax.tiff', 'image/tiff')
    post :create, :create_referral_id=> referral.id, :referral_file=>{ :uploaded_data => fdata }, :file_type_id=>referral_file_types(:lab_report).id, :html => { :multipart => true }
    assert_nil flash[:partial]
    assert_response :success
    assert_equal audit_count+1, AuditLog.count
    log = AuditLog.find(:first, :order=>"created_at DESC")
    assert_equal "file_uploaded", log.audit_category_id
    assert_equal "edit", log.long_description
  end

  def test_audit_log_entry_created_when_create_fails
    audit_count = AuditLog.count
    login_as(:quentin)
    referral = referrals(:mccoy_to_kildare_1)
    # passing a nil for uploaded_data will cause it to fail
    post :create, :create_referral_id=> referral.id, :referral_file=>{ :uploaded_data => nil }, :file_type_id=>referral_file_types(:lab_report).id, :html => { :multipart => true }
    assert_response :success
    assert_not_nil flash[:partial]
    assert_equal audit_count+1, AuditLog.count
    log = AuditLog.find(:first, :order=>"created_at DESC")
    assert_equal "file_upload_failed", log.audit_category_id
  end

end

