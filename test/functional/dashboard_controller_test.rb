require File.dirname(__FILE__) + '/../test_helper'

class DashboardControllerTest < ActionController::TestCase
  def test_index_should_require_login
    get :index
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_index_should_render_page_with_physician_as_default_owner_filter
    login_as(:quentin)
    get :index
    assert_response :success
    results = assigns(:results)
    assert_not_nil results
    assert_equal 1, results.length
    total_pages = assigns(:total_pages)
    assert_not_nil total_pages
    assert_equal 1, total_pages
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal users(:quentin).id.to_s, filter.filter_owner.to_s
  end

  def test_index_should_load_and_apply_dashboard_filter
    login_as(:quentin_jr)
    get :index
    assert_response :success
    results = assigns(:results)
    assert_not_nil results
    assert_equal 0, results.length
    total_pages = assigns(:total_pages)
    assert_not_nil total_pages
    assert_equal 0, total_pages
  end

  def test_index_should_load_apply_and_update_dashboard_filter
    login_as(:quentin_jr)
    get :index, :filter_type=>"tag_treatment_type"
    assert_response :success
    results = assigns(:results)
    assert_not_nil results
    assert_equal 7, results.length
    total_pages = assigns(:total_pages)
    assert_not_nil total_pages
    assert_equal 1, total_pages
    users(:quentin_jr).reload
    assert_equal "tag_treatment_type", users(:quentin_jr).dashboard_filter.filter_type
  end

  def test_quicklink_waiting_acceptance_physician
    login_as(:quentin)
    get :quicklink, :id=> 'awaiting'
    assert_redirected_to dashboard_index_path
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal "in", filter.filter_direction
    assert_equal "waiting_acceptance", filter.filter_status
    # DISABLED for Alpha release assert_equal users(:quentin).id.to_s, filter.filter_owner
  end

  def test_quicklink_waiting_acceptance_non_physician
    login_as(:quentin_admin)
    get :quicklink, :id=> 'awaiting'
    assert_redirected_to dashboard_index_path
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal "in", filter.filter_direction
    assert_equal "waiting_acceptance", filter.filter_status
    assert_equal "", filter.filter_owner
  end

  def test_quicklink_new_info_physician
    login_as(:quentin)
    get :quicklink, :id=> 'new_info'
    assert_redirected_to dashboard_index_path
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal "", filter.filter_direction
    assert_equal "new_info", filter.filter_status
    # DISABLED for Alpha release assert_equal users(:quentin).id.to_s, filter.filter_owner
  end

  def test_quicklink_new_info_non_physician
    login_as(:quentin_admin)
    get :quicklink, :id=> 'new_info'
    assert_redirected_to dashboard_index_path
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal "", filter.filter_direction
    assert_equal "new_info", filter.filter_status
    assert_equal "", filter.filter_owner
  end

  def test_quicklink_waiting_response_physician
    login_as(:quentin)
    get :quicklink, :id=> 'action_requested'
    assert_redirected_to dashboard_index_path
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal "", filter.filter_direction
    assert_equal "waiting_response", filter.filter_status
    assert_equal users(:quentin).id.to_s, filter.filter_owner
  end

  def test_quicklink_waiting_response_non_physician
    login_as(:quentin_admin)
    get :quicklink, :id=> 'action_requested'
    assert_redirected_to dashboard_index_path
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal "", filter.filter_direction
    assert_equal "waiting_response", filter.filter_status
    assert_equal "", filter.filter_owner
  end

  def test_quicklink_waiting_response_physician
    login_as(:quentin)
    get :quicklink, :id=> 'reset'
    assert_redirected_to dashboard_index_path
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal "", filter.filter_direction
    assert_equal "", filter.filter_status
    # DISABLED for Alpha release assert_equal users(:quentin).id.to_s, filter.filter_owner
  end

  def test_quicklink_waiting_response_non_physician
    login_as(:quentin_admin)
    get :quicklink, :id=> 'reset'
    assert_redirected_to dashboard_index_path
    filter = assigns(:filter)
    assert_not_nil filter
    assert_equal "", filter.filter_direction
    assert_equal "", filter.filter_status
    assert_equal "", filter.filter_owner
  end
end
