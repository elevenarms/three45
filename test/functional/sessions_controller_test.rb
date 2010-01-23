require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_login_and_redirect
    post :create, :login => 'quentin', :password => 'test'
    assert session[:user_id]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :create, :login => 'quentin', :password => 'bad password'
    assert_nil session[:user_id]
    assert_response :success
  end

  def test_login_should_create_audit_log_entry
    initial_count = AuditLog.count
    post :create, :login => 'quentin', :password => 'test'
    assert session[:user_id]
    assert_response :redirect
    assert_equal initial_count+1, AuditLog.count
  end

  def test_login_should_set_last_login
    assert_nil users(:quentin).last_login_at
    post :create, :login => 'quentin', :password => 'test'
    assert session[:user_id]
    assert_response :redirect
    assert_not_nil User.find_by_login("quentin").last_login_at
  end

  def test_should_logout
    login_as :quentin
    get :destroy
    assert_nil session[:user_id]
    assert_response :redirect
  end

  def test_logout_should_create_audit_log_entry
    initial_count = AuditLog.count
    login_as :quentin
    get :destroy
    assert_nil session[:user_id]
    assert_response :redirect
    assert_equal initial_count+1, AuditLog.count
  end

  def test_should_remember_me
    post :create, :login => 'quentin', :password => 'test', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    post :create, :login => 'quentin', :password => 'test', :remember_me => "0"
    assert_nil @response.cookies["auth_token"]
  end

  def test_should_delete_token_on_logout
    login_as :quentin
    get :destroy
    assert_equal @response.cookies["auth_token"], []
  end

  def test_should_login_with_cookie
    users(:quentin).remember_me
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    users(:quentin).remember_me
    users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    users(:quentin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_load_subdomain_instance_var
    @request.host = "mccoy.three45.com"
    get :new

    assert_equal 'workgroup_mccoy', assigns["workgroup"].id

    @request.host = "kildare.three45.com"
    get :new

    assert_equal 'workgroup_kildare', assigns["workgroup"].id

    @request.host = "welby.three45.com"
    get :new

    assert_equal 'workgroup_welby', assigns["workgroup"].id

    @request.host = "three45.com"
    get :new

    assert_nil assigns["workgroup"]

    @request.host = "www.three45.com"
    get :new

    assert_nil assigns["workgroup"]
  end

  def test_should_validate_workgroup
    post :create, :login => 'quentin', :password => 'test'
    @request.host = "mccoy.three45.com"
    get :new

    assert_response :success

    @request.host = "welby.three45.com"
    get :new

    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_should_redirect_to_reset_password_on_first_login
    post :create, :login => 'quentin', :password => 'test'
    assert session[:user_id]
    assert_response :redirect
    assert_redirected_to reset_password_user_path(users(:quentin))
  end

  def test_should_redirect_to_dashboard_after_first_login
    quentin = users(:quentin)
    quentin.last_login_at = Time.now
    quentin.save!

    post :create, :login => 'quentin', :password => 'test'
    assert session[:user_id]
    assert_response :redirect
    assert_redirected_to dashboard_index_url
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end

    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
