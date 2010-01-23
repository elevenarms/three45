require File.dirname(__FILE__) + '/../test_helper'

class WorkgroupObserverTest < Test::Unit::TestCase

  def test_display_name_generation_for_updated_workgroup
    profile = profiles(:profile_workgroup_chiro)
    chiro = workgroups(:workgroup_chiro)

    # change the name and expect the profile display name to be updated
    chiro.name = "Changed"
    chiro.save

    updated_profile = Profile.find(profile.id)
    assert_equal chiro.name, updated_profile.display_name
  end

end
