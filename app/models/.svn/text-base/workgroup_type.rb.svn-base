#
# Identifies the type of Workgroup.
#
# Currently for Three45 internal use only.
#
#
#
class WorkgroupType < ActiveRecord::Base
  uses_guid

  has_many :workgroup_subtypes
  has_many :workgroups

  def ppw?
    return self.id == "ppw"
  end

  def apw?
    return self.id == "apw"
  end
end
