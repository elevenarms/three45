#
# A profile is a representation of a user or workgroup within the Three45 network. If a profile
# does not exist for a user or workgroup, they will not appear within the network search screen or
# within the create profile/request referral screens.
#
#
#
class Profile < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :profile_type
  belongs_to :user
  belongs_to :workgroup

  has_many :profile_tags
  has_many :profile_images, :order=>"created_at DESC"

  has_many :source_profile_friendships, :foreign_key=>"source_profile_id", :class_name=>"ProfileFriendship"

  before_create :set_display_name

  def self.find_all_for_user(user)
    return Profile.find(:all, :conditions=>["user_id = ?",user.id])
  end

  def self.find_all_for_workgroup(workgroup)
    return Profile.find(:all, :conditions=>["workgroup_id = ?",workgroup.id])
  end

  def self.find_all_profiles_for_workgroup(workgroup)
    # First, get the workgroup profile
    workgroup_profiles = Profile.find(:all, :conditions=>["workgroup_id = ?",workgroup.id], :order=>"display_name")
    # Next, get all user profiles
    user_profiles = Profile.find(:all, :include=>[{ :user => :workgroup_user}], :conditions=>["workgroup_users.workgroup_id = ?",workgroup.id], :order=>"display_name")
    # concat the results, with the workgroup at the top
    return workgroup_profiles + user_profiles
  end

  def self.find_by_tag(profile_to_exclude, tag_id, number_to_fetch=10, offset=nil)
    count = Profile.count('id', :conditions=>["profiles.id != ? AND profile_tags.tag_id = ?", profile_to_exclude.id, tag_id], :include=>:profile_tags)

    profiles = Profile.find(:all, :conditions=>["profiles.id != ? AND profile_tags.tag_id = ?", profile_to_exclude.id, tag_id], :order=>"profile_friendships.id ASC", :include=>[:profile_tags,:source_profile_friendships], :limit=>number_to_fetch, :offset=>offset)

    total_pages = (count / number_to_fetch)
    total_pages += 1 if (count % number_to_fetch) != 0

    return profiles, total_pages
  end

  def user_profile?
    return self.profile_type.id == 'user'
  end

  def workgroup_profile?
    return self.profile_type.id == 'workgroup'
  end

  # loads 1) the workgroup that this profile represents or 2) the workgroup for the user that this profile represents
  def load_member_workgroup
    return self.workgroup if !self.workgroup.nil?
    return WorkgroupUser.default_workgroup_for_user(self.user)
  end

  # filters the profile's tags based on the type_id
  def tags_for_type(type_id)
    tags = Array.new
    profile_tags.each do |pt|
      if pt.tag_type and (pt.tag_type.id == type_id.to_s)
        tags << pt.tag
      end
    end
    return tags
  end

  # filters the profile's tags based on the type_id and parent_tag_id
  # (e.g. finding insurance plans for a carrier assoc to the profile)
  def tags_for_type_with_parent(type_id, parent_tag_id)
    tags = Array.new
    profile_tags.each do |pt|
      if pt.tag_type and (pt.tag_type.id == type_id.to_s) and (pt.tag.parent_tag_id == parent_tag_id)
        tags << pt.tag
      end
    end
    return tags
  end

  # search the list of tags and find by id (use only when the profile_tags collection is eager loaded)
  def profile_tag_by_id(tag_id)
    profile_tags.each do |pt|
      return pt if pt.tag_id == tag_id
    end
    return nil
  end

  def set_display_name
    self.display_name = user.full_name if self.user_profile?
    self.display_name = workgroup.name if self.workgroup_profile?
  end

  def find_thumbnails
    # TODO: may want to change this condition to limit to a specific size thumbnail, if we decide to create
    #       multiple sized thumbnails
    return self.profile_images.find(:all, :conditions=>["parent_id IS NOT NULL"])
  end

  #
  # Display helpers
  #

  def display_email
    # TODO: Add email display support, depending on how the setup screens are spec'ed
    return self.user.email if user_profile?
    return "TODO: Add email to workgroup"
    return self.workgroup.email
  end

  def display_primary_phone
    # TODO: Add phone number display support, depending on how the setup screens are spec'ed
    return "TODO: phone number on user" if user_profile?
    return self.user.primary_phone if user_profile?
    return "TODO: phone number on workgroup"
  end


end
