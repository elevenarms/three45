require File.dirname(__FILE__) + '/../test_helper'

class WorkgroupUserTest < ActiveSupport::TestCase

  def test_fixtures_should_load
    assert WorkgroupUser.count > 0
  end

  def test_each_has_workgroup
    WorkgroupUser.find( :all ).each do |w|
      assert w.workgroup
    end
  end

  def test_each_has_user
    WorkgroupUser.find( :all ).each do |w|
      assert w.user
    end
  end
end
