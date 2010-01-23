ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  include AuthenticatedTestHelper
  fixtures :audit_categories, :audit_logs, :users
  fixtures :tag_types, :tags, :tag_views, :tag_logos, :tag_sponsors, :tag_sponsor_clicks
  fixtures :workgroup_types, :groups, :roles, :group_roles, :user_groups, :workgroups, :workgroup_states
  fixtures :addresses, :address_types, :workgroup_addresses, :workgroup_logos
  fixtures :workgroup_users, :workgroup_subtypes
  fixtures :profile_types, :profiles, :profile_tags, :profile_friendships, :profile_blocked_friendships

  # referral mgmt fixtures
  fixtures :referral_states, :referral_source_states, :referral_target_states
  fixtures :referral_message_types, :referral_message_subtypes, :referral_message_states, :referral_messages, :referral_message_subtype_selections
  fixtures :referral_type_selections, :referral_studies, :referral_diagnosis_selections
  fixtures :mime_types, :referral_file_types
  fixtures :icd9_codes, :cpt_codes
  fixtures :referrals, :referral_sources, :referral_targets, :referral_patients, :referral_insurance_plans
  fixtures :referral_files
  fixtures :referral_fax_states, :referral_faxes
  fixtures :dashboard_filters
  fixtures :ads

  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
end
