require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase

  def test_set_notify_email
    profile = Profile.new({:profile_type=>profile_types(:user), :user=>users(:horace_quinn_mann)})
    assert_nil profile.notify_email
    profile.notify_email = "b@b.com"
    profile.save
    assert_not_nil profile.notify_email
    assert_equal profile.notify_email, "b@b.com"
  end
  
  def test_get_notify_email
    profile = profiles(:dr_gillespie)
    assert_not_nil profile.notify_email
    profile.notify_email = nil
    assert_nil profile.notify_emal
  end
  
  def test_default_display_name_generation_for_workgroup
    profile = Profile.new({ :profile_type=>profile_types(:workgroup), :workgroup=>workgroups(:workgroup_chiro)})
    assert_nil profile.display_name
    profile.save
    assert_not_nil profile.display_name
    assert_equal workgroups(:workgroup_chiro).name, profile.display_name
  end

  def test_default_display_name_generation_for_user
    profile = Profile.new({ :profile_type=>profile_types(:user), :user=>users(:quentin)})
    assert_nil profile.display_name
    profile.save
    assert_not_nil profile.display_name
    assert_equal users(:quentin).full_name, profile.display_name
  end

  def test_load_member_workgroup_should_load_for_workgroup_profile_type
    chiro = profiles(:profile_workgroup_chiro)
    workgroup = chiro.load_member_workgroup
    assert_equal workgroups(:workgroup_chiro).id, workgroup.id
  end

  def test_load_member_workgroup_should_load_for_user_profile_type
    quentin = profiles(:profile_quentin)
    workgroup = quentin.load_member_workgroup
    assert_equal workgroups(:workgroup_mccoy).id, workgroup.id
  end

  def test_tags_for_type_should_filter_by_type
    quentin = profiles(:profile_quentin)
    specialty_tags = quentin.tags_for_type(:specialties)
    assert_not_nil specialty_tags
    assert_equal 1, specialty_tags.length
    assert_equal tags(:tag_specialty_ontology).id, specialty_tags.first.id

    fake_specialty_tags = quentin.tags_for_type(:fake_tag_type)
    assert_not_nil fake_specialty_tags
    assert_equal 0, fake_specialty_tags.length
  end

  def test_find_by_tag_should_exclude_self
    quentin = profiles(:profile_quentin)
    tag = tags(:tag_specialty_ontology)
    profiles, total_pages = Profile.find_by_tag(quentin, tag.id)
    assert_not_nil profiles
    assert_equal 1, profiles.length
  end
end
