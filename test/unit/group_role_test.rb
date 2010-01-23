require File.dirname(__FILE__) + '/../test_helper'

class GroupRoleTest < ActiveSupport::TestCase
  def test_fixtures_loaded
    assert GroupRole.count > 0
  end

  def test_group_relationship
    group_role = group_roles(:apw_admin_manage_physician_profiles)
    assert_not_nil group_role.role
    assert_not_nil group_role.group
  end

  def test_load_all_deep
    assert GroupRole.load_all_deep.length > 0
  end
end
