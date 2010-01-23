require File.dirname(__FILE__) + '/../test_helper'

class UnsWelcomeControllerTest < ActionController::TestCase
  def test_show_should_redirect_to_standard_login_if_subscriber
    workgroup = workgroups(:workgroup_mccoy)
    @request.host = "#{workgroup.subdomain}.local.host"
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_show_should_redirect_to_login_if_uns
    workgroup = workgroups(:workgroup_nonsub)
    @request.host = "#{workgroup.subdomain}.local.host"
    get :show
    assert_redirected_to :action=>"new"
  end

  def test_show_should_error_if_no_workgroup
    @request.host = "fake.local.host"
    get :show
    assert_response :error
  end

  def test_new
    workgroup = workgroups(:workgroup_nonsub)
    @request.host = "#{workgroup.subdomain}.local.host"

    get :new
    assert_response :success
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:referral)
    assert_template "new"
  end

  def test_create_agree_checkbox_not_checked_fails_with_returning_user
    workgroup = workgroups(:workgroup_nonsub)
    @request.host = "#{workgroup.subdomain}.local.host"
    user = users(:uns)
    user.last_login_at = Time.now
    user.save!

    post :create, :login=> user.login, :password=> user.password
    assert_response :success
    assert_template "new"
  end

  def test_create_agree_checkbox_not_checked_fails_with_returning_user
    workgroup = workgroups(:workgroup_nonsub)
    @request.host = "#{workgroup.subdomain}.local.host"
    user = users(:uns)
    user.last_login_at = Time.now
    user.save!

    post :create, :login=> user.login, :password=> "test"
    assert_response :success
    assert_template "new"
  end

  def test_create_agree_checkbox_checked_login_failed
    workgroup = workgroups(:workgroup_nonsub)
    @request.host = "#{workgroup.subdomain}.local.host"
    user = users(:uns)

    post :create, :login=> user.login, :password=> "foo"
    assert_response :success
    assert_template "new"
  end

  def test_create_agree_checkbox_checked_login_succeeded
    workgroup = workgroups(:workgroup_nonsub)
    @request.host = "#{workgroup.subdomain}.local.host"
    user = users(:uns)

    post :create, :login=> user.login, :password=> "test", :agree=>"1"
    assert_nil flash[:error]
    assert_redirected_to reset_password_user_path(user)
  end

end
