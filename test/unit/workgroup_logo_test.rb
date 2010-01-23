require File.dirname(__FILE__) + '/../test_helper'

class WorkgroupLogoTest < ActiveSupport::TestCase

  def test_fixtures_should_load
    assert WorkgroupLogo.count > 0
  end

  def test_each_has_workgroup
    WorkgroupLogo.find( :all ).each do |w|
      assert w.workgroup
    end
  end
end
