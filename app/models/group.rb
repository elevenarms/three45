#
# Represents an ACL group that users may be assigned to and used to determine
# authorization to various areas of the system.
#
#
#
class Group < ActiveRecord::Base
  uses_guid
  belongs_to :workgroup_type
  has_many :group_roles

  # loads the full list of groups, including the type and group_roles
  def self.load_all_deep
    self.find(:all, :include=>[:workgroup_type, :group_roles])
  end
end
