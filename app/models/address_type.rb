#
# The type of address, typically 'billing' or 'office' (see the model fixtures)
#
#
#
class AddressType < ActiveRecord::Base
  uses_guid

  has_many :workgroup_addresses
end
