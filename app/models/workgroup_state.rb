#
# Assigns the state of a Workgroup to active or deactivated.
#
# Currently not used.
#
#
#
class WorkgroupState < ActiveRecord::Base
  uses_guid

  has_many :workgroups

  def active?
    return self.id == "active"
  end

  def deactivated?
    return self.id == "deactivated"
  end
end
