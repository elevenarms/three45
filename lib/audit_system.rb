#
# Injects helper methods for creating AuditLog entries into the database from within
# a controller or the WorkflowEngine
#
#
#
module AuditSystem
  include AuditCategoryConstants
  include ActionView::Helpers::NumberHelper

  #
  # Logs a user_login Event
  #
  def log_user_login(user)
    audit_log(USER_LOGIN, { :description=>nil, :user_id=>user.id })
  end

  #
  # Logs a user_logout Event
  #
  def log_user_logout(user)
    now = Time.now
    duration = ((now - user.last_login_at) / 60) if user.last_login_at
    duration = "N/A" unless user.last_login_at
    audit_log(USER_LOGOUT, { :description=>"Duration: #{number_with_precision(duration,2)} Min", :user_id=>user.id })
  end

  #
  # Logs a referral_sent Event
  #
  def log_referral_sent(user, workgroup, referral)
    description = referral.request_referral? ? "#{referral.active_source.display_id}" : "#{referral.active_target.display_id}"
    audit_log(REFERRAL_SENT, { :description=>"#{description}", :user_id=>user.id, :workgroup_id=>workgroup.id, :referral_id=>referral.id })
  end

  #
  # Logs a referral_accepted Event
  #
  def log_referral_accepted(user, workgroup, referral)
    audit_log(REFERRAL_ACCEPTED, { :description=>"#{referral.display_patient_id}", :user_id=>user.id, :workgroup_id=>workgroup.id, :referral_id=>referral.id })
  end

  #
  # Logs a referral_cancelled Event
  #
  def log_referral_cancelled(user, workgroup, referral)
    audit_log(REFERRAL_CANCELLED, { :description=>nil, :user_id=>user.id, :workgroup_id=>workgroup.id, :referral_id=>referral.id })
  end

  #
  # Logs a file_uploaded Event
  #
  def log_file_uploaded(user, workgroup, referral, referral_file, method_of_upload)
    audit_log(FILE_UPLOADED, { :description=>"#{referral_file.id}", :user_id=>user.id, :workgroup_id=>workgroup.id, :referral_id=>referral.id, :long_description=>method_of_upload })
  end

  #
  # Logs a file_upload_failed Event
  #
  def log_file_upload_failed(user, workgroup, referral, exception)
    audit_log(FILE_UPLOAD_FAILED, { :description=>"#{exception}", :user_id=>user.id, :workgroup_id=>workgroup.id, :referral_id=>referral.id })
  end

  #
  # Logs a fax_created Event
  #
  def log_fax_created(user, workgroup, referral, referral_fax, method_of_create)
    audit_log(FAX_CREATED, { :description=>"#{referral_fax.id}", :user_id=>user.id, :workgroup_id=>workgroup.id, :referral_id=>referral.id, :long_description=>method_of_create })
  end

  #
  # Logs a message_created Event
  #
  def log_message_created(user, workgroup, referral, message)
    audit_log(MESSAGE_CREATED, { :description=>"#{message.id}", :user_id=>user.id, :workgroup_id=>workgroup.id, :referral_id=>referral.id })
  end

  #
  # Logs a message_replied Event
  #
  def log_message_replied(user, workgroup, referral, message)
    audit_log(MESSAGE_REPLIED, { :description=>"#{message.id}", :user_id=>user.id, :workgroup_id=>workgroup.id, :referral_id=>referral.id })
  end

  #
  # Logs an admin_new_user Event
  #
  def log_admin_new_user(user, workgroup, new_user)
    audit_log(ADMIN_NEW_USER, { :description=>"#{new_user.id}", :user_id=>user.id, :workgroup_id=>workgroup.id })
  end

  #
  # Logs an admin_edit_workgroup Event
  #
  def log_admin_edit_workgroup(user, workgroup)
    audit_log(ADMIN_EDIT_WORKGROUP, { :description=>nil, :user_id=>user.id, :workgroup_id=>workgroup.id })
  end

  #
  # Logs an admin_edit_user Event
  #
  def log_admin_edit_user(user, workgroup, user_edited)
    audit_log(ADMIN_EDIT_USER, { :description=>"#{user_edited.id}", :user_id=>user.id, :workgroup_id=>workgroup.id })
  end

  #
  # Logs an admin_edit_tags_entered Event
  #
  def log_admin_edit_tags_entered(user, workgroup)
    workgroup_id = workgroup.nil? ? nil : workgroup.id
    audit_log(ADMIN_EDIT_TAGS_ENTERED, { :description=>nil, :user_id=>user.id, :workgroup_id=>workgroup_id })
  end

  #
  # Logs an referral_edited_patient Event
  #
  def log_referral_edited_patient(user, workgroup, referral, patient)
    workgroup_id = workgroup.nil? ? nil : workgroup.id
    audit_log(REFERRAL_EDITED_PATIENT, { :description=>nil, :user_id=>user.id, :workgroup_id=>workgroup_id ,:referral_id => referral.id})
    audit_message(user, workgroup, referral, patient, "Patient Details Edited", "The patient details were edited.") if referral.status_in_progress?
  end

  #
  # Logs an referral_edited_insurance Event
  #
  def log_referral_edited_insurance(user, workgroup, referral, insurance)
    workgroup_id = workgroup.nil? ? nil : workgroup.id
    audit_log(REFERRAL_EDITED_INSURANCE, { :description=>nil, :user_id=>user.id, :workgroup_id=>workgroup_id ,:referral_id => referral.id})
    audit_message(user, workgroup, referral, insurance, "Insurance Details Edited", "The insurance details were edited.") if referral.status_in_progress?
  end

  #
  # Creates a new Audit Log entry. If an error occurs, it will log the error and continue silently,
  # as not to disrupt the running code
  #
  def audit_log(category_id, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}

    description         = options[:description]
    long_description    = options[:long_description]
    workgroup_id        = options[:workgroup_id]
    user_id             = options[:user_id]
    profile_id          = options[:profile_id]
    referral_id         = options[:referral_id]

    begin
      AuditLog.create!({  :audit_category_id=>category_id,
                         :description=>description,
                         :long_description=>long_description,
                         :workgroup_id=>workgroup_id,
                         :user_id=>user_id,
                         :profile_id=>profile_id,
                         :referral_id=>referral_id})
    rescue => e
      logger.error("Error trying to make an AuditLog entry: #{e}") if logger
    end
  end

  #
  # Creates a new ReferralMessage attached to the referral for auditing purposes.
  # If an error occurs, it will log the error and continue silently, as not to disrupt the running code
  #
  def audit_message(user, workgroup, referral, patient, subject, message_text)
    begin
      # use the workflow engine to log a message from this user to the other party
      workflow_engine = WorkflowEngine.new(referral, user, workgroup)
      audit_message = ReferralMessage.new({ :subject=>subject, :referral_message_type_id=>"general_note", :message_text=>message_text, :created_by => user})
      workflow_engine.attach_message(:message=>audit_message, :audit_log_mode=>true)
    rescue => e
      logger.error("Error trying to attach an audit message to referral (#{referral.id}): #{e}") if logger
    end
  end
end
