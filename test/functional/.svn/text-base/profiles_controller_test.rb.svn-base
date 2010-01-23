require File.dirname(__FILE__) + '/../test_helper'

class ProfilesControllerTest < ActionController::TestCase
  def test_show_should_require_login
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_show_should_require_id
    login_as(:quentin)
    get :show
    assert_response :error
  end


  def test_show_should_display_profile_with_friendship
    login_as(:quentin)
    get :show, :id=>profiles(:profile_workgroup_chiro)
    assert_response :success
    assert_template "show"
    assert_match /Suspend\ Relationship/, @response.body
  end

  def test_show_should_display_profile_without_friendship
    login_as(:quentin)
    get :show, :id=>profiles(:profile_aaron)
    assert_response :success
    assert_template "show"
    assert_match /Add\ to/, @response.body
  end

  def test_show_should_display_npi_and_medical_license
    login_as(:quentin)
    get :show, :id=>profiles(:profile_quentin)
    assert_response :success
    assert_template "show"
    assert_match /NPI/, @response.body
    assert_match /Medical License/, @response.body
  end

  def test_show_should_not_display_npi_and_medical_license
    login_as(:quentin)
    get :show, :id=>profiles(:profile_aaron)
    assert_response :success
    assert_template "show"
    assert_no_match /NPI/, @response.body
    assert_no_match /Medical License/, @response.body
  end

end
