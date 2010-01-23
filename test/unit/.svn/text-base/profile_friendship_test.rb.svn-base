require File.dirname(__FILE__) + '/../test_helper'

class ProfileFriendshipTest < ActiveSupport::TestCase

  def test_fixtures_should_load
    assert ProfileFriendship.count > 0
  end

  def test_find_by_profile
    quentin = profiles(:profile_quentin)
    aaron = profiles(:profile_aaron)
    chiro = profiles(:profile_workgroup_chiro)

    assert ProfileFriendship.find_by_profile(quentin)[0].size == 1
    assert ProfileFriendship.find_by_profile(aaron)[0].size == 1
    assert ProfileFriendship.find_by_profile(chiro)[0].size == 2
  end

  def test_find_friendship_from_to
    quentin = profiles(:profile_quentin)
    aaron = profiles(:profile_aaron)
    chiro = profiles(:profile_workgroup_chiro)

    assert ProfileFriendship.find_friendship_from_to(quentin,aaron) == nil
    assert ProfileFriendship.find_friendship_from_to(quentin,chiro) != nil
    assert ProfileFriendship.find_friendship_from_to(chiro,aaron) != nil
  end

  def test_find_by_workgroup_id
    mccoy = workgroups(:workgroup_mccoy)
    kildare = workgroups(:workgroup_kildare)
    welby = workgroups(:workgroup_welby)
    chiro = workgroups(:workgroup_chiro)
    phys_therapy = workgroups(:workgroup_phys_therapy)

    assert ProfileFriendship.find_by_workgroup_id(mccoy.id).size == 1
    assert ProfileFriendship.find_by_workgroup_id(kildare.id).size == 0
    assert ProfileFriendship.find_by_workgroup_id(welby.id).size == 1
    assert ProfileFriendship.find_by_workgroup_id(chiro.id).size == 2
    assert ProfileFriendship.find_by_workgroup_id(phys_therapy.id).size == 0
  end

  def test_find_in_list_for_should_return_only_matching_profiles
    quentin = profiles(:profile_quentin)
    friendships = ProfileFriendship.find_in_list_for(quentin, ['profile_workgroup_chiro'])
    assert_equal 1, friendships.length
    assert_equal 'profile_workgroup_chiro', friendships.first.target_profile_id


    friendships = ProfileFriendship.find_in_list_for(quentin, ['profile_aaron'])
    assert_equal 0, friendships.length

    ProfileFriendship.create!({ :source_profile_id => 'profile_quentin', :target_profile_id => 'profile_aaron'})

    friendships = ProfileFriendship.find_in_list_for(quentin, ['profile_aaron'])
    assert_equal 1, friendships.length
    assert_equal 'profile_aaron', friendships.first.target_profile_id

    friendships = ProfileFriendship.find_in_list_for(quentin, ['profile_aaron', 'profile_workgroup_chiro'])
    assert_equal 2, friendships.length
  end

  def test_create_bidirectional_friendship
    profile_quentin = profiles(:profile_quentin)
    profile_aaron   = profiles(:profile_aaron)
    count = ProfileFriendship.count
    ProfileFriendship.create_bidirectional_friendship!(profile_quentin, profile_aaron)
    assert_equal count+2, ProfileFriendship.count
  end

  # def test_blocked_for_and_blocking_should_return_false_if_no_blocks
  #   quentin = profiles(:profile_quentin)
  #   workgroup_chiro = profiles(:profile_workgroup_chiro)
  #   friendship = profile_friendships(:quentin_to_workgroup_chiro)
  #   friendship_target = profile_friendships(:workgroup_chiro_to_quentin)
  #   assert !friendship.blocked_for?(quentin)
  #   assert !friendship.blocking?(quentin)
  #   assert !friendship.blocked_for?(workgroup_chiro)
  #   assert !friendship.blocking?(workgroup_chiro)
  # end
  #
  # def test_blocked_for_and_blocking_should_return_true_if_source_is_blocking
  #   quentin = profiles(:profile_quentin)
  #   workgroup_chiro = profiles(:profile_workgroup_chiro)
  #   friendship = profile_friendships(:quentin_to_workgroup_chiro)
  #   friendship_target = profile_friendships(:workgroup_chiro_to_quentin)
  #   # quentin blocking chiro
  #   friendship.blocked_by_source_at = Time.now
  #   friendship.blocked_by_target_at = nil
  #   assert !friendship.blocked_for?(quentin)
  #   assert friendship.blocking?(quentin)
  #   assert friendship.blocked_for?(workgroup_chiro)
  #   assert !friendship.blocking?(workgroup_chiro)
  # end
  #
  # def test_blocked_for_and_blocking_should_return_true_if_target_is_blocking
  #   quentin = profiles(:profile_quentin)
  #   workgroup_chiro = profiles(:profile_workgroup_chiro)
  #   friendship = profile_friendships(:quentin_to_workgroup_chiro)
  #   friendship_target = profile_friendships(:workgroup_chiro_to_quentin)
  #   # workgroup_chiro blocking quentin
  #   friendship.blocked_by_source_at = nil
  #   friendship.blocked_by_target_at = Time.now
  #   assert friendship.blocked_for?(quentin)
  #   assert !friendship.blocking?(quentin)
  #   assert !friendship.blocked_for?(workgroup_chiro)
  #   assert friendship.blocking?(workgroup_chiro)
  # end

  def test_block_by_source_should_mark_friendship_blocked
    # setup for this more complicated test
    quentin = profiles(:profile_quentin)
    workgroup_chiro = profiles(:profile_workgroup_chiro)
    friendship = profile_friendships(:quentin_to_workgroup_chiro)
    friendship_target = profile_friendships(:workgroup_chiro_to_quentin)
    assert !friendship.source_blocked?
    assert !friendship.target_blocked?
    assert !friendship_target.source_blocked?
    assert !friendship_target.target_blocked?

    # quentin decided to block the workgroup_chiro friendship
    friendship.block!
    friendship.reload
    friendship_target.reload
    assert !friendship.source_blocked?
    assert friendship.target_blocked?
    assert friendship_target.source_blocked?
    assert !friendship_target.target_blocked?
  end

  def test_block_by_target_should_mark_friendship_blocked
    # setup for this more complicated test
    quentin = profiles(:profile_quentin)
    workgroup_chiro = profiles(:profile_workgroup_chiro)
    friendship = profile_friendships(:quentin_to_workgroup_chiro)
    friendship_target = profile_friendships(:workgroup_chiro_to_quentin)
    assert !friendship.source_blocked?
    assert !friendship.target_blocked?
    assert !friendship_target.source_blocked?
    assert !friendship_target.target_blocked?

    # workgroup_chiro decided to block the quentin friendship
    friendship_target.block!
    friendship.reload
    friendship_target.reload
    assert friendship.source_blocked?
    assert !friendship.target_blocked?
    assert !friendship_target.source_blocked?
    assert friendship_target.target_blocked?
  end

  def test_open_by_source_should_mark_friendship_open
    # setup for this more complicated test
    quentin = profiles(:profile_quentin)
    workgroup_chiro = profiles(:profile_workgroup_chiro)
    friendship = profile_friendships(:quentin_to_workgroup_chiro)
    friendship_target = profile_friendships(:workgroup_chiro_to_quentin)
    assert !friendship.source_blocked?
    assert !friendship.target_blocked?
    assert !friendship_target.source_blocked?
    assert !friendship_target.target_blocked?

    # quentin decided to block the workgroup_chiro friendship
    friendship.block!
    friendship.reload
    friendship_target.reload
    assert !friendship.source_blocked?
    assert friendship.target_blocked?
    assert friendship_target.source_blocked?
    assert !friendship_target.target_blocked?
    # quentin decided to open the workgroup_chiro friendship
    friendship.open!
    friendship.reload
    friendship_target.reload
    assert !friendship.source_blocked?
    assert !friendship.target_blocked?
    assert !friendship_target.source_blocked?
    assert !friendship_target.target_blocked?
  end

  def test_open_by_target_should_mark_friendship_open
    # setup for this more complicated test
    quentin = profiles(:profile_quentin)
    workgroup_chiro = profiles(:profile_workgroup_chiro)
    friendship = profile_friendships(:quentin_to_workgroup_chiro)
    friendship_target = profile_friendships(:workgroup_chiro_to_quentin)
    assert !friendship.source_blocked?
    assert !friendship.target_blocked?
    assert !friendship_target.source_blocked?
    assert !friendship_target.target_blocked?

    # workgroup_chiro decided to block the quentin friendship
    friendship_target.block!
    friendship.reload
    friendship_target.reload
    assert friendship.source_blocked?
    assert !friendship.target_blocked?
    assert !friendship_target.source_blocked?
    assert friendship_target.target_blocked?
    # workgroup_chiro decided to open the quentin friendship
    friendship_target.open!
    friendship.reload
    friendship_target.reload
    assert !friendship.source_blocked?
    assert !friendship.target_blocked?
    assert !friendship_target.source_blocked?
    assert !friendship_target.target_blocked?
  end

#  def test_block_should_mark_friendship_blocked_one_way
#    quentin = profiles(:profile_quentin)
#    workgroup_chiro = profiles(:profile_workgroup_chiro)
#    friendship = profile_friendships(:quentin_to_workgroup_chiro)
#    assert !friendship.blocked_for?(quentin)
#    assert !friendship.blocking?(quentin)
#    assert !friendship.blocked_for?(workgroup_chiro)
#    assert !friendship.blocking?(workgroup_chiro)
#
#    friendship.block!(quentin)
#    assert !friendship.blocked_for?(quentin)
#    assert friendship.blocking?(quentin)
#    assert friendship.blocked_for?(workgroup_chiro)
#    assert !friendship.blocking?(workgroup_chiro)
#
#    friendship.open!(quentin)
#    assert !friendship.blocked_for?(quentin)
#    assert !friendship.blocking?(quentin)
#    assert !friendship.blocked_for?(workgroup_chiro)
#    assert !friendship.blocking?(workgroup_chiro)
#
#    friendship.block!(workgroup_chiro)
#    assert friendship.blocked_for?(quentin)
#    assert !friendship.blocking?(quentin)
#    assert !friendship.blocked_for?(workgroup_chiro)
#    assert friendship.blocking?(workgroup_chiro)
#
#    friendship.open!(workgroup_chiro)
#    assert !friendship.blocked_for?(quentin)
#    assert !friendship.blocking?(quentin)
#    assert !friendship.blocked_for?(workgroup_chiro)
#    assert !friendship.blocking?(workgroup_chiro)
#
#    friendship.block!(workgroup_chiro)
#    friendship.block!(quentin)
#    assert friendship.blocked_for?(quentin)
#    assert friendship.blocking?(quentin)
#    assert friendship.blocked_for?(workgroup_chiro)
#    assert friendship.blocking?(workgroup_chiro)
#    friendship.open!(workgroup_chiro)
#    assert !friendship.blocked_for?(quentin)
#    assert friendship.blocking?(quentin)
#    assert friendship.blocked_for?(workgroup_chiro)
#    assert !friendship.blocking?(workgroup_chiro)
#    friendship.open!(quentin)
#    assert !friendship.blocked_for?(quentin)
#    assert !friendship.blocking?(quentin)
#    assert !friendship.blocked_for?(workgroup_chiro)
#    assert !friendship.blocking?(workgroup_chiro)
#  end

end
