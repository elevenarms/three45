require File.dirname(__FILE__) + '/../test_helper'

class MessagesControllerTest < ActionController::TestCase
  def test_index_should_require_login
    get :index
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_index_should_require_referral_id
    login_as(:quentin)
    get :index
    assert_response :error
  end

  def test_new_should_require_login
    get :new
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_new_should_require_referral_id
    login_as(:quentin)
    get :index
    assert_response :error
  end

  def test_xhr_new_should_succeed
    referral = referrals(:mccoy_to_kildare_3)
    login_as(:quentin)
    xhr :get, :new, :referral_id=> referral.id
    assert_response :success
    assert_template "new"
  end

  def test_xhr_create_general_note_should_succeed
    referral = referrals(:mccoy_to_kildare_3)
    login_as(:quentin)
    xhr :post, :create, :referral_id=> referral.id, :message=>{ :referral_message_type_id=>referral_message_types(:general_note).id, :subject=>"Some subject", :message_text=>"Some message"}
    message = assigns(:message)
    assert_equal 0, message.errors.length, "Errors found: #{message.errors.full_messages}"
    assert_nil flash[:partial]
    assert_response :success
    assert_template "_create_success"
  end

  def test_xhr_create_general_note_should_fail_missing_field
    referral = referrals(:mccoy_to_kildare_3)
    login_as(:quentin)
    xhr :post, :create, :referral_id=> referral.id, :message=>{ :subject=>"Some subject", :message_text=>"Some message"}
    assert_response :error
    assert_template "new"
  end

  def test_xhr_create_general_note_should_fail_referral_not_in_progress
    referral = referrals(:mccoy_to_kildare_1)
    login_as(:quentin)
    xhr :post, :create, :referral_id=> referral.id, :message=>{ :referral_message_type_id=>referral_message_types(:general_note).id, :subject=>"Some subject", :message_text=>"Some message"}
    assert_response :error
    assert_template "new"
  end

  def test_xhr_create_request_should_succeed
    referral = referrals(:mccoy_to_kildare_3)
    login_as(:quentin)
    xhr :post, :create, :referral_id=> referral.id, :message=>{ :referral_message_type_id=>referral_message_types(:request).id, :subject=>"Some subject", :message_text=>"Some message", :response_required_by=>10.days.from_now.to_s(:db)}
    message = assigns(:message)
    assert_equal 0, message.errors.length, "Errors found: #{message.errors.full_messages}"
    assert_nil flash[:partial]
    assert_response :success
    assert_template "_create_success"
  end

  def test_xhr_create_request_should_fail_missing_field
    referral = referrals(:mccoy_to_kildare_3)
    login_as(:quentin)
    xhr :post, :create, :referral_id=> referral.id, :message=>{ :referral_message_type_id=>referral_message_types(:request).id, :subject=>"Some subject", :message_text=>"Some message"}
    assert_response :error
    assert_template "new"
  end

  def test_xhr_create_request_should_succeed_with_file_ids
    referral = referrals(:mccoy_to_kildare_3)
    login_as(:quentin)

    # create 2 files for this test
    file1 = ReferralFile.create!({ :referral_id=>referral.id, :mime_type_id=>mime_types(:jpg).id, :referral_file_type_id=>referral_file_types(:lab_report).id, :size=>1, :content_type=>"foo/bar", :filename=>"foobar.jpg"})
    file2 = ReferralFile.create!({ :referral_id=>referral.id, :mime_type_id=>mime_types(:jpg).id, :referral_file_type_id=>referral_file_types(:lab_report).id, :size=>1, :content_type=>"foo/bar", :filename=>"foobar.jpg"})
    assert_nil file1.referral_message_id
    assert_nil file2.referral_message_id

    audit_count = AuditLog.count
    xhr :post, :create, :referral_id=> referral.id, :message=>{ :referral_message_type_id=>referral_message_types(:request).id, :subject=>"Some subject", :message_text=>"Some message", :response_required_by=>10.days.from_now.to_s(:db)}, :file_ids=>[file1.id, file2.id]
    message = assigns(:message)
    assert_equal 0, message.errors.length, "Errors found: #{message.errors.full_messages}"
    assert_nil flash[:partial]
    assert_response :success
    assert_template "_create_success"
    file1.reload
    file2.reload
    assert_not_nil file1.referral_message_id
    assert_not_nil file2.referral_message_id
    assert_equal message.id, file1.referral_message_id
    assert_equal message.id, file2.referral_message_id
    assert_equal audit_count+3, AuditLog.count
  end

  def test_xhr_create_request_should_succeed_with_fax_ids
    referral = referrals(:mccoy_to_kildare_3)
    login_as(:quentin)

    # create 2 files for this test
    fax1 = ReferralFax.create!({ :referral_id=>referral.id, :referral_fax_state_id=>referral_fax_states(:waiting).id})
    fax2 = ReferralFax.create!({ :referral_id=>referral.id, :referral_fax_state_id=>referral_fax_states(:waiting).id})
    assert_nil fax1.referral_message_id
    assert_nil fax2.referral_message_id

    audit_count = AuditLog.count
    xhr :post, :create, :referral_id=> referral.id, :message=>{ :referral_message_type_id=>referral_message_types(:request).id, :subject=>"Some subject", :message_text=>"Some message", :response_required_by=>10.days.from_now.to_s(:db)}, :fax_ids=>[fax1.id, fax2.id]
    message = assigns(:message)
    assert_equal 0, message.errors.length, "Errors found: #{message.errors.full_messages}"
    assert_nil flash[:partial]
    assert_response :success
    assert_template "_create_success"
    fax1.reload
    fax2.reload
    assert_not_nil fax1.referral_message_id
    assert_not_nil fax2.referral_message_id
    assert_equal message.id, fax1.referral_message_id
    assert_equal message.id, fax2.referral_message_id
    assert_equal audit_count+3, AuditLog.count
  end

  def test_xhr_show_should_succeed
    referral = referrals(:mccoy_to_kildare_3)
    login_as(:quentin)
    xhr :post, :show, :referral_id=> referral.id, :id=> referral_messages(:mccoy_to_kildare_3_general_1).id
    message = assigns(:target_message)
    assert_response :success
    assert_template "show"
  end

  def test_xhr_new_reply_should_succeed
    referral = referrals(:mccoy_to_kildare_3)
    target_message = referral_messages(:mccoy_to_kildare_3_request_2)
    login_as(:quentin)
    xhr :get, :new_reply, :referral_id=> referral.id, :id=> target_message.id
    assert_response :success
    assert_template "new_reply"
  end

  def test_xhr_create_reply_general_note_should_succeed
    referral = referrals(:mccoy_to_kildare_3)
    target_message = referral_messages(:mccoy_to_kildare_3_request_2)
    assert target_message.status_waiting_response?
    login_as(:quentin)
    xhr :post, :create_reply, :referral_id=> referral.id, :id=> target_message.id, :message=>{ :message_text=>"Some message"}
    message = assigns(:message)
    assert_equal 0, message.errors.length, "Errors found: #{message.errors.full_messages}"
    assert_nil flash[:partial]
    assert_response :success
    assert_template "_reply_success"
    target_message.reload
    assert target_message.status_complete?
  end

  def test_xhr_show_note_should_succeed_and_mark_as_read
    referral = referrals(:mccoy_to_kildare_3)
    message = referral_messages(:mccoy_to_kildare_3_general_1)
    login_as(:quentin)
    xhr :post, :show, :referral_id=> referral.id, :id=> message.id
    target_message = assigns(:target_message)
    message.reload
    assert message.status_complete?
    assert_not_nil message.viewed_at
    assert_nil flash[:partial]
    assert_response :success
    assert_template "show"
  end

  def test_xhr_show_request_should_succeed_and_mark_as_read
    referral = referrals(:mccoy_to_kildare_3)
    message = referral_messages(:mccoy_to_kildare_3_request_2)
    reply_message = referral_messages(:mccoy_to_kildare_3_request_2_reply)
    assert message.status_waiting_response?
    login_as(:quentin)
    xhr :post, :show, :referral_id=> referral.id, :id=> message.id
    target_message = assigns(:target_message)
    message.reload
    assert message.status_waiting_response?
    assert_not_nil message.viewed_at
    reply_message.reload
    assert_not_nil message.viewed_at
    # if there is a reply message, that should be marked as read also
    assert_not_nil reply_message.viewed_at
    assert_nil flash[:partial]
    assert_response :success
    assert_template "show"
  end

  def test_xhr_destroy_should_succeed
    referral = referrals(:mccoy_to_kildare_3)
    message = referral_messages(:mccoy_to_kildare_3_general_1)
    login_as(:quentin)
    xhr :post, :destroy, :referral_id=> referral.id, :id=> message.id
    target_message = assigns(:target_message)
    assert_equal 0, target_message.errors.length, "Errors found: #{target_message.errors.full_messages}"
    message.reload
    assert message.status_void?
    assert_nil flash[:partial]
    assert_response :success
    assert_template "_destroy_success"
  end

  def test_xhr_destroy_without_login_should_javascript_redirect
    referral = referrals(:mccoy_to_kildare_3)
    message = referral_messages(:mccoy_to_kildare_3_general_1)
    xhr :post, :destroy, :referral_id=> referral.id, :id=> message.id
    assert_response :success
    # puts "Got: #{@response.body}"
  end

  def test_print_should_require_login
    get :print
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_print_should_require_id
    login_as(:quentin)
    get :print
    assert_response :error
  end

  def test_print_should_succeed
    login_as(:quentin)
    referral = referrals(:mccoy_to_kildare_3)
    message = referral_messages(:mccoy_to_kildare_3_general_1)
    get :print, :id => message.id, :referral_id => referral.id
    assert_response :success, "#{@response.body}"
    assert_template "print"
  end

  def test_new_info_should_require_login
    get :new_info
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_new_info_should_require_id
    login_as(:quentin)
    get :new_info
    assert_response :error
  end

  def test_new_info_should_succeed
    login_as(:quentin)
    referral = referrals(:mccoy_to_kildare_3)
    get :new_info, :id => referral.id
    assert_response :success, "#{@response.body}"
    assert_template "new_info"
  end

  def test_action_requested_should_require_login
    get :action_requested
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_action_requested_should_require_id
    login_as(:quentin)
    get :action_requested
    assert_response :error
  end

  def test_action_requested_should_succeed
    login_as(:quentin)
    referral = referrals(:mccoy_to_kildare_3)
    get :action_requested, :id => referral.id
    assert_response :success, "#{@response.body}"
    assert_template "action_requested"
  end
end
