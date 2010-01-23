#
# Every AuditLog has an associated category. See the model fixtures for the audit categories
# current supported.
#
# = Steps for adding a new audit category
#
#   1. Create a migration to insert the category(s) - see db/migrate/003_create_audit_categories.rb
#   2. Create constant(s) for better code style - see app/models/audit_category_constants.rb
#   3. Create a test fixture to ensure that tests will work - see test/fixtures/audit_categories.yml
#   4. Add the call to the controller where appropriate
#   5. Add functional test to assert that the audit log has been created
#      (to debug, comment out the rescue and log lines from lib/audit_system.rb to force the exception to be thrown by the test,
#      otherwise it will be logged and the test will continue)
#
class AuditCategory < ActiveRecord::Base
  uses_guid
  include AuditCategoryConstants
end
