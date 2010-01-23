#
# Tags are used to track a variety of profile and referral data. A Tag has a TagType and may belong to a parent Tag.
#
#
# Profile tag examples include: education, specialities/sub-specialties, insurance carriers/plans, etc.
#
#
#
class Tag < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :tag_type
  belongs_to :parent_tag, :class_name=>"Tag"
  validates_presence_of :tag_type

  has_many :tag_views
  has_many :tag_logos
  has_many :tag_sponsors

  def self.find_tags_for_type(tag_type_id)
    Tag.find :all, :conditions => [ 'tag_type_id = ?', tag_type_id ], :order => 'name'
  end

  def self.find_child_tags_for_tag(tag_id)
    Tag.find :all, :conditions => [ 'parent_tag_id = ?', tag_id ], :order => 'name'
  end

  def display_name
    if parent_tag.nil?
      return self.name
    end
    return "#{parent_tag.name}: #{self.name}"
  end

  def has_contact_details?
    return (!self.contact_details.nil?)
  end

  def has_sponsors?
    return (!self.tag_sponsors.empty?)
  end

  def find_sponsors
    return tag_sponsors.find(:all, :order=>"id DESC")
  end
end
