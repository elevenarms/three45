require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < ActiveSupport::TestCase
  def test_fixtures_loaded
    assert Group.count > 0
  end

  def test_workgroup_type_relationship
    group = groups(:ppw_physician_user)
    assert_not_nil group.workgroup_type
    assert group.workgroup_type.ppw?

    group = groups(:apw_proxy)
    assert_not_nil group.workgroup_type
    assert group.workgroup_type.apw?
  end

  def test_load_all_deep
    all_groups = Group.load_all_deep
    assert all_groups.length > 0
  end
end
