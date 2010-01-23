#
# Marks a profile as blocked by the from_profile
#
#
#
class ProfileBlockedFriendship < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :from_profile, :class_name => 'Profile', :foreign_key => 'from_profile_id'
  belongs_to :to_profile,   :class_name => 'Profile', :foreign_key => 'to_profile_id'

  def from_profile?(profile)
    return true if self.from_profile_id == profile.id
    return false
  end

  def to_profile?(profile)
    return true if self.to_profile_id == profile.id
    return false
  end
end
