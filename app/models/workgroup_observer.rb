#
# An ActiveRecord observer that updates the display name of any associated profiles for the workgroup
# (typically only 1 profile per workgroup).
#
#
#
class WorkgroupObserver < ActiveRecord::Observer

  # update the display name of any associated profiles (typically only 1 profile for a workgroup)
  def after_save(workgroup)
    profiles = Profile.find_all_for_workgroup(workgroup)
    profiles.each do |profile|
      profile.set_display_name
      profile.save
    end
  end

end
