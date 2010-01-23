require File.dirname(__FILE__) + '/../test_helper'

class StartReferralControllerTest < ActionController::TestCase
  def test_show_should_redirect_to_login
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def DISABLED_FOR_ALPHA_test_show_should_default_to_first_page_of_my_network
    login_as(:quentin)
    get :show
    assert_response :success
    assert_template "show"

    profile = assigns(:profile)
    assert_not_nil profile
    assert_equal profiles(:profile_quentin).id, profile.id

    assert_equal 1, assigns(:page_number)
    assert_nil assigns(:offset)
    assert_not_nil assigns(:total_pages)
    assert_equal 1, assigns(:total_pages)

    assert_not_nil assigns(:friendships)
    assert_equal 1, assigns(:friendships).length

    assert_not_nil assigns(:profile_results)
    assert_equal 1, assigns(:profile_results).length

    assert_match /1 of 1/, @response.body
  end

  def DISABLED_FOR_ALPHA_test_show_should_paginate
    # create 15 new profiles that all point to the same user for testing pagination
    15.times do |i|
      new_profile = Profile.create!(:profile_type_id=>'user', :display_name=>'Aaron #{i}', :user_id=>users(:aaron))
      ProfileFriendship.create!(:source_profile_id=>"profile_quentin", :target_profile_id=>new_profile.id)
    end

    login_as(:quentin)
    get :show
    assert_response :success
    assert_template "show"

    assert_equal 1, assigns(:page_number)
    assert_nil assigns(:offset)
    assert_not_nil assigns(:total_pages)
    assert_equal 2, assigns(:total_pages)

    assert_not_nil assigns(:friendships)
    assert_equal 10, assigns(:friendships).length

    get :show, { :page_number => 2 }
    assert_response :success
    assert_template "show"

    assert_equal 2, assigns(:page_number)
    assert_not_nil assigns(:offset)
    assert_equal 10, assigns(:offset)
    assert_not_nil assigns(:total_pages)
    assert_equal 2, assigns(:total_pages)

    assert_not_nil assigns(:friendships)
    assert_equal 6, assigns(:friendships).length
  end

  def DISABLED_FOR_ALPHA_test_show_partial_should_display_referral_link
    login_as(:quentin)
    get :show
    assert_response :success
    assert_template "show"

    assert_match /Pick Consultant/, @response.body
    assert_no_match /Suspend Relationship/, @response.body
  end
end
