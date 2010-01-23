#
# Associates an Address to a Workgroup and assigns a specific type of address represented.
#
#
#
class WorkgroupAddress < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :workgroup
  validates_presence_of :workgroup

  belongs_to :address
  validates_presence_of :address

  belongs_to :address_type
  validates_presence_of :address_type

  has_many :user_workgroup_addresses
end
