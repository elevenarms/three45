#
# Tracks an impression for a TagSponsor, including the User that received the impression
#
#
#
class TagSponsorView < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
end
