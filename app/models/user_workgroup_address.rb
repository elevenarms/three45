#
# Associates an Address to either a User or Workgroup, allowing both the Address of a workgroup and
# any associated Users to be tracked (for physicians that operate at a locate separate from their Workgroup's office).
#
#
#
class UserWorkgroupAddress < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
end
