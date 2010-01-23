require File.dirname(__FILE__) + '/../test_helper'

class WorkgroupAddressTest < ActiveSupport::TestCase

  def test_fixtures_should_load
    assert WorkgroupAddress.count > 0
  end

  def test_each_has_workgroup
    WorkgroupAddress.find( :all ).each do |w|
      assert w.workgroup
    end
  end

  def test_each_has_address
    WorkgroupAddress.find( :all ).each do |w|
      assert w.address
    end
  end

  def test_each_has_address_type
    WorkgroupAddress.find( :all ).each do |w|
      assert w.address_type
    end
  end
end
