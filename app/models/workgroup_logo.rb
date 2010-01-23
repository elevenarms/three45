#
# Stores a logo for a Workgroup
#
#
#
class WorkgroupLogo < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :workgroup
  validates_presence_of :workgroup
end
