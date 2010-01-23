require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < ActiveSupport::TestCase
  def test_fixtures_loaded
    assert Role.count > 0
  end
end
