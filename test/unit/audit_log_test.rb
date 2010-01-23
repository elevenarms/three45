require File.dirname(__FILE__) + '/../test_helper'

class AuditLogTest < ActiveSupport::TestCase
  include AuditCategoryConstants

  def test_should_create_minimal_data
    log = AuditLog.create!({ :audit_category_id=> USER_LOGIN, :description=>"Fake audit log entry"})
  end

  def test_should_fail_without_category
    log = AuditLog.new({ :description=>"Fake audit log entry"})
    assert !log.valid?
  end

end
