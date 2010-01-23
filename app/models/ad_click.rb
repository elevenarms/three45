#
# Tracks the user click for an Ad by a specific User.
#
#
#
class AdClick < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
  belongs_to :ad
  belongs_to :user
end
