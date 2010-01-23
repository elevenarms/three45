require File.dirname(__FILE__) + '/../test_helper'

class WorkgroupTest < ActiveSupport::TestCase

  def test_fixtures_should_load
    assert Workgroup.count > 0
  end

  def test_subdomains_should_exist
    assert Workgroup.find( :first, :conditions => [ 'subdomain = ?', 'mccoy' ] )
    assert Workgroup.find( :first, :conditions => [ 'subdomain = ?', 'kildare' ] )
    assert Workgroup.find( :first, :conditions => [ 'subdomain = ?', 'welby' ] )

    assert_nil Workgroup.find( :first, :conditions => [ 'subdomain = ?', 'casey' ] )
  end

  def test_each_has_type
    Workgroup.find( :all ).each do |w|
      assert w.workgroup_type
    end
  end

  def test_each_has_subtype
    Workgroup.find( :all ).each do |w|
      assert w.workgroup_subtype
    end
  end

  def test_each_has_state
    Workgroup.find( :all ).each do |w|
      assert w.workgroup_state
    end
  end

  def test_has_users
    Workgroup.find( :all, :conditions => [ 'subdomain = ?', 'mccoy' ] ).each do |w|
      assert w.workgroup_users.count > 0
    end
  end

  def test_has_addresses
    Workgroup.find( :all, :conditions => [ 'subdomain = ?', 'kildare' ] ).each do |w|
      assert w.workgroup_addresses.count > 0
    end
  end

  def test_has_profiles
    Workgroup.find( :all, :conditions => [ 'subdomain = ?', 'austin_chiropractic' ] ).each do |w|
      assert w.profiles.count > 0
    end
  end

  def test_is_member
    assert WorkgroupUser.count > 0
    assert workgroups(:workgroup_mccoy).is_member?(users(:quentin))
    assert !workgroups(:workgroup_mccoy).is_member?(users(:aaron))
    assert workgroups(:workgroup_kildare).is_member?(users(:dr_gillespie))
    assert !workgroups(:workgroup_kildare).is_member?(users(:quentin))
  end

  def test_subscriber
    assert workgroups(:workgroup_mccoy).subscriber?
    assert !workgroups(:workgroup_nonsub).subscriber?
  end

  def test_allowed_to_sign_and_send_for_workgroup_that_allows_anyone
    assert workgroups(:workgroup_mccoy).anyone_can_sign_referral_flag == true
    assert workgroups(:workgroup_mccoy).allowed_to_sign_and_send?(users(:quentin))
    assert !workgroups(:workgroup_mccoy).allowed_to_sign_and_send?(users(:aaron))
    quentin_the_ppw_physician = user_groups(:quentin_the_ppw_physician)
    quentin_the_ppw_physician.group_id = "ppw_admin"
    quentin_the_ppw_physician.save!
    users(:quentin).reload
    assert workgroups(:workgroup_mccoy).allowed_to_sign_and_send?(users(:quentin))
  end

  def test_allowed_to_sign_and_send_for_workgroup_that_requires_physician
    mccoy = workgroups(:workgroup_mccoy)
    mccoy.anyone_can_sign_referral_flag = false
    mccoy.save!
    assert workgroups(:workgroup_mccoy).anyone_can_sign_referral_flag == false
    assert workgroups(:workgroup_mccoy).allowed_to_sign_and_send?(users(:quentin))
    assert !workgroups(:workgroup_mccoy).allowed_to_sign_and_send?(users(:aaron))
    quentin_the_ppw_physician = user_groups(:quentin_the_ppw_physician)
    quentin_the_ppw_physician.group_id = "ppw_admin"
    quentin_the_ppw_physician.save!
    users(:quentin).reload
    assert !workgroups(:workgroup_mccoy).allowed_to_sign_and_send?(users(:quentin))
  end
end
