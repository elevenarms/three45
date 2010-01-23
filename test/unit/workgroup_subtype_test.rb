require File.dirname(__FILE__) + '/../test_helper'

class WorkgroupSubtypeTest < ActiveSupport::TestCase

  def test_fixtures_should_load
    assert WorkgroupSubtype.count > 0
  end

  def test_each_has_workgroup_type
    WorkgroupSubtype.find( :all ).each do |w|
      assert w.workgroup_type
    end
  end
end
