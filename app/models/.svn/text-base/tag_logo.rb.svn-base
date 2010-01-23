#
# Identifies a logo to display when viewing a tag and any associated profiles
#
#
#
class TagLogo < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :tag
  validates_presence_of :tag
end
