#
# Further identifies a Workgroup type.
#
# Currently for Three45 internal use only.
#
#
#
class WorkgroupSubtype < ActiveRecord::Base
  uses_guid

  belongs_to :workgroup_type
  validates_presence_of :workgroup_type

  has_many :workgroups
end
