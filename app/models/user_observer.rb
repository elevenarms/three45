#
# A model observer that watches for user create/update events and updates any
# associated profile display names.
#
#
#
class UserObserver < ActiveRecord::Observer

  # update the display name of any associated profiles (typically only 1 profile for a user)
  def after_save(user)
    profiles = Profile.find_all_for_user(user)
    profiles.each do |profile|
      profile.set_display_name
      profile.save
    end
  end

end
