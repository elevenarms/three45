require File.dirname(__FILE__) + '/../test_helper'

class ReferralSourceStateTest < ActiveSupport::TestCase
  def test_fixtures_loaded
    assert ReferralSourceState.count > 0
  end
end
