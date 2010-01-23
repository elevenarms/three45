require File.dirname(__FILE__) + '/../test_helper'

class SearchControllerTest < ActionController::TestCase

  @@search_criteria_all = { :provider_types => '',
                            :specialties => '',
                            :sub_specialties => '',
                            :insurance_carriers => '',
                            :insurance_carrier_plans => '',
                            :proximity_in_miles => '',
                            :proximity_location => '',
                            :medical_school => '',
                            :residency => '',
                            :fellowships => '',
                            :undergraduate => '',
                            :board_certified => '',
                            :hospital_privileges => '',
                            :organization => '' }

  @@search_criteria_one = { :provider_types => '',
                            :specialties => 'Ontology',
                            :sub_specialties => '',
                            :insurance_carriers => '',
                            :insurance_carrier_plans => '',
                            :proximity_in_miles => '',
                            :proximity_location => '',
                            :medical_school => '',
                            :residency => '',
                            :fellowships => '',
                            :undergraduate => '',
                            :board_certified => '',
                            :hospital_privileges => '',
                            :organization => '' }

  @@search_criteria_two = { :provider_types => '',
                            :specialties => '',
                            :sub_specialties => '',
                            :insurance_carriers => '',
                            :insurance_carrier_plans => '',
                            :proximity_in_miles => '',
                            :proximity_location => '',
                            :medical_school => '',
                            :residency => '',
                            :fellowships => '',
                            :undergraduate => '',
                            :board_certified => 'Y',
                            :hospital_privileges => '',
                            :organization => '' }

  @@search_criteria_two_tags = { :provider_types => '',
                            :specialties => 'Ontology',
                            :sub_specialties => '',
                            :insurance_carriers => 'Blue Cross',
                            :insurance_carrier_plans => 'Standard',
                            :proximity_in_miles => '',
                            :proximity_location => '',
                            :medical_school => '',
                            :residency => '',
                            :fellowships => '',
                            :undergraduate => '',
                            :board_certified => '',
                            :hospital_privileges => '',
                            :organization => '' }

  def test_search_should_honor_network_search_context
    login_as(:quentin)
    post :create, :controller => :network, :network => 'my_network', :search => @@search_criteria_all

    assert_response :success
    assert_template "network/show"
  end

  def test_search_should_honor_referral_search_context
    login_as(:quentin)
    post :create, :controller => :start_referral, :network => 'my_network', :search => @@search_criteria_all

    assert_response :success
    assert_template "start_referral/show"
  end

  def test_search_should_return_paged_result
    login_as(:quentin)
    post :create, :network => 'entire_network', :search => @@search_criteria_all

    assert_response :success
    assert_template "show"

    profile = assigns(:profile)
    assert_not_nil profile
    assert_equal profiles(:profile_quentin).id, profile.id

    assert_equal 1, assigns(:page_number)
    assert_nil assigns(:offset)
    assert_not_nil assigns(:total_pages)
    assert_equal 2, assigns(:total_pages)

    assert_not_nil assigns(:friendships)
    assert_equal 1, assigns(:friendships).length

    assert_not_nil assigns(:profile_results)
    assert_equal 10, assigns(:profile_results).length

    assert_match /1 of 2/, @response.body
  end

  def test_search_should_honor_local_scope
    login_as(:quentin)
    post :create, :network => 'my_network', :search => @@search_criteria_all

    assert_response :success
    assert_template "show"

    assert_not_nil assigns(:profile_results)
    assert_equal 1, assigns(:profile_results).length
  end

  def test_search_should_honor_workgroup_scope
    login_as(:quentin)
    post :create, :network => 'workgroup_network', :search => @@search_criteria_all

    assert_response :success
    assert_template "show"

    assert_not_nil assigns(:profile_results)
    assert_equal 1, assigns(:profile_results).length
  end

  def test_search_should_honor_search_criteria
    login_as(:quentin)
    post :create, :network => 'entire_network', :search => @@search_criteria_one

    assert_response :success
    assert_template "show"

    assert_not_nil assigns(:profile_results)
    assert_equal 1, assigns(:profile_results).length
    assert_equal 'profile_aaron', assigns(:profile_results)[0].id
  end

  def test_search_should_honor_board_certified_checkbox
    login_as(:quentin)
    post :create, :network => 'entire_network', :search => @@search_criteria_two

    assert_response :success
    assert_template "show"

    assert_not_nil assigns(:profile_results)
    assert_equal 0, assigns(:profile_results).length
  end

  def test_search_should_retain_search_mode
    login_as(:quentin)
    post :create, :network => 'entire_network', :search_mode => 'basic', :search => @@search_criteria_all

    assert_response :success
    assert_template "show"

    assert_match /<strong>Basic Search<\/strong>/, @response.body
    assert_no_match /<strong>Advanced Search<\/strong>/, @response.body

    post :create, :network => 'entire_network', :search_mode => 'advanced', :search => @@search_criteria_all

    assert_response :success
    assert_template "show"

    assert_match /<strong>Advanced Search<\/strong>/, @response.body
    assert_no_match /<strong>Basic Search<\/strong>/, @response.body
  end

  def test_search_should_retain_search_criteria
    login_as(:quentin)
    post :create, :network => 'entire_network', :search_mode => 'advanced', :search => @@search_criteria_all

    assert_response :success
    assert_template "show"

    assert_no_match /value=\"Ontology\"/, @response.body

    post :create, :network => 'entire_network', :search_mode => 'advanced', :search => @@search_criteria_one

    assert_response :success
    assert_template "show"

    assert_match /value=\"Ontology\"/, @response.body
  end

  def test_search_should_honor_board_certified_checkbox
    login_as(:quentin)

    post :create, :network => 'entire_network', :search_mode => 'advanced', :search => @@search_criteria_two_tags

    assert_response :success
    assert_template "show"

    assert_match /<strong>Advanced Search<\/strong>/, @response.body

    assert_not_nil assigns(:profile_results)
    assert_equal 1, assigns(:profile_results).length
  end
end
