#
# Provides a grouping for Tags. TagTypes may have a parent TagType (e.g. Insurance Carriers and Insurance Carrier Plans)
#
#
#
class TagType < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  has_many :tags

  def self.find_all_with_exclusions(exclude_id_array)
#    conditions = (exclude_id_array.nil? or exclude_id_array.empty?) ? nil : ["id in (?)", exclude_id_array]
    conditions = (exclude_id_array.nil? or exclude_id_array.empty?) ? "parent_tag_type_id IS NULL" : ["parent_tag_type_id IS NULL AND id in (?)", exclude_id_array]
    return TagType.find(:all, :conditions=>conditions, :order=>"name")
  end
end
