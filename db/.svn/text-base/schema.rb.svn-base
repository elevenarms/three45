# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 98) do

  create_table "address_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.string   "street1",        :null => false
    t.string   "street2"
    t.string   "city",           :null => false
    t.string   "state",          :null => false
    t.string   "latlng"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zip_code"
    t.string   "plus_four_code"
  end

  create_table "audit_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audit_logs", :force => true do |t|
    t.string   "audit_category_id", :limit => 36, :null => false
    t.string   "description"
    t.string   "billing_group_id",  :limit => 36
    t.string   "user_id",           :limit => 36
    t.string   "profile_id",        :limit => 36
    t.string   "referral_id",       :limit => 36
    t.string   "session_id"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "audit_logs", ["audit_category_id"], :name => "audit_category_id"

  create_table "cpt_codes", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "dashboard_filters", :force => true do |t|
    t.string   "user_id"
    t.string   "filter_direction"
    t.string   "filter_owner"
    t.string   "filter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dashboard_filters", ["user_id"], :name => "user_id"

  create_table "group_roles", :force => true do |t|
    t.string   "group_id",   :limit => 36, :null => false
    t.string   "role_id",    :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_roles", ["group_id"], :name => "group_id"
  add_index "group_roles", ["role_id"], :name => "role_id"

  create_table "groups", :force => true do |t|
    t.string   "workgroup_type_id", :limit => 36, :null => false
    t.string   "name",                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["workgroup_type_id"], :name => "workgroup_type_id"

  create_table "icd9_codes", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "mime_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "profile_blocked_friendships", :force => true do |t|
    t.string   "source_profile_id", :limit => 36, :null => false
    t.string   "target_profile_id", :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "profile_blocked_friendships", ["source_profile_id"], :name => "source_profile_id"
  add_index "profile_blocked_friendships", ["target_profile_id"], :name => "target_profile_id"

  create_table "profile_friendships", :force => true do |t|
    t.string   "source_profile_id",     :limit => 36, :null => false
    t.string   "target_profile_id",     :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.datetime "blocked_by_source_at"
    t.datetime "blocked_by_target_at"
    t.string   "created_by_profile_id", :limit => 36
  end

  add_index "profile_friendships", ["source_profile_id"], :name => "source_profile_id"
  add_index "profile_friendships", ["target_profile_id"], :name => "target_profile_id"
  add_index "profile_friendships", ["created_by_profile_id"], :name => "created_by_profile_id"

  create_table "profile_images", :force => true do |t|
    t.string   "profile_id",   :limit => 36, :null => false
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.string   "parent_id",    :limit => 36
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "profile_images", ["profile_id"], :name => "profile_id"

  create_table "profile_tags", :force => true do |t|
    t.string   "profile_id",  :limit => 36, :null => false
    t.string   "tag_type_id", :limit => 36, :null => false
    t.string   "tag_id",      :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "profile_tags", ["profile_id"], :name => "profile_id"
  add_index "profile_tags", ["tag_type_id"], :name => "tag_type_id"
  add_index "profile_tags", ["tag_id"], :name => "tag_id"

  create_table "profile_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "profile_type_id", :limit => 36, :null => false
    t.string   "display_name",                  :null => false
    t.string   "user_id",         :limit => 36
    t.string   "workgroup_id",    :limit => 36
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text     "description"
  end

  add_index "profiles", ["profile_type_id"], :name => "profile_type_id"
  add_index "profiles", ["user_id"], :name => "user_id"
  add_index "profiles", ["workgroup_id"], :name => "workgroup_id"

  create_table "referral_diagnosis_selections", :force => true do |t|
    t.string   "referral_id", :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "tag_type_id", :limit => 36
    t.string   "tag_id",      :limit => 36
  end

  add_index "referral_diagnosis_selections", ["referral_id"], :name => "referral_id"
  add_index "referral_diagnosis_selections", ["tag_type_id"], :name => "tag_type_id"
  add_index "referral_diagnosis_selections", ["tag_id"], :name => "tag_id"

  create_table "referral_fax_content_selections", :force => true do |t|
    t.string   "referral_fax_id", :limit => 36, :null => false
    t.string   "tag_id",          :limit => 36, :null => false
    t.string   "other_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "referral_fax_content_selections", ["referral_fax_id"], :name => "referral_fax_id"
  add_index "referral_fax_content_selections", ["tag_id"], :name => "tag_id"

  create_table "referral_fax_files", :force => true do |t|
    t.string   "referral_id",     :limit => 36, :null => false
    t.string   "referral_fax_id", :limit => 36, :null => false
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.string   "parent_id",       :limit => 36
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "referral_fax_files", ["referral_id"], :name => "referral_id"
  add_index "referral_fax_files", ["referral_fax_id"], :name => "referral_fax_id"

  create_table "referral_fax_states", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "referral_faxes", :force => true do |t|
    t.string   "referral_id",           :limit => 36, :null => false
    t.string   "referral_fax_state_id", :limit => 36, :null => false
    t.integer  "page_count"
    t.string   "comments"
    t.string   "filename"
    t.text     "error_details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "referral_message_id",   :limit => 36
  end

  add_index "referral_faxes", ["referral_id"], :name => "referral_id"
  add_index "referral_faxes", ["referral_fax_state_id"], :name => "referral_fax_state_id"
  add_index "referral_faxes", ["referral_message_id"], :name => "referral_message_id"

  create_table "referral_file_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "referral_files", :force => true do |t|
    t.string   "referral_id",           :limit => 36, :null => false
    t.string   "referral_file_type_id", :limit => 36, :null => false
    t.string   "mime_type_id",          :limit => 36, :null => false
    t.string   "description"
    t.date     "reference_date"
    t.string   "comment_text"
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.string   "parent_id",             :limit => 36
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "referral_message_id",   :limit => 36
  end

  add_index "referral_files", ["referral_id"], :name => "referral_id"
  add_index "referral_files", ["referral_file_type_id"], :name => "referral_file_type_id"
  add_index "referral_files", ["mime_type_id"], :name => "mime_type_id"
  add_index "referral_files", ["referral_message_id"], :name => "referral_message_id"

  create_table "referral_insurance_plans", :force => true do |t|
    t.string   "referral_id",                   :limit => 36, :null => false
    t.string   "insurance_carrier_tag_id",      :limit => 36
    t.string   "insurance_carrier_plan_tag_id", :limit => 36
    t.string   "policy_details"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referral_insurance_plans", ["referral_id"], :name => "referral_id"
  add_index "referral_insurance_plans", ["insurance_carrier_tag_id"], :name => "insurance_carrier_tag_id"
  add_index "referral_insurance_plans", ["insurance_carrier_plan_tag_id"], :name => "insurance_carrier_plan_tag_id"

  create_table "referral_message_states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referral_message_subtype_selections", :force => true do |t|
    t.string   "referral_id",                 :limit => 36, :null => false
    t.string   "referral_message_id",         :limit => 36, :null => false
    t.string   "referral_message_subtype_id", :limit => 36, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "referral_message_subtype_selections", ["referral_id"], :name => "referral_id"
  add_index "referral_message_subtype_selections", ["referral_message_id"], :name => "referral_message_id"
  add_index "referral_message_subtype_selections", ["referral_message_subtype_id"], :name => "referral_message_subtype_id"

  create_table "referral_message_subtypes", :force => true do |t|
    t.string   "referral_message_type_id", :limit => 36, :null => false
    t.string   "name",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "referral_message_subtypes", ["referral_message_type_id"], :name => "referral_message_type_id"

  create_table "referral_message_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "referral_messages", :force => true do |t|
    t.string   "referral_id",                  :limit => 36, :null => false
    t.string   "referral_message_type_id",     :limit => 36, :null => false
    t.text     "message_text"
    t.datetime "response_required_by"
    t.datetime "responded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "referral_source_or_target_id", :limit => 36
    t.string   "referral_message_state_id"
    t.string   "subject"
    t.string   "reply_to_message_id"
    t.string   "created_by_user_id"
    t.datetime "viewed_at"
  end

  add_index "referral_messages", ["referral_id"], :name => "referral_id"
  add_index "referral_messages", ["referral_message_type_id"], :name => "referral_message_type_id"
  add_index "referral_messages", ["referral_message_state_id"], :name => "referral_message_state_id"
  add_index "referral_messages", ["reply_to_message_id"], :name => "reply_to_message_id"
  add_index "referral_messages", ["created_by_user_id"], :name => "created_by_user_id"

  create_table "referral_patients", :force => true do |t|
    t.string   "referral_id", :limit => 36, :null => false
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "ssn"
    t.date     "dob"
    t.string   "gender",      :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "phone"
    t.string   "email"
  end

  add_index "referral_patients", ["referral_id"], :name => "referral_id"

  create_table "referral_reasons", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "referral_source_states", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "referral_sources", :force => true do |t|
    t.string   "referral_id",              :limit => 36, :null => false
    t.string   "referral_source_state_id", :limit => 36, :null => false
    t.string   "workgroup_id",             :limit => 36, :null => false
    t.string   "user_id",                  :limit => 36
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "referral_sources", ["referral_id"], :name => "referral_id"
  add_index "referral_sources", ["referral_source_state_id"], :name => "referral_source_state_id"
  add_index "referral_sources", ["workgroup_id"], :name => "workgroup_id"
  add_index "referral_sources", ["user_id"], :name => "user_id"

  create_table "referral_states", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "referral_studies", :force => true do |t|
    t.string   "referral_id",            :limit => 36, :null => false
    t.string   "study_type_tag_id",      :limit => 36, :null => false
    t.string   "location_tag_id",        :limit => 36, :null => false
    t.string   "location_detail_tag_id", :limit => 36, :null => false
    t.text     "additional_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "study_modality_tag_id",  :limit => 36
    t.string   "body_part"
  end

  add_index "referral_studies", ["referral_id"], :name => "referral_id"
  add_index "referral_studies", ["study_type_tag_id"], :name => "study_type_tag_id"
  add_index "referral_studies", ["location_tag_id"], :name => "location_tag_id"
  add_index "referral_studies", ["location_detail_tag_id"], :name => "location_detail_tag_id"
  add_index "referral_studies", ["study_modality_tag_id"], :name => "study_modality_tag_id"

  create_table "referral_target_states", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "referral_targets", :force => true do |t|
    t.string   "referral_id",              :limit => 36, :null => false
    t.string   "referral_target_state_id", :limit => 36, :null => false
    t.string   "workgroup_id",             :limit => 36, :null => false
    t.string   "user_id",                  :limit => 36
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "display_name"
  end

  add_index "referral_targets", ["referral_id"], :name => "referral_id"
  add_index "referral_targets", ["referral_target_state_id"], :name => "referral_target_state_id"
  add_index "referral_targets", ["workgroup_id"], :name => "workgroup_id"
  add_index "referral_targets", ["user_id"], :name => "user_id"

  create_table "referral_type_selections", :force => true do |t|
    t.string   "referral_id",             :limit => 36, :null => false
    t.string   "tag_type_id",             :limit => 36, :null => false
    t.string   "tag_id",                  :limit => 36, :null => false
    t.text     "diagnosis_text"
    t.text     "additional_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "referral_type_selections", ["referral_id"], :name => "referral_id"
  add_index "referral_type_selections", ["tag_type_id"], :name => "tag_type_id"
  add_index "referral_type_selections", ["tag_id"], :name => "tag_id"

  create_table "referrals", :force => true do |t|
    t.string   "referral_state_id",  :limit => 36, :null => false
    t.string   "referral_reason_id", :limit => 36
    t.string   "cpt_code_id",        :limit => 36
    t.string   "icd9_code_id",       :limit => 36
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "created_by_user_id", :limit => 36, :null => false
    t.string   "active_source_id",   :limit => 36
    t.string   "active_target_id",   :limit => 36
    t.string   "wizard_step"
  end

  add_index "referrals", ["referral_state_id"], :name => "referral_state_id"
  add_index "referrals", ["referral_reason_id"], :name => "referral_reason_id"
  add_index "referrals", ["cpt_code_id"], :name => "cpt_code_id"
  add_index "referrals", ["icd9_code_id"], :name => "icd9_code_id"
  add_index "referrals", ["created_by_user_id"], :name => "created_by_user_id"
  add_index "referrals", ["active_source_id"], :name => "active_source_id"
  add_index "referrals", ["active_target_id"], :name => "active_target_id"

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tag_logos", :force => true do |t|
    t.string   "tag_id",     :limit => 36, :null => false
    t.string   "path"
    t.integer  "height"
    t.integer  "width"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_sponsor_clicks", :force => true do |t|
    t.string   "tag_sponsor_id", :limit => 36, :null => false
    t.string   "user_id",        :limit => 36, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_sponsor_views", :force => true do |t|
    t.string   "tag_sponsor_id", :limit => 36, :null => false
    t.string   "user_id",        :limit => 36, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_sponsors", :force => true do |t|
    t.string   "tag_id",      :limit => 36, :null => false
    t.string   "name"
    t.string   "image_path"
    t.string   "link_url"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "detail_text"
  end

  create_table "tag_types", :force => true do |t|
    t.string   "name",                             :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_details_flag"
    t.string   "parent_tag_type_id", :limit => 36
  end

  add_index "tag_types", ["parent_tag_type_id"], :name => "parent_tag_type_id"

  create_table "tag_views", :force => true do |t|
    t.string   "tag_id",     :limit => 36, :null => false
    t.string   "user_id",    :limit => 36, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "tag_type_id",     :limit => 36, :null => false
    t.string   "name",                          :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_details"
    t.text     "detail_text"
    t.string   "parent_tag_id",   :limit => 36
  end

  add_index "tags", ["parent_tag_id"], :name => "parent_tag_id"

  create_table "user_groups", :force => true do |t|
    t.string   "user_id",    :limit => 36, :null => false
    t.string   "group_id",   :limit => 36, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_groups", ["user_id"], :name => "user_id"
  add_index "user_groups", ["group_id"], :name => "group_id"

  create_table "user_workgroup_addresses", :force => true do |t|
    t.string   "workgroup_address_id", :limit => 36, :null => false
    t.string   "user_id",              :limit => 36, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "last_login_at"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "workgroup_addresses", :force => true do |t|
    t.string   "workgroup_id",    :limit => 36, :null => false
    t.string   "address_id",      :limit => 36, :null => false
    t.string   "address_type_id", :limit => 36, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workgroup_logos", :force => true do |t|
    t.string   "workgroup_id", :limit => 36, :null => false
    t.string   "path",                       :null => false
    t.integer  "height"
    t.integer  "width"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workgroup_states", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workgroup_subtypes", :force => true do |t|
    t.string   "workgroup_type_id", :limit => 36, :null => false
    t.string   "name",                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workgroup_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workgroup_users", :force => true do |t|
    t.string   "workgroup_id", :limit => 36, :null => false
    t.string   "user_id",      :limit => 36, :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workgroups", :force => true do |t|
    t.string   "workgroup_subtype_id",          :limit => 36,                   :null => false
    t.string   "workgroup_state_id",            :limit => 36,                   :null => false
    t.string   "workgroup_type_id",             :limit => 36,                   :null => false
    t.string   "name",                                                          :null => false
    t.string   "description",                                                   :null => false
    t.string   "subdomain",                                                     :null => false
    t.string   "office_number",                                                 :null => false
    t.string   "fax_number",                                                    :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "anyone_can_sign_referral_flag",               :default => true
  end

  add_foreign_key "audit_logs", ["audit_category_id"], "audit_categories", ["id"], :name => "audit_logs_ibfk_1"

  add_foreign_key "dashboard_filters", ["user_id"], "users", ["id"], :name => "dashboard_filters_ibfk_1"

  add_foreign_key "group_roles", ["group_id"], "groups", ["id"], :name => "group_roles_ibfk_1"
  add_foreign_key "group_roles", ["role_id"], "roles", ["id"], :name => "group_roles_ibfk_2"

  add_foreign_key "groups", ["workgroup_type_id"], "workgroup_types", ["id"], :name => "groups_ibfk_1"

  add_foreign_key "profile_blocked_friendships", ["source_profile_id"], "profiles", ["id"], :name => "profile_blocked_friendships_ibfk_1"
  add_foreign_key "profile_blocked_friendships", ["target_profile_id"], "profiles", ["id"], :name => "profile_blocked_friendships_ibfk_2"

  add_foreign_key "profile_friendships", ["source_profile_id"], "profiles", ["id"], :name => "profile_friendships_ibfk_1"
  add_foreign_key "profile_friendships", ["target_profile_id"], "profiles", ["id"], :name => "profile_friendships_ibfk_2"
  add_foreign_key "profile_friendships", ["created_by_profile_id"], "profiles", ["id"], :name => "profile_friendships_ibfk_3"

  add_foreign_key "profile_images", ["profile_id"], "profiles", ["id"], :name => "profile_images_ibfk_1"

  add_foreign_key "profile_tags", ["profile_id"], "profiles", ["id"], :name => "profile_tags_ibfk_1"
  add_foreign_key "profile_tags", ["tag_type_id"], "tag_types", ["id"], :name => "profile_tags_ibfk_2"
  add_foreign_key "profile_tags", ["tag_id"], "tags", ["id"], :name => "profile_tags_ibfk_3"

  add_foreign_key "profiles", ["profile_type_id"], "profile_types", ["id"], :name => "profiles_ibfk_1"
  add_foreign_key "profiles", ["user_id"], "users", ["id"], :name => "profiles_ibfk_2"
  add_foreign_key "profiles", ["workgroup_id"], "workgroups", ["id"], :name => "profiles_ibfk_3"

  add_foreign_key "referral_diagnosis_selections", ["referral_id"], "referrals", ["id"], :name => "referral_diagnosis_selections_ibfk_1"
  add_foreign_key "referral_diagnosis_selections", ["tag_type_id"], "tag_types", ["id"], :name => "referral_diagnosis_selections_ibfk_2"
  add_foreign_key "referral_diagnosis_selections", ["tag_id"], "tags", ["id"], :name => "referral_diagnosis_selections_ibfk_3"

  add_foreign_key "referral_fax_content_selections", ["referral_fax_id"], "referral_faxes", ["id"], :name => "referral_fax_content_selections_ibfk_1"
  add_foreign_key "referral_fax_content_selections", ["tag_id"], "tags", ["id"], :name => "referral_fax_content_selections_ibfk_2"

  add_foreign_key "referral_fax_files", ["referral_id"], "referrals", ["id"], :name => "referral_fax_files_ibfk_1"
  add_foreign_key "referral_fax_files", ["referral_fax_id"], "referral_faxes", ["id"], :name => "referral_fax_files_ibfk_2"

  add_foreign_key "referral_faxes", ["referral_id"], "referrals", ["id"], :name => "referral_faxes_ibfk_1"
  add_foreign_key "referral_faxes", ["referral_fax_state_id"], "referral_fax_states", ["id"], :name => "referral_faxes_ibfk_2"
  add_foreign_key "referral_faxes", ["referral_message_id"], "referral_messages", ["id"], :name => "referral_faxes_ibfk_3"

  add_foreign_key "referral_files", ["referral_id"], "referrals", ["id"], :name => "referral_files_ibfk_1"
  add_foreign_key "referral_files", ["referral_file_type_id"], "referral_file_types", ["id"], :name => "referral_files_ibfk_2"
  add_foreign_key "referral_files", ["mime_type_id"], "mime_types", ["id"], :name => "referral_files_ibfk_3"
  add_foreign_key "referral_files", ["referral_message_id"], "referral_messages", ["id"], :name => "referral_files_ibfk_4"

  add_foreign_key "referral_insurance_plans", ["referral_id"], "referrals", ["id"], :name => "referral_insurance_plans_ibfk_1"
  add_foreign_key "referral_insurance_plans", ["insurance_carrier_tag_id"], "tags", ["id"], :name => "referral_insurance_plans_ibfk_2"
  add_foreign_key "referral_insurance_plans", ["insurance_carrier_plan_tag_id"], "tags", ["id"], :name => "referral_insurance_plans_ibfk_3"

  add_foreign_key "referral_message_subtype_selections", ["referral_id"], "referrals", ["id"], :name => "referral_message_subtype_selections_ibfk_1"
  add_foreign_key "referral_message_subtype_selections", ["referral_message_id"], "referral_messages", ["id"], :name => "referral_message_subtype_selections_ibfk_2"
  add_foreign_key "referral_message_subtype_selections", ["referral_message_subtype_id"], "referral_message_subtypes", ["id"], :name => "referral_message_subtype_selections_ibfk_3"

  add_foreign_key "referral_message_subtypes", ["referral_message_type_id"], "referral_message_types", ["id"], :name => "referral_message_subtypes_ibfk_1"

  add_foreign_key "referral_messages", ["referral_id"], "referrals", ["id"], :name => "referral_messages_ibfk_1"
  add_foreign_key "referral_messages", ["referral_message_type_id"], "referral_message_types", ["id"], :name => "referral_messages_ibfk_2"
  add_foreign_key "referral_messages", ["referral_message_state_id"], "referral_message_states", ["id"], :name => "referral_messages_ibfk_5"
  add_foreign_key "referral_messages", ["reply_to_message_id"], "referral_messages", ["id"], :name => "referral_messages_ibfk_6"
  add_foreign_key "referral_messages", ["created_by_user_id"], "users", ["id"], :name => "referral_messages_ibfk_7"

  add_foreign_key "referral_patients", ["referral_id"], "referrals", ["id"], :name => "referral_patients_ibfk_1"

  add_foreign_key "referral_sources", ["referral_id"], "referrals", ["id"], :name => "referral_sources_ibfk_1"
  add_foreign_key "referral_sources", ["referral_source_state_id"], "referral_source_states", ["id"], :name => "referral_sources_ibfk_2"
  add_foreign_key "referral_sources", ["workgroup_id"], "workgroups", ["id"], :name => "referral_sources_ibfk_3"
  add_foreign_key "referral_sources", ["user_id"], "users", ["id"], :name => "referral_sources_ibfk_4"

  add_foreign_key "referral_studies", ["referral_id"], "referrals", ["id"], :name => "referral_studies_ibfk_1"
  add_foreign_key "referral_studies", ["study_type_tag_id"], "tags", ["id"], :name => "referral_studies_ibfk_2"
  add_foreign_key "referral_studies", ["location_tag_id"], "tags", ["id"], :name => "referral_studies_ibfk_4"
  add_foreign_key "referral_studies", ["location_detail_tag_id"], "tags", ["id"], :name => "referral_studies_ibfk_5"
  add_foreign_key "referral_studies", ["study_modality_tag_id"], "tags", ["id"], :name => "referral_studies_ibfk_6"

  add_foreign_key "referral_targets", ["referral_id"], "referrals", ["id"], :name => "referral_targets_ibfk_1"
  add_foreign_key "referral_targets", ["referral_target_state_id"], "referral_target_states", ["id"], :name => "referral_targets_ibfk_2"
  add_foreign_key "referral_targets", ["workgroup_id"], "workgroups", ["id"], :name => "referral_targets_ibfk_3"
  add_foreign_key "referral_targets", ["user_id"], "users", ["id"], :name => "referral_targets_ibfk_4"

  add_foreign_key "referral_type_selections", ["referral_id"], "referrals", ["id"], :name => "referral_type_selections_ibfk_1"
  add_foreign_key "referral_type_selections", ["tag_type_id"], "tag_types", ["id"], :name => "referral_type_selections_ibfk_2"
  add_foreign_key "referral_type_selections", ["tag_id"], "tags", ["id"], :name => "referral_type_selections_ibfk_3"

  add_foreign_key "referrals", ["referral_state_id"], "referral_states", ["id"], :name => "referrals_ibfk_1"
  add_foreign_key "referrals", ["referral_reason_id"], "referral_reasons", ["id"], :name => "referrals_ibfk_4"
  add_foreign_key "referrals", ["cpt_code_id"], "cpt_codes", ["id"], :name => "referrals_ibfk_5"
  add_foreign_key "referrals", ["icd9_code_id"], "icd9_codes", ["id"], :name => "referrals_ibfk_6"
  add_foreign_key "referrals", ["created_by_user_id"], "users", ["id"], :name => "referrals_ibfk_7"
  add_foreign_key "referrals", ["active_source_id"], "referral_sources", ["id"], :name => "referrals_ibfk_8"
  add_foreign_key "referrals", ["active_target_id"], "referral_targets", ["id"], :name => "referrals_ibfk_9"

  add_foreign_key "tag_types", ["parent_tag_type_id"], "tag_types", ["id"], :name => "tag_types_ibfk_1"

  add_foreign_key "tags", ["parent_tag_id"], "tags", ["id"], :name => "tags_ibfk_1"

  add_foreign_key "user_groups", ["user_id"], "users", ["id"], :name => "user_groups_ibfk_1"
  add_foreign_key "user_groups", ["group_id"], "groups", ["id"], :name => "user_groups_ibfk_2"

end
