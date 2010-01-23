#
# Tracks an Ad impression for an Ad by a specific User.
#
#
#
class AdView < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
  belongs_to :ad
  belongs_to :user
end
