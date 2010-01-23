#
# A ProfileFriendship represents a single path between a bi-directional friendship. When a friendship is
# first created, both directions are created at once (source->target and target->source).
#
#
# For a given profile, the ProfileFriendship instance that has that profile as the source_profile is considered
# the primary friendship instance. For example, if Profile A and B have ProfileFriendship C (A->B)
# and ProfileFriendship D (B->A), Profile A's primary friendship instance is C, while Profile B's primary friendship
# instance is D. The complementary friendship is then the one where the profile is then the target rather than the source
#
#
# Currently, a friendship can be suspended (aka "blocked") by either profile without suspending the opposite path.
# This will mark the path from the blocker->blockee
# as suspended and prevent the blockee from making referrals (the blockee will see the blocker profile as "not currently accepting
# referrals" or something friendly). This behavior was documented by James and Dave prior to spec creation and considered the
# current friendship blocking behavior.
#
class ProfileFriendship < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :source_profile,     :class_name => 'Profile', :foreign_key => 'source_profile_id'
  belongs_to :target_profile,     :class_name => 'Profile', :foreign_key => 'target_profile_id'
  belongs_to :created_by_profile, :class_name => 'Profile', :foreign_key => 'created_by_profile_id'

  def self.create_bidirectional_friendship!(originating_profile, target_profile)
    originating = ProfileFriendship.create!({ :source_profile=>originating_profile, :target_profile=>target_profile, :created_by_profile=>originating_profile})
    ProfileFriendship.create!({ :source_profile=>target_profile, :target_profile=>originating_profile, :created_by_profile=>originating_profile})
    return originating
  end

  # finds the single ProfileFriendship whose source profile matches profile_from and target profile matches profile_to
  def self.find_friendship_from_to(profile_from, profile_to)
    # should be maximum of one profile_friendship for each pair of profiles
    ProfileFriendship.find(:first, :conditions=>["(source_profile_id = ? AND target_profile_id = ?)", profile_from.id, profile_to.id])
  end

  # finds friendships for a profile, eager loading dependent models
  #
  # returns an array for pagination support
  def self.find_by_profile(profile, number_to_fetch=10, offset=nil)
    count =
      ProfileFriendship.count('id', :conditions=>["(source_profile_id = ?)", profile.id],
                                :include=>[:source_profile, :target_profile])
    friendships =
      ProfileFriendship.find(:all, :conditions=>["(source_profile_id = ?)", profile.id],
                               :include=>[:source_profile, :target_profile],
                               :limit=>number_to_fetch, :offset=>offset)

    target_profiles = friendships.collect {|fr| fr.target_profile }

    total_pages = (count / number_to_fetch)
    total_pages += 1 if (count % number_to_fetch) != 0
    total_pages = 1 if total_pages == 0

    return friendships, total_pages, target_profiles
  end

  def self.find_by_workgroup_id(workgroup_id)
    # construct subselect clause
    subsl_clause = "SELECT id FROM profiles WHERE workgroup_id = '#{workgroup_id}' OR user_id IN (SELECT user_id FROM workgroup_users WHERE workgroup_id = '#{workgroup_id}')"

    # use profiles to find friendships
    ProfileFriendship.find(:all, :conditions=>["(source_profile_id IN (#{subsl_clause}))"])
  end

  # find any friendships for a profile given the list of profile ids
  def self.find_in_list_for(profile, profile_id_list)
    return ProfileFriendship.find(:all, :conditions=>["(source_profile_id = ? AND target_profile_id in (?))", profile.id, profile_id_list])
  end

  # for the given originating_profile, find the ProfileFriendship that represents the opposite (originating_profile is the target)
  def find_compliment_friendship(originating_profile, target_profile)
    # should be maximum of one profile_friendship for the opposite
    ProfileFriendship.find(:first, :conditions=>["(target_profile_id = ? AND source_profile_id = ?)", originating_profile.id, target_profile.id])
  end

  def source_profile?(profile)
    return true if self.source_profile_id == profile.id
    return false
  end

  def target_profile?(profile)
    return true if self.target_profile_id == profile.id
    return false
  end

  def originating_profile?(profile)
    return true if self.created_by_profile_id == self.source_profile_id
  end

  # Note: no longer needed
  # def profile_that_is_not(profile)
  #   return self.target_profile if source_profile?(profile)
  #   return self.source_profile
  # end

  #
  # Friendship blocking (aka "suspend") support
  #

  # returns true if the source_profile is being blocked by the target
  def source_blocked?
    return (!self.blocked_by_target_at.nil?)
  end

  # returns true if the target_profile is being blocked by the source
  def target_blocked?
    return (!self.blocked_by_source_at.nil?)
  end

  # marks the friendship as blocked by the source_profile
  #
  # NOTE: You will need to use find_compliment_friendship and call block! on that instead
  #       if you wish to mark the target as blocking the source - this defaults to source blocking the target
  def block!
    self.blocked_by_source_at = Time.now
    self.save!
    # now, mark the compliment friendship as blocked by this profile
    compliment_friendship = find_compliment_friendship(self.source_profile, self.target_profile)
    compliment_friendship.blocked_by_target_at = Time.now
    compliment_friendship.save!
  end

  # marks the friendship as no longer blocked by the profile
  # NOTE: You will need to use find_compliment_friendship and call open! on that instead
  #       if you wish to mark the target as open to the source - this defaults to source opening the target
  def open!
    self.blocked_by_source_at = nil
    self.save!
    # now, mark the compliment friendship as open by this profile
    compliment_friendship = find_compliment_friendship(self.source_profile, self.target_profile)
    compliment_friendship.blocked_by_target_at = nil
    compliment_friendship.save!
  end

end
