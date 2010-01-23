#
# Sponsors for a tag used in tag-specific advertising (separate from the Ad model).
#
#
#
class TagSponsor < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :tag
  validates_presence_of :tag

  has_many :tag_sponsor_clicks

  def has_link_url?
    return (!self.link_url.nil? and !self.link_url.empty?)
  end
end
