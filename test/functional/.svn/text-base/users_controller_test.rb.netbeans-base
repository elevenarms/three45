require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_reset_password_should_display
    login_as(:quentin)
    get :reset_password
    assert_response :success
    assert_template "reset_password"
  end

  def test_change_password_should_require_a_password_parameter
    login_as(:quentin)
    post :change_password
    assert_response :success
    assert_template "reset_password"
  end

  def test_change_password_should_require_matching_passwords
    login_as(:quentin)
    post :change_password, :user=>{ :password=>"new123", :password_confirmation=>"new1234"}
    assert_response :success
    assert_template "reset_password"
  end

  def test_change_password_should_update_password
    password = users(:quentin).crypted_password
    login_as(:quentin)
    post :change_password, :user=>{ :password=>"new123", :password_confirmation=>"new123"}
    assert_redirected_to dashboard_index_url
    users(:quentin).reload
    assert users(:quentin).crypted_password != password
  end

  def test_reset_password_on_behalf_should_display
    login_as(:quentin)
    aaron = users(:aaron)
    get :reset_password_on_behalf, :id=>aaron.id
    assert_response :success
    assert_template "reset_password_on_behalf"
  end

  def test_change_password_on_behalf_should_require_a_password_parameter
    login_as(:quentin)
    aaron = users(:aaron)
    post :change_password_on_behalf, :id=>aaron.id
    assert_response :success
    assert_template "reset_password_on_behalf"
  end

  def test_change_password_on_behalf_should_require_matching_passwords
    login_as(:quentin)
    aaron = users(:aaron)
    post :change_password_on_behalf, :id=>aaron.id, :user=>{ :password=>"new123", :password_confirmation=>"new1234"}
    assert_response :success
    assert_template "reset_password_on_behalf"
  end

  def test_change_password_on_behalf_should_update_password
    password = users(:aaron).crypted_password
    aaron = users(:aaron)
    login_as(:quentin)
    post :change_password_on_behalf, :id=>aaron.id, :user=>{ :password=>"new123", :password_confirmation=>"new123"}
    assert_redirected_to dashboard_index_url
    users(:aaron).reload
    assert users(:aaron).crypted_password != password
  end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
