#
# Tracks views of a specific tag page by a user. Allows the tracking of popular tags for
# later features, along with tracking tag interests by user.
#
#
#
class TagView < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :tag
  validates_presence_of :tag
end
