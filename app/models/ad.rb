#
# Represents an Ad that should be displayed for a specific workgroup (i.e. targeted ads).
#
# Support for generic ads can be added in the future - see AdSystem.
#
#
class Ad < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
  has_many :ad_views
  has_many :ad_clicks

  def self.find_ad_for_workgroup(workgroup_id)
    return Ad.find(:first, :conditions=>["workgroup_id = ?", workgroup_id])
  end
end
