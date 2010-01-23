require File.dirname(__FILE__) + '/../test_helper'

class WorkgroupStateTest < ActiveSupport::TestCase
  def test_active_deactivated
    state = WorkgroupState.find('active')
    assert state.active?
    assert !state.deactivated?

    state = WorkgroupState.find('deactivated')
    assert !state.active?
    assert state.deactivated?

    state = WorkgroupState.new
    state.id = "limbo"
    assert !state.active?
    assert !state.deactivated?
  end
end
