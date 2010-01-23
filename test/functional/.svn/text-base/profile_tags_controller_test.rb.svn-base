require File.dirname(__FILE__) + '/../test_helper'

class ProfileTagsControllerTest < ActionController::TestCase
  def test_index_should_require_login
    get :index
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_index
    login_as(:quentin)
    audit_count = AuditLog.count
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
    assert_equal audit_count+1, AuditLog.count
  end

  def test_show_should_require_login
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_show
    login_as(:quentin)
    get :show, :target_profile_id=> profiles(:profile_quentin)
    assert_response :success, "Response: #{@response.body}"
    assert_not_nil assigns(:target_profile)
    assert_not_nil assigns(:profile_tags)
    assert assigns(:profile_tags).length > 0
  end

  def test_new_should_require_login
    get :new
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_new
    login_as(:quentin)
    profile = profiles(:profile_quentin)
    get :new, :target_profile_id=>profile.id
    assert_response :success
    assert_match /Tag type:/, @response.body
    assert_no_match /Tag:/, @response.body
    assert_no_match /Sub-Tag:/, @response.body
    assert_select_rjs :hide, "submit_button"
  end

  def test_new_with_tag_type
    login_as(:quentin)
    profile = profiles(:profile_quentin)
    tag = tags(:tag_location_downtown_austin)
    get :new, :target_profile_id=>profile.id, :profile_tag=>{ :tag_type_id=>tag.tag_type_id }
    assert_response :success
    assert_match /Tag type:/, @response.body
    assert_match /Tag:/, @response.body
    assert_no_match /Sub-Tag:/, @response.body
    assert_select_rjs :hide, "submit_button"
  end

  def test_new_with_tag_type_and_tag
    login_as(:quentin)
    profile = profiles(:profile_quentin)
    tag = tags(:tag_location_downtown_austin)
    get :new, :target_profile_id=>profile.id, :profile_tag=>{ :tag_type_id=>tag.tag_type_id, :tag_id=> tag.id }
    assert_response :success
    assert_match /Tag type:/, @response.body
    assert_match /Tag:/, @response.body
    assert_no_match /Sub-Tag:/, @response.body
    assert_select_rjs :show, "submit_button"
  end

  def test_new_with_tag_type_and_tag_that_is_parent
    login_as(:quentin)
    profile = profiles(:profile_quentin)
    tag = tags(:tag_specialties_cardiology)
    get :new, :target_profile_id=>profile.id, :profile_tag=>{ :tag_type_id=>tag.tag_type_id, :tag_id=> tag.id }
    assert_response :success
    assert_match /Tag type:/, @response.body
    assert_match /Tag:/, @response.body
    assert_match /Sub-Tag:/, @response.body
    assert_select_rjs :hide, "submit_button"
  end

  def test_new_with_tag_type_and_parent_tag_and_tag
    login_as(:quentin)
    profile = profiles(:profile_quentin)
    parent_tag = tags(:tag_specialties_cardiology)
    tag = tags(:tag_sub_spec_interventional_cardio)
    get :new, :target_profile_id=>profile.id, :profile_tag=>{ :tag_type_id=>tag.tag_type_id, :tag_id=> tag.id }, :parent_tag_id=> parent_tag.id
    assert_response :success
    assert_match /Tag type:/, @response.body
    assert_match /Tag:/, @response.body
    assert_match /Sub-Tag:/, @response.body
    assert_select_rjs :show, "submit_button"
  end

  def test_create_should_require_login
    post :create
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_create_single_tag
    login_as(:quentin)
    count = ProfileTag.count
    profile = profiles(:profile_quentin)
    tag_type = tag_types(:location)
    tag = tags(:tag_location_downtown_austin)
    post :create, :profile_tag=>{ :profile_id=>profile.id, :tag_type_id=>tag_type.id, :tag_id=>tag.id }
    assert_response :success
    assert_equal count+1, ProfileTag.count
    assert_not_nil assigns(:profile_tag)
    assert_equal tag.id, assigns(:profile_tag).tag_id
  end

  def test_create_tag_with_parent
    login_as(:quentin)
    count = ProfileTag.count
    profile = profiles(:profile_quentin)
    parent_tag = tags(:tag_specialties_cardiology)
    tag_type = tag_types(:sub_specialties)
    tag = tags(:tag_sub_spec_interventional_cardio)
    # note: tag_type_id will always be the parent tag id, since we leave that select box in the form within the UI
    post :create, :profile_tag=>{ :profile_id=>profile.id, :tag_type_id=>parent_tag.tag_type_id, :tag_id=>tag.id }, :parent_tag_id=>parent_tag.id
    assert_response :success
    assert_equal count+2, ProfileTag.count
    assert_not_nil assigns(:profile_tag)
    assert_not_nil assigns(:profile_tag_parent)
    assert_equal tag.id, assigns(:profile_tag).tag_id
    assert_equal parent_tag.id, assigns(:profile_tag_parent).tag_id
    assert_equal parent_tag.tag_type_id, assigns(:profile_tag_parent).tag_type_id

    # validate against the tags found in the DB to be sure all FKs are set properly
    tags_found = ProfileTag.find(:all, :conditions=>["profile_id = ?", profile.id])
    assert_equal 3, tags_found.length
    tags_found.each do |tag_found|
      if tag_found.id == "quentin_specialty_ontology"
        # ignore the fixture
      end

      if tag_found.tag_id == tag.id
        assert_equal tag_type.id, tag_found.tag_type_id
      end

      if tag_found.tag_id == parent_tag.id
        assert_equal parent_tag.tag_type_id, tag_found.tag_type_id
      end
    end
  end

  def test_create_tag_with_parent_create_parent_only_once
    login_as(:quentin)
    count = ProfileTag.count
    profile = profiles(:profile_aaron)
    parent_tag = tags(:tag_carrier_blue_cross)
    tag_type = tag_types(:insurance_carrier_plans)
    tag = tags(:tag_carrier_blue_cross_1)
    post :create, :profile_tag=>{ :profile_id=>profile.id, :tag_type_id=>tag_type.id, :tag_id=>tag.id }, :parent_tag_id=>parent_tag.id
    assert_response :success
    assert_equal count+1, ProfileTag.count
    assert_not_nil assigns(:profile_tag)
    assert_not_nil assigns(:profile_tag_parent)
    assert_equal tag.id, assigns(:profile_tag).tag_id
  end

  def test_create_tag_with_parent_and_additional_profiles
    login_as(:quentin)
    count = ProfileTag.count
    profile = profiles(:profile_quentin)
    parent_tag = tags(:tag_specialties_cardiology)
    tag_type = tag_types(:sub_specialties)
    tag = tags(:tag_sub_spec_interventional_cardio)
    post :create, :profile_tag=>{ :profile_id=>profile.id, :tag_type_id=>tag_type.id, :tag_id=>tag.id }, :parent_tag_id=>parent_tag.id, :additional_profile_ids=>[profiles(:profile_quentin_jr).id]
    assert_response :success
    assert_equal count+4, ProfileTag.count
    assert_not_nil assigns(:profile_tag)
    # validate typical path, to make sure we didn't fail there
    assert_not_nil assigns(:profile_tag_parent)
    assert_equal tag.id, assigns(:profile_tag).tag_id
    assert_equal parent_tag.id, assigns(:profile_tag_parent).tag_id
    assert_equal parent_tag.tag_type_id, assigns(:profile_tag_parent).tag_type_id
    # validate that we created the additional profile
    assert_not_nil assigns(:additional_profile_tags)
    assert_not_nil assigns(:additional_profile_tag_parents)
    assert_equal 1, assigns(:additional_profile_tags).length
    assert_equal 1, assigns(:additional_profile_tag_parents).length
  end

  def test_destroy_should_require_login
    post :destroy
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_destroy
    login_as(:quentin)
    count = ProfileTag.count
    post :destroy, :id=> profile_tags(:quentin_specialty_ontology)
    assert_response :success
    assert_equal count-1, ProfileTag.count
  end

end
