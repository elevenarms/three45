require File.dirname(__FILE__) + '/../test_helper'

class UserObserverTest < Test::Unit::TestCase

  def test_display_name_generation_for_updated_user
    profile = profiles(:profile_quentin)
    quentin = users(:quentin)

    # change the last name and expect the profile display name to be updated
    quentin.last_name = "Changed"
    quentin.save

    updated_profile = Profile.find(profile.id)
    assert_equal quentin.full_name, updated_profile.display_name
  end

end
