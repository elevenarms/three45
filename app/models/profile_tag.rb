#
# Associates a specific Tag to a Profile, for display and searching.
#
#
#
class ProfileTag < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :tag_type
  belongs_to :tag
  belongs_to :profile
end
