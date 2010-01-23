require File.dirname(__FILE__) + '/../test_helper'

class StudiesControllerTest < ActionController::TestCase
  def test_index_should_require_login
    # get :index
    xhr :get, :index
    assert_response :success
    assert_match /document\.location/, @response.body
  end

  def test_index_should_require_referral_id
    login_as(:quentin)
    # get :index
    xhr :get, :index
    assert_response :error
  end

  def test_index_should_succeed
    login_as(:quentin)
    # get :index, :create_referral_id=>referrals(:kildare_to_mccoy_new_referral)
    xhr :get, :index, :create_referral_id=>referrals(:kildare_to_mccoy_new_referral)
    assert_response :success
  end

  def test_create_should_succeed
    initial_study_count = ReferralStudy.count
    login_as(:quentin)
    # post :create, :create_referral_id=>referrals(:kildare_to_mccoy_new_referral), :study_type => 'diag_images', :modality => 'tag_diag_images_aden_stres_nuc'
    xhr :post, :create, :create_referral_id=>referrals(:kildare_to_mccoy_new_referral), :study_type => 'diag_images', :modality => 'tag_diag_images_aden_stres_nuc'
    assert_response :success
    assert_equal initial_study_count+1, ReferralStudy.count
  end
end
