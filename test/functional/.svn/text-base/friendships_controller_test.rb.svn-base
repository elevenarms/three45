require File.dirname(__FILE__) + '/../test_helper'

class FriendshipsControllerTest < ActionController::TestCase

  def test_create_should_require_login
    post :create
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_create_should_require_id
    login_as(:quentin)
    post :create
    assert_response :error
  end

  def test_create_should_create_new_friendship
    initial_count = ProfileFriendship.count
    login_as(:quentin)
    xhr :post, :create, :id=> profiles(:profile_aaron)
    assert_response :success, "Response was #{@response.response_code}. Message: #{@response.body}"
    friendship = assigns(:friendship)
    assert_not_nil friendship
    assert_equal profiles(:profile_quentin).id, friendship.created_by_profile_id
    assert_equal profiles(:profile_quentin).id, friendship.source_profile_id
    assert_equal profiles(:profile_aaron).id, friendship.target_profile_id
    assert_equal initial_count+2, ProfileFriendship.count
  end

  def test_create_should_ignore_existing_friendship
    initial_count = ProfileFriendship.count
    login_as(:quentin)
    xhr :post, :create, :id=> profiles(:profile_workgroup_chiro)
    assert_response :success, "Response was #{@response.response_code}. Message: #{@response.body}"
    friendship = assigns(:friendship)
    assert_nil friendship
    assert_equal initial_count, ProfileFriendship.count
  end

  def test_block_should_require_login
    post :block
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_block_should_require_id
    login_as(:quentin)
    post :block
    assert_response :error
  end

  def test_block_should_block_friendship
    quentin = profiles(:profile_quentin)
    workgroup_chiro = profiles(:profile_workgroup_chiro)
    friendship = profile_friendships(:quentin_to_workgroup_chiro)
    assert !friendship.source_blocked?
    assert !friendship.target_blocked?

    login_as(:quentin)
    xhr :post, :block, :id=>friendship.id
    assert_response :success, "Response was #{@response.response_code}. Message: #{@response.body}"
    friendship.reload
    assert !friendship.source_blocked?
    assert friendship.target_blocked?
  end

  def test_open_should_require_login
    post :open
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_open_should_require_id
    login_as(:quentin)
    post :open
    assert_response :error
  end

  def test_open_should_unblock_friendship
    quentin = profiles(:profile_quentin)
    workgroup_chiro = profiles(:profile_workgroup_chiro)
    friendship = profile_friendships(:quentin_to_workgroup_chiro)
    friendship.block!
    assert !friendship.source_blocked?
    assert friendship.target_blocked?

    login_as(:quentin)
    xhr :post, :open, :id=>friendship.id
    assert_response :success, "Response was #{@response.response_code}. Message: #{@response.body}"
    friendship.reload
    assert !friendship.source_blocked?
    assert !friendship.target_blocked?
  end

end
