require File.dirname(__FILE__) + '/../test_helper'

class RoleSystemTest < Test::Unit::TestCase
  include RoleSystem

  def setup
    @controller = ApplicationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    # mock support
    @logged_in  = false
    @current_user = users(:quentin)
  end

  def test_should_always_return_false_when_not_logged_in
    assert !current_user_has_role?(:admin)
  end

  def test_should_return_true_when_has_role
    @logged_in = true
    assert !current_user_has_role?(:admin)
    assert current_user_has_role?(:manage_billing)
    assert current_user_has_role?(:network_profile)
  end

  def test_should_execute_block_when_has_role
    @logged_in = true
    @block_has_run = false
    current_user_has_role(:admin) do
      @block_has_run = true
    end
    assert !@block_has_run

    @block_has_run = false
    current_user_has_role(:manage_billing) do
      @block_has_run = true
    end
    assert @block_has_run

    @block_has_run = false
    current_user_has_role(:network_profile) do
      @block_has_run = true
    end
    assert @block_has_run
  end

  protected

  def logged_in?
    # replace the authentication system with mock method
    return @logged_in
  end

  def current_user
    # replace the authentication system with mock method
    return @current_user
  end

end
