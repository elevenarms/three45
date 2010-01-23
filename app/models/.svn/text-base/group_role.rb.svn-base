#
# Provides a list of default roles that are assigned to a user that belongs to the group.
# Currently unused.
#
#
#
class GroupRole < ActiveRecord::Base
  uses_guid
  belongs_to :group
  belongs_to :role

  # loads all group_roles including the group and role relationships
  def self.load_all_deep
    find(:all, :include=>[:group, :role])
  end
end
