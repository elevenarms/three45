#
# Tracks a user click for a specific TagSponsor
#
#
#
class TagSponsorClick < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :tag_sponsor
  validates_presence_of :tag_sponsor
end
