#
# Stores a physical address, typically for a workgroup via the WorkgroupAddress model
#
#
#
class Address < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  has_many :workgroup_addresses

  def zip_plus_4
    return "#{self.zip_code}-#{self.plus_four_code}" unless self.plus_four_code.nil?
    return "#{self.zip_code}"
  end
end
