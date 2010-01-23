require File.dirname(__FILE__) + '/../test_helper'

class FaxFilesControllerTest < ActionController::TestCase
  def test_create_should_require_fax_id
    login_as(:quentin)
    post :create
    assert_response :error
  end

  def test_create_should_support_file_uploads
    login_as(:quentin)
    fax = referral_faxes(:test_referral_fax_one)
    fdata = fixture_file_upload('files/fax.tiff', 'image/tiff')
    count = ReferralFaxFile.count
    assert_equal referral_fax_states(:waiting).id, fax.referral_fax_state_id
    post :create, :id=> fax.id, :fax_file=>{ :uploaded_data => fdata }, :html => { :multipart => true }
    assert_response :success
    assert count+1, ReferralFaxFile.count
    fax.reload
    assert_equal referral_fax_states(:waiting).id, fax.referral_fax_state_id
  end

  def test_create_should_support_file_uploads_with_status
    login_as(:quentin)
    fax = referral_faxes(:test_referral_fax_one)
    fdata = fixture_file_upload('files/fax.tiff', 'image/tiff')
    count = ReferralFaxFile.count
    assert_equal referral_fax_states(:waiting).id, fax.referral_fax_state_id
    post :create, :id=> referral_faxes(:test_referral_fax_one).id, :fax_file=>{ :uploaded_data => fdata }, :html => { :multipart => true }, :new_fax_state_id=>referral_fax_states(:received_successfully).id
    assert_response :success
    assert count+1, ReferralFaxFile.count
    fax.reload
    assert_equal referral_fax_states(:received_successfully).id, fax.referral_fax_state_id
  end


  def test_download_requires_login
    get :download
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_download_requires_id
    login_as(:quentin)
    get :download
    assert_response :error
  end

  def test_download_fails_missing_file
    fax = referral_faxes(:test_referral_fax_one)
    login_as(:quentin)
    get :download, :id=>fax.id
    assert_response :error
  end

  def test_download_succeeds
    fax = referral_faxes(:test_referral_fax_one)
    fdata = fixture_file_upload('files/fax.tiff', 'image/tiff')
    referral = referrals(:mccoy_to_kildare_1)

    # first, upload it
    login_as(:quentin)
    count = ReferralFaxFile.count
    assert_equal referral_fax_states(:waiting).id, fax.referral_fax_state_id
    post :create, :id=> fax.id, :fax_file=>{ :uploaded_data => fdata }, :html => { :multipart => true }, :new_fax_state_id=>referral_fax_states(:received_successfully).id
    assert_response :success, "#{@response.body}"
    assert count+1, ReferralFaxFile.count
    @fax_file = assigns(:fax_file)

    # now try to retrieve it
    get :download, :fax_file_id=>@fax_file.id, :id=>fax.id
    assert_response :success, "#{@response.body}"
  end
end
