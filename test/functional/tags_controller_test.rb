require File.dirname(__FILE__) + '/../test_helper'

class TagsControllerTest < ActionController::TestCase

  def test_show_should_require_login
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_show_should_require_id
    login_as(:quentin)
    get :show
    assert_response :error
  end

  def test_show_should_display_profiles_by_tag
    initial_view_count = TagView.count
    login_as(:quentin)
    get :show, :id=>tags(:tag_specialty_ontology)
    assert_response :success
    profiles = assigns(:profile_results)
    assert_not_nil profiles
    assert_equal 1, profiles.length
    friendships = assigns(:friendships)
    assert_equal 0, friendships.length
    assert_no_tag :div, :attributes => { :class => "tag_details" }
    assert_no_tag :div, :attributes => { :class => "tag_sponsor" }
    assert_equal initial_view_count+1, TagView.count
  end

  def test_show_should_display_sponsor
    initial_view_count = TagSponsorView.count
    login_as(:quentin)
    get :show, :id=>tags(:tag_certification_cert_osteopath)
    assert_response :success
    profiles = assigns(:profile_results)
    assert_not_nil profiles
    assert_equal 0, profiles.length
    friendships = assigns(:friendships)
    assert_equal 0, friendships.length
    assert_no_tag :div, :attributes => { :class => "tag_details" }
    assert_tag :div, :attributes => { :class => "tag_sponsor" }
    assert_equal initial_view_count+1, TagSponsorView.count
  end

  def test_show_should_display_details
    login_as(:quentin)
    get :show, :id=>tags(:tag_education_undergrad_ut)
    assert_response :success
    profiles = assigns(:profile_results)
    assert_not_nil profiles
    assert_equal 1, profiles.length
    friendships = assigns(:friendships)
    assert_equal 0, friendships.length
    assert_tag :div, :attributes => { :class => "tag_details" }
    assert_no_tag :div, :attributes => { :class => "tag_sponsor" }
  end

  def test_show_should_paginate
    # create 15 new profiles that all point to the same tag for testing pagination
    15.times do |i|
      new_profile = Profile.create!(:profile_type_id=>'user', :display_name=>'Aaron #{i}', :user_id=>users(:aaron))
      ProfileTag.create!(:tag_id=>tags(:tag_education_undergrad_ut).id, :profile_id=>new_profile.id, :tag_type_id => "education_undergrad")
    end

    login_as(:quentin)
    get :show, :id=>tags(:tag_education_undergrad_ut).id
    assert_response :success

    assert_equal 1, assigns(:page_number)
    assert_nil assigns(:offset)
    assert_not_nil assigns(:total_pages)
    assert_equal 2, assigns(:total_pages)

    assert_not_nil assigns(:profile_results)
    assert_equal 10, assigns(:profile_results).length

    get :show, :id=>tags(:tag_education_undergrad_ut), :page_number => 2
    assert_response :success

    assert_equal 2, assigns(:page_number)
    assert_not_nil assigns(:offset)
    assert_equal 10, assigns(:offset)
    assert_not_nil assigns(:total_pages)
    assert_equal 2, assigns(:total_pages)

    assert_not_nil assigns(:profile_results)
    assert_equal 6, assigns(:profile_results).length
  end

  def test_show_should_rotate_sponsors
    initial_view_count = TagSponsorView.count
    login_as(:quentin)

    # first one
    get :show, :id=>tags(:tag_certification_cert_osteopath).id
    assert_response :success
    assert_not_nil session[:last_sponsor_index]
    assert_not_nil session[:last_sponsor_index][tags(:tag_certification_cert_osteopath).id.to_s]
    selected_sponsor = assigns(:selected_sponsor)
    assert_not_nil selected_sponsor
    assert_equal tag_sponsors(:tag_sponser_osteopath_too).id, selected_sponsor.id

    # second one
    get :show, :id=>tags(:tag_certification_cert_osteopath).id
    selected_sponsor = assigns(:selected_sponsor)
    assert_not_nil selected_sponsor
    assert_equal tag_sponsors(:tag_sponser_osteopath).id, selected_sponsor.id

    # first one again
    get :show, :id=>tags(:tag_certification_cert_osteopath).id
    selected_sponsor = assigns(:selected_sponsor)
    assert_not_nil selected_sponsor
    assert_equal tag_sponsors(:tag_sponser_osteopath_too).id, selected_sponsor.id
  end
  
  def test_suggestions
    login_as :quentin
    
    xhr :post, :suggest
    assert_response :success
    assert @response.body == "<ul></ul>"

    xhr :post, :suggest, :search => { :unrecognized_tag_type => "" }
    assert_response :success
    assert @response.body == "<ul></ul>"

    xhr :post, :suggest, :search => { :unrecognized_tag_type => "x" }
    assert_response :success
    assert @response.body == "<ul></ul>"

    xhr :post, :suggest, :search => { :unrecognized_tag_type => "Any" }
    assert_response :success
    assert @response.body == "<ul></ul>"

    xhr :post, :suggest, :search => { :provider_types => "" }
    assert_response :success
    assert @response.body == "<ul><li>Ancillary Provider</li><li>Physician Provider</li></ul>"

    xhr :post, :suggest, :search => { :provider_types => "x" }
    assert_response :success
    assert @response.body == "<ul></ul>"

    xhr :post, :suggest, :search => { :provider_types => "p" }
    assert_response :success
    assert @response.body == "<ul><li>Physician Provider</li></ul>"

    xhr :post, :suggest, :search => { :provider_types => "Any" }
    assert_response :success
    assert @response.body == "<ul><li>Ancillary Provider</li><li>Physician Provider</li></ul>"

    xhr :post, :suggest, :search => { :specialties => "" }
    assert_response :success
    everything = @response.body
    
    xhr :post, :suggest, :search => { :specialties => "x" }
    assert_response :success
    assert @response.body == "<ul></ul>"
    
    xhr :post, :suggest, :search => { :specialties => "o" }
    assert_response :success
    # assert @response.body == "<ul><li>Obstetrics and Gynecology</li><li>Occupational Medicine</li><li>Ophthalmology</li><li>Orthopaedic Surgery</li><li>Otolaryngology</li><li>Ontology</li></ul>"
    
    xhr :post, :suggest, :search => { :specialties => "Any" }
    assert_response :success    
    assert @response.body == everything
  end
end
