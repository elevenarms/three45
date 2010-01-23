#
# = Overview
#
# Manages the workflow of a referral, from initial creation to completion.
#
# Controllers should utilize this API by building the model as normal
# and pass it to the appropriate method for saving to the database.
#
# The referral will be updated with the referral's new state, as well as the new state
# for the referral source and target
#
# = Using the WorkflowEngine API
#
# == How to use the WorkflowEngine to create a new referral
#
#   engine = WorkflowEngine.create_referral(:user=>@current_user, :workgroup=>@workgroup)
#
# This step performs the following actions within the system:
#
# 1. Creates a new row in the referrals table, with the source as the current workgroup
# 2. Creates a blank referral_patients row (for the dashboard display)
# 3. Assigns the referring user to the source if provided (on behalf of or current user)
#
# == To operate on an existing referral
#
#   engine = WorkflowEngine.new(the_referral, the_current_user, the_current_workgroup)
#
# == Accessing the current referral
#
# The current referral can be accessed via the engine using:
#
#   engine.referral
#
# == Method arguments and exception handling
#
# Most methods within the workflow engine accept a hash of arguments. If an argument is missing, an
# InvalidArgumentException is raised. If the state of the referral doesn't support the action, an
# InvalidStateException is raised.
#
# For example:
#
#   begin
#     engine.assign_referring_user(:referring_user=>@dr_gillespie)
#   rescue WorkflowEngine::InvalidStateException => e
#     # handle the error here
#   end
#
# = Request Referral Support
#
# Request referrals are referrals that are created by the consultant rather than the referring physician.
# The workflow engine is indifferent about who created the referral, but has support for setting the proper
# state of the referral based on the type of referral being created.
#
#
#
#
#
class WorkflowEngine

  # including the AuditSystem to inject helper methods into this class
  include AuditSystem

  attr :referral

  # provide a logger for the AuditSystem helper methods
  @@logger = ProfileTagsController.logger

  #
  # Creates a new referral given the following options:
  #
  # Required:
  #
  #   :user - the user creating the referral
  #   :workgroup - the workgroup that this referral is from
  #
  # Optional:
  #
  #   :referring_user - the physican user that should be considered the source user for the referral -
  #                     Note: use assign_referring_user() if not known at the time of creation
  #
  # Returns a new engine instance for the referral
  #
  # Raises an exception if the arguments are not provided or the save failed
  #
  def self.create_referral(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    user      = options[:user]
    workgroup = options[:workgroup]
    referring_user = options[:referring_user]

    raise InvalidArgumentException.new("user cannot be nil") if user.nil?
    raise InvalidArgumentException.new("workgroup cannot be nil") if workgroup.nil?
    # check membership and raise an exception if the user isn't a member
    raise WorkflowEngineException.new("#{user.id} is not a member of workgroup #{workgroup.id}") if !workgroup.is_member?(user)

    referral = Referral.new({ :referral_state_id=>ReferralState::NEW, :created_by_user=>user, :created_by_workgroup=>workgroup})
    # setup defaults so that searches on the dashboard will JOIN properly
    referral.referral_type_selections << ReferralTypeSelection.new({ :tag_type_id => "referral_standard_types", :tag_id=>"tag_consultation_type" })
    referral.referral_patients << ReferralPatient.new
    referral.save!
    engine = WorkflowEngine.new(referral, user, workgroup)
    # need to add referring user arg and - defer create source if the referring user isn't provided
    engine.assign_referring_user(:referring_user=>referring_user) if referring_user
    return engine
  end


  def logger # :nodoc:
    @@logger
  end

  #
  # Construct a new workflow engine using the referral as the context for all operations
  #
  def initialize(referral, current_user, current_workgroup)
    raise InvalidArgumentException.new("referral cannot be nil") if referral.nil?
    # JWH: removing the requirement for these to values to be non-nil to support
    #      the fax integration in FaxFilesController#create
    #raise InvalidArgumentException.new("current_user cannot be nil") if current_user.nil?
    #raise InvalidArgumentException.new("current_workgroup cannot be nil") if current_workgroup.nil?
    @referral = referral
    @current_user = current_user
    @current_workgroup = current_workgroup
    # check membership and raise an exception if the user isn't a member
    if @current_user and @current_workgroup
      raise WorkflowEngineException.new("#{@current_user.id} is not a member of workgroup #{@current_workgroup.id}") if !@current_workgroup.is_member?(@current_user)
    end
  end

  #
  # Update the referring source user given the following options:
  #
  # Required:
  #
  #   :referring_user - the physician user to assign to this referral
  #
  # Optional:
  #
  #   :referring_workgroup - the workgroup to assign to this referral (for reverse referrals)
  #
  # Returns the modified referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the required arguments are not provided or the save failed
  #
  def assign_referring_user(*args)
    raise InvalidStateException.new("Invalid state for assign_referring_user: #{@referral.referral_state_id}") if !@referral.status_new?
    options = args.last.is_a?(Hash) ? args.pop : {}
    referring_user = options[:referring_user]
    referring_workgroup = options[:referring_workgroup] || @current_workgroup
    raise InvalidArgumentException.new("referring_user cannot be nil") if referring_user.nil?
    # 1. delete any previous ones, since we are in the new state and don't care to see older ones (or need history yet)
    @referral.delete_referral_sources!
    # 2. assign the new target
    source = ReferralSource.new({ :user=>referring_user, :workgroup=>referring_workgroup, :referral_source_state_id=>ReferralSourceState::NEW, :referral=>@referral})
    @referral.referral_sources << source
    @referral.from_name = source.display_name
    @referral.active_source = source
    @referral.save!
    return @referral
  end

  #
  # Update the target consultant (user or workgroup) given the following options:
  #
  # Required:
  #
  #   :workgroup - the target workgroup selected
  #
  # Optional:
  #
  #   :user - the target user (only if the target workgroup is a PPW and the user has selected a physician)
  #
  # Returns the modified referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the required arguments are not provided or the save failed
  #
  def assign_consultant(*args)
    raise InvalidStateException.new("Invalid state for assign_consultant: #{@referral.referral_state_id}") if !@referral.status_new?
    options = args.last.is_a?(Hash) ? args.pop : {}
    workgroup = options[:workgroup]
    user      = options[:user]
    raise InvalidArgumentException.new("workgroup cannot be nil") if workgroup.nil?

    # 1. delete any previous ones in the NEW state, since we are in the new state and don't care to see older ones (or need history yet)
    @referral.delete_referral_targets_in_new_state!
    # 2. assign the new target
    target = ReferralTarget.new({ :user=>user, :workgroup=>workgroup, :referral_target_state_id=>ReferralTargetState::NEW})

    @referral.referral_targets << target
    @referral.active_target = target
    @referral.to_name = target.display_name
    @referral.save!
    return @referral
  end

  #
  # Change the target physician given the following options:
  #
  # Required:
  #
  #   :physician_user - the new user for the referral_target
  #
  #
  # Returns the modified referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the required arguments are not provided or the save failed
  #
  def change_consulting_user(*args)
    raise InvalidStateException.new("Invalid state for change_consulting_user: #{@referral.referral_state_id}") if !@referral.status_in_progress?
    options = args.last.is_a?(Hash) ? args.pop : {}
    physician_user      = options[:physician_user]
    raise InvalidArgumentException.new("physician_user cannot be nil") if physician_user.nil?

    target = @referral.active_target
    target.user = physician_user
    @referral.to_name = target.display_name
    @referral.save!
    target.save!
    return @referral
  end

  #
  # Update the service requested details given the following options:
  #
  # Required:
  #
  #   :referral_type_selection
  #
  # Returns the modified referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the required arguments are not provided or the save failed
  #
  def assign_service_requested(*args)
    raise InvalidStateException.new("Invalid state for assign_service_requested: #{@referral.referral_state_id}") if !@referral.status_new?
    options = args.last.is_a?(Hash) ? args.pop : {}
    referral_type_selection  = options[:referral_type_selection]
    source = @referral.active_source
    raise InvalidArgumentException.new("referral_type_selection must be provided") if referral_type_selection.nil?

    @referral.delete_referral_type_selections!
    @referral.referral_type_selections << referral_type_selection

    # update source referral state to NEW (in case the state is DECLINED or WITHDRAWN from a previous assignment)
    source.referral_source_state_id = ReferralSourceState::NEW
    source.save!
    @referral.save! # set the updated_at field

    return @referral
  end

  #
  # Referral Study support
  #

  #
  # Attaches a ReferralStudy to the referral, setting the FK and saving it to the DB
  #
  # Required:
  #
  #   :study - the ReferralStudy to attach
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def attach_study(*args)
    raise InvalidStateException.new("Invalid state for assign_study: #{@referral.referral_state_id}") if !@referral.status_new?
    options = args.last.is_a?(Hash) ? args.pop : {}
    study = options[:study]
    raise InvalidArgumentException.new("study must be provided") if study.nil?
    @referral.referral_studies << study
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Updates an attached ReferralStudy
  #
  # Required:
  #
  #   :study - the ReferralStudy to update
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def update_study(*args)
    raise InvalidStateException.new("Invalid state for assign_study: #{@referral.referral_state_id}") if !@referral.status_new?
    options = args.last.is_a?(Hash) ? args.pop : {}
    study = options[:study]
    raise InvalidArgumentException.new("study must be provided") if study.nil?
    study.save!
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Removes a ReferralStudy from the referral, marking it as deleted in the DB if the state is in_progress. Otherwise,
  # it simply deletes the study from the database and study system
  #
  # Required:
  #
  #   :study - the ReferralStudy to remove
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def remove_study(*args)
    raise InvalidStateException.new("Invalid state for assign_study: #{@referral.referral_state_id}") if !@referral.status_new?
    options = args.last.is_a?(Hash) ? args.pop : {}
    study = options[:study]
    raise InvalidArgumentException.new("study must be provided") if study.nil?
    study.destroy # acts_as_paranoid
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Referral Diagnosis Selection support
  #

  #
  # Attaches one or more ReferralDiagnosisSelections to the referral, setting the FKs and saving them to the DB
  #
  # Note: deletes any previous selections to replaces them
  #
  #
  # Required:
  #
  #   :diagnosis_selections - an array of ReferralDiagnosisSelections to attach
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def assign_diagnosis_selections(*args)
    raise InvalidStateException.new("Invalid state for assign_diagnosis_selections: #{@referral.referral_state_id}") if !@referral.status_new?
    options = args.last.is_a?(Hash) ? args.pop : {}
    diagnosis_selections = options[:diagnosis_selections]
    raise InvalidArgumentException.new("diagnosis_selections must be provided") if diagnosis_selections.nil?
    @referral.delete_diagnosis_selections!
    diagnosis_selections.each do |diagnosis_selection|
      @referral.referral_diagnosis_selections << diagnosis_selection
    end
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Patient support
  #

  #
  # Assigns the patient for this referral, forcefully removing any previous patients
  #
  # Required:
  #
  #   :referral_patient - the ReferralPatient to attach to the referral
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def assign_patient(*args)
    # raise InvalidStateException.new("Invalid state for assign_patient: #{@referral.referral_state_id}") if !@referral.status_new?
    options = args.last.is_a?(Hash) ? args.pop : {}
    referral_patient       = options[:referral_patient]
    raise InvalidArgumentException.new("referral_patient must be provided") if referral_patient.nil?
    # remove any old ones automatically
    ReferralPatient.delete_all(["referral_id = ?", @referral.id])
    @referral.referral_patients << referral_patient
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Assigns a new insurance plan for this referral
  #
  # Required:
  #
  #   :referral_insurance_plan - the ReferralInsurancePlan to attach to the referral
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def assign_insurance(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    referral_insurance_plan      = options[:referral_insurance_plan]
    raise InvalidArgumentException.new("referral_insurance_plan must be provided") if referral_insurance_plan.nil?
    @referral.referral_insurance_plans << referral_insurance_plan
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Updates an existing insurance plan for this referral
  #
  # Required:
  #
  #   :referral_insurance_plan - the ReferralInsurancePlan to update
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def update_insurance(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    referral_insurance_plan      = options[:referral_insurance_plan]
    raise InvalidArgumentException.new("referral_insurance_plan must be provided") if referral_insurance_plan.nil?
    referral_insurance_plan.save!
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Removes an insurance plan from this referral
  #
  # Required:
  #
  #   :referral_insurance_plan - the ReferralInsurancePlan to remove
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def remove_insurance(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    referral_insurance_plan      = options[:referral_insurance_plan]
    raise InvalidArgumentException.new("referral_insurance_plan must be provided") if referral_insurance_plan.nil?
    referral_insurance_plan.destroy
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # File/Fax support
  #

  #
  # Attaches a ReferralFile to the referral, setting the FK and saving it to the DB
  #
  # Required:
  #
  #   :file - the ReferralFile to attach
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def attach_file(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to attach files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    file = options[:file]
    raise InvalidArgumentException.new("file must be provided") if file.nil?
    @referral.referral_files << file
    @referral.save! # set the updated_at field

    return @referral
  end

  #
  # Updates an existing ReferralFile to the referral
  #
  # Required:
  #
  #   :file - the ReferralFile to update
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def update_file(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to attach files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    file = options[:file]
    raise InvalidArgumentException.new("file must be provided") if file.nil?
    file.save!
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Removes a ReferralFile from the referral, marking it as deleted in the DB if the state is in_progress. Otherwise,
  # it simply deletes the file from the database and file system
  #
  # Required:
  #
  #   :file - the ReferralFile to remove
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def remove_file(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to remove files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    file = options[:file]
    raise InvalidArgumentException.new("file must be provided") if file.nil?
    if @referral.status_in_progress?
      file.destroy # acts_as_paranoid
    else
      file.destroy!
    end
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Attaches a ReferralFax to the referral, setting the FK and saving it to the DB
  #
  # Required:
  #
  #   :fax - the ReferralFax to attach
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def attach_fax(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to remove files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    fax = options[:fax]
    raise InvalidArgumentException.new("fax must be provided") if fax.nil?
    @referral.referral_faxes << fax
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Updates an existing ReferralFax to the referral
  #
  # Required:
  #
  #   :fax - the ReferralFax to update
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def update_fax(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to remove files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    fax = options[:fax]
    raise InvalidArgumentException.new("fax must be provided") if fax.nil?
    fax.save!
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Updates a ReferralFax status
  #
  # Required:
  #
  #   :fax - the ReferralFax to update
  #   :fax_state - the id of the ReferralFaxState to update the status for
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def update_fax_state(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to remove files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    fax = options[:fax]
    fax_state = options[:fax_state]
    error_details = options[:error_details]
    raise InvalidArgumentException.new("fax must be provided") if fax.nil?
    raise InvalidArgumentException.new("fax_state must be provided") if fax_state.nil?
    fax.referral_fax_state_id = fax_state
    fax.error_details = error_details # may be nil
    fax.save!
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Removes a ReferralFax from the referral, marking it as deleted in the DB
  #
  # Required:
  #
  #   :fax - the ReferralFax to remove
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def remove_fax(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to remove files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    fax = options[:fax]
    raise InvalidArgumentException.new("fax must be provided") if fax.nil?
    fax.destroy # acts_as_paranoid
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Attaches a ReferralFaxFile to the referral, setting the FK and saving it to the DB
  #
  # Required:
  #
  #   :fax      - the parent ReferralFax to associate to the FaxFile
  #   :fax_file - the ReferralFaxFile to attach
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def attach_fax_file(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to remove files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    fax = options[:fax]
    fax_file = options[:fax_file]
    raise InvalidArgumentException.new("fax_file must be provided") if fax_file.nil?
    raise InvalidArgumentException.new("fax must be provided") if fax.nil?
    fax_file.referral_fax = fax
    @referral.referral_fax_files << fax_file
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Updates an existing ReferralFaxFile to the referral
  #
  # Required:
  #
  #   :fax_file - the ReferralFaxFile to update
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def update_fax_file(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to remove files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    fax_file = options[:fax_file]
    raise InvalidArgumentException.new("fax_file must be provided") if fax_file.nil?
    fax_file.save!
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Removes a ReferralFaxFile from the referral, marking it as deleted in the DB
  #
  # Required:
  #
  #   :fax_file - the ReferralFaxFile to remove
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def remove_fax_file(*args)
    # Note: leaving this open to any state, as I believe the spec infers the ability to remove files anytime
    options = args.last.is_a?(Hash) ? args.pop : {}
    fax_file = options[:fax_file]
    raise InvalidArgumentException.new("fax_file must be provided") if fax_file.nil?
    fax_file.destroy # acts_as_paranoid
    @referral.save! # set the updated_at field
    return @referral
  end

  ##
  ## Workflow State Support
  ##

  #
  # Deletes a referral permanently, only if it is in a new or waiting state
  #
  # Required:
  #
  #   <none>
  #
  # Returns the deleted referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def cancel_referral(*args)
    raise InvalidStateException.new("Invalid state for cancel_referral: #{@referral.referral_state_id}") if !@referral.status_new? and !@referral.status_waiting_approval?

    # audit log (before we delete it)
    #log_referral_cancelled(@current_user, @current_workgroup, @referral)

    @referral.delete_with_cascade!
    return @referral
  end

  #
  # Finishes the new referral, marking it as pending approval
  #
  # Required:
  #
  #   <none>
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def finish_referral(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    skip_validation = options[:skip_validation] || false

    raise InvalidStateException.new("Invalid state for finish_referral: #{@referral.referral_state_id}") if !@referral.status_new?
    raise ReferralInvalidException.new("Referral had validation errors: #{@referral.errors.full_messages}") unless skip_validation or @referral.valid_for_finish?
    @referral.referral_state_id = ReferralState::WAITING_APPROVAL
    @referral.save!
    @referral.reload # force the model to refresh, since we may have changed some eager-loaded models
    return @referral
  end

  #
  # Marks the referral as signed by the physician and sent to the target party for an accept or decline action
  #
  # Required:
  #
  #   <none>
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def sign_and_send_referral(*args)
    raise InvalidStateException.new("Invalid state for sign_and_send_referral: #{@referral.referral_state_id}") if !@referral.status_waiting_approval?
    # verify that the user is allowed to sign and send based on the workgroup settings
    raise ActionNotAllowedException.new("user is not allowed to sign and send based on current workgroup settings: #{@current_user.join_groups}") if !@current_workgroup.allowed_to_sign_and_send?(@current_user)
    target = @referral.active_target
    source = @referral.active_source
    raise MissingTargetException.new("Could not locate an active referral_target entry for Referral ID: #{@referral.id}") if target.nil?

    # set the referral state to WAITING_ACCEPTANCE or IN_PROGRESS if this is a request referral
    @referral.referral_state_id = (@referral.request_referral?) ? ReferralState::IN_PROGRESS : ReferralState::PROVISIONAL
    @referral.save!
    @referral.reload # force the model to refresh, since we may have changed some eager-loaded models

    # update target referral state to WAITING_ACCEPTANCE or IN_PROGRESS if this is a request referral
    if @referral.request_referral?
      target.referral_target_state_id = ReferralTargetState::IN_PROGRESS
    else
      target.referral_target_state_id = ReferralTargetState::WAITING_ACCEPTANCE
    end
    target.save!

    # update source referral state to WAITING_ACCEPTANCE or IN_PROGRESS if this is a request referral
    if @referral.request_referral?
      source.referral_source_state_id = ReferralSourceState::IN_PROGRESS
    else
      source.referral_source_state_id = ReferralSourceState::WAITING_ACCEPTANCE
    end
    source.save!

    # audit log
    log_referral_sent(@current_user, @current_workgroup, @referral)
    log_referral_accepted(@current_user, @current_workgroup, @referral) if @referral.request_referral?
    
    #email notification
    if @referral.request_referral? && Workgroup.find(:first,:conditions=>{:id=>source.workgroup_id}).subscriber?
      Notification.deliver_new_request_referral(source, @referral)
    elsif Workgroup.find(:first,:conditions=>{:id=>target.workgroup_id}).subscriber?
      Notification.deliver_new_referral(target, @referral)
    end
   
    
    if @referral.request_referral?
      # create a referral request message for the source to view, since this is a reverse referral
      message = ReferralMessage.new({ :subject=>"Referral Request",
                                    :referral_message_type_id=>"referral_request",
                                    :message_text=>"This is a request for you to make a patient referral.",
                                    :created_by => @current_user,
                                    :response_required_by=>Time.now,
                                    :referral_source_or_target_id => @referral.active_source.id})
      self.attach_message(:message=>message, :audit_log_mode=>true)
    end

    return @referral
  end

  #
  # Accepts an incoming referral that was previously signed and sent by the referring physician source
  #
  # Required:
  #
  #   :physician_user - required if the target is a PPW and a physician user hasn't been selected
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def accept_referral(*args)
    raise InvalidStateException.new("Invalid state for accept_referral: #{@referral.referral_state_id}") if !@referral.status_provisional?
    target = @referral.active_target
    source = @referral.active_source

    options = args.last.is_a?(Hash) ? args.pop : {}
    skip_validation = options[:skip_validation] || false
    physician_user  = options[:physician_user]

    raise MissingTargetException.new("Could not locate an active referral_target entry for Referral ID: #{@referral.id}") if target.nil?

    # require physician selection if target is a ppw
    if target.user.nil? and target.workgroup.ppw?
      if physician_user.nil? or !physician_user.is_physician?
        raise TargetInvalidException.new("This referral requires a physician to be selected")
      end
      target.user = physician_user
      @referral.to_name = target.display_name
    end

    # validate that the target user has been assigned if the target is a PPW workgroup
    raise TargetInvalidException.new("Target user is missing or not a physician of the ppw workgroup") unless skip_validation or @referral.valid_target_for_accept?

    @referral.referral_state_id = ReferralState::IN_PROGRESS
    @referral.save!
    @referral.reload # force the model to refresh, since we may have changed some eager-loaded models

    # update target referral state to IN_PROGRESS
    target.referral_target_state_id = ReferralTargetState::IN_PROGRESS
    target.save!

    # update source referral state to IN_PROGRESS
    source.referral_source_state_id = ReferralSourceState::IN_PROGRESS
    source.save!
    @referral.save! # set the updated_at field

    # notify the patient of the accepted referral
    # DISABLED pending advice from legal advisor
    # Notification.deliver_referral_details_to_patient(@referral) if !@referral.referral_patients.empty? and !@referral.referral_patients.first.email.nil?

    # audit log
    log_referral_accepted(@current_user, @current_workgroup, @referral)

    return @referral
  end

  #
  # Declines a previously signed and sent referral
  #
  # Required:
  #
  #   <none>
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def decline_referral(*args)
    raise InvalidStateException.new("Invalid state for decline_referral: #{@referral.referral_state_id}") if !@referral.status_provisional?
    target = @referral.active_target
    source = @referral.active_source
    raise MissingTargetException.new("Could not locate an active referral_target entry for Referral ID: #{@referral.id}") if target.nil?

    @referral.referral_state_id = ReferralState::NEW
    @referral.save!
    @referral.reload # force the model to refresh, since we may have changed some eager-loaded models

    # update target referral state to DECLINED
    target.referral_target_state_id = ReferralTargetState::DECLINED
    target.save!

    # update source referral state to DECLINED_BY_TARGET
    source.referral_source_state_id = ReferralSourceState::DECLINED_BY_TARGET
    source.save!
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Withdraws a previously signed and sent referral by the referral source
  #
  # Required:
  #
  #   <none>
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def withdraw_referral(*args)
    raise InvalidStateException.new("Invalid state for withdraw_referral: #{@referral.referral_state_id}") if !@referral.status_provisional?
    target = @referral.active_target
    source = @referral.active_source
    raise MissingTargetException.new("Could not locate an active referral_target entry for Referral ID: #{@referral.id}") if target.nil?

    @referral.referral_state_id = ReferralState::NEW
    @referral.active_target = nil
    @referral.save!

    # update target referral state to WITHDRAWN_BY_SOURCE
    target.referral_target_state_id = ReferralTargetState::WITHDRAWN_BY_SOURCE
    target.save!

    # update source referral state to WITHDRAWN
    source.referral_source_state_id = ReferralSourceState::WITHDRAWN
    source.save!
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Closes a previously in progress referral
  #
  # Required:
  #
  #   <none>
  #
  # Optional:
  #
  #   :reason - the reason for closing the referral
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def close_referral(*args)
    raise InvalidStateException.new("Invalid state for close_referral: #{@referral.referral_state_id}") if !@referral.status_in_progress?
    options = args.last.is_a?(Hash) ? args.pop : {}
    reason = options[:reason] || "(None provided)"
    target = @referral.active_target
    source = @referral.active_source
    raise MissingTargetException.new("Could not locate an active referral_target entry for Referral ID: #{@referral.id}") if target.nil?

    @referral.referral_state_id = ReferralState::CLOSED
    @referral.save!

    # update target referral state to CLOSED
    target.referral_target_state_id = ReferralTargetState::CLOSED
    target.save!

    # update source referral state to CLOSED
    source.referral_source_state_id = ReferralSourceState::CLOSED
    source.save!

    # create a message containing the reason
    message = ReferralMessage.new({ :subject=>"Referral Closed",
                                  :referral_message_type_id=>"general_note",
                                  :message_text=>"Referral Closed - #{reason}",
                                  :created_by => @current_user,
                                  :referral_source_or_target_id => @referral.opposite_source_or_target_for(@current_workgroup)})
    self.attach_message(:message=>message, :audit_log_mode=>true)

    return @referral
  end

  #
  # Reopens a previously closed referral
  #
  # Required:
  #
  #   <none>
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def reopen_referral(*args)
    raise InvalidStateException.new("Invalid state for reopen_referral: #{@referral.referral_state_id}") if !@referral.status_closed?
    target = @referral.active_target
    source = @referral.active_source
    raise MissingTargetException.new("Could not locate an active referral_target entry for Referral ID: #{@referral.id}") if target.nil?

    @referral.referral_state_id = ReferralState::IN_PROGRESS
    @referral.save!

    # update target referral state to IN_PROGRESS
    target.referral_target_state_id = ReferralTargetState::IN_PROGRESS
    target.save!

    # update source referral state to IN_PROGRESS
    source.referral_source_state_id = ReferralSourceState::IN_PROGRESS
    source.save!

    # create a message containing the reason
    message = ReferralMessage.new({ :subject=>"Referral Reopened",
                                  :referral_message_type_id=>"general_note",
                                  :message_text=>"Referral Reopened",
                                  :created_by => @current_user,
                                  :referral_source_or_target_id => @referral.opposite_source_or_target_for(@current_workgroup)})
    self.attach_message(:message=>message, :audit_log_mode=>true)

    return @referral
  end

  #
  # Message/Request/Note Support
  #


  #
  # Attaches a new message (note, request, etc) to the referral
  #
  # Required:
  #
  #   :message - the message to attach
  #
  # Optional:
  #
  #   :audit_log_mode - true if being called from the audit log
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def attach_message(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    message = options[:message]
    audit_log_mode = options[:audit_log_mode] || false
    raise InvalidStateException.new("Invalid state for attach_message: #{@referral.referral_state_id}") if !@referral.status_in_progress? and !audit_log_mode
    raise InvalidArgumentException.new("message must be provided") if message.nil?
    raise ValidationFailedException.new("message has errors: #{message.errors.full_messages}") if !message.valid?

    # determine if the created_by is from the active_source or active_target workgroup
    source_workgroup = @referral.active_source.workgroup
    if source_workgroup.is_member?(message.created_by)
      created_by_belongs_to_source_workgroup = true
    end

    # set the default message status based on the type
    message.referral_message_state_id = ReferralMessageState::WAITING_RESPONSE if message.request?
    message.referral_message_state_id = ReferralMessageState::NEW_INFO unless message.request?

    message.referral_source_or_target_id = created_by_belongs_to_source_workgroup == true ? @referral.active_target_id : @referral.active_source_id

    @referral.referral_messages << message

    # mark the original message as complete, if this is a reply
    complete_message(:message=>message.reply_to_message) if message.reply? and message.reply_to_message.request?

    # now, set source or target state properly since we have now viewed the note
    set_source_or_target_status(created_by_belongs_to_source_workgroup)

    @referral.save! # set the updated_at field
    #email notification
    if created_by_belongs_to_source_workgroup
      target = ReferralTarget.find(:first, :conditions => {:id => @referral.active_target_id})
      if Workgroup.find(:first, :conditions => {:id => target.workgroup_id}).subscriber?
        if message.request?
          Notification.deliver_action_requested(target, @referral.active_target,@referral.active_source)
        else
          Notification.deliver_new_info(target, @referral.active_target,@referral.active_source)
        end
      end
    else
      source = @referral.active_source
      if Workgroup.find(:first, :conditions => {:id => source.workgroup_id}).subscriber?
        if message.request?
          Notification.deliver_action_requested(source,@referral.active_source, @referral.active_target)
        else
          Notification.deliver_new_info(source, @referral.active_source, @referral.active_target)
        end
      end
    end
    return @referral
  end

  #
  # Marks a message as read and updates the source or target status if possible
  #
  # Required:
  #
  #   :message - the message to mark as read
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def mark_message_read(*args)
    raise InvalidStateException.new("Invalid state for mark_message_read: #{@referral.referral_state_id}") if !@referral.status_in_progress?
    options = args.last.is_a?(Hash) ? args.pop : {}
    message = options[:message]
    raise InvalidArgumentException.new("message must be provided") if message.nil?

    message.viewed_at = Time.now
    # we only flip the status to complete if this is a note
    message.referral_message_state_id = ReferralMessageState::COMPLETE if !message.request?
    message.save!

    # determine if the created_by is from the active_source or active_target workgroup
    source_workgroup = @referral.active_source.workgroup
    if source_workgroup.is_member?(message.created_by)
      created_by_belongs_to_source_workgroup = true
    end

    # set source or target state properly since we have now viewed the note
    set_source_or_target_status(created_by_belongs_to_source_workgroup)

    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Marks a message as complete if it is a request type. Also updates the source or target status if possible
  #
  # Required:
  #
  #   :message - the message to mark as completed
  #
  # Returns the referral model
  #
  # Raises a WorkflowEngine::InvalidStateException if the state is incorrect for the action requested
  # Raises an Exception if the action failed
  #
  def complete_message(*args)
    raise InvalidStateException.new("Invalid state for complete_message: #{@referral.referral_state_id}") if !@referral.status_in_progress?
    options = args.last.is_a?(Hash) ? args.pop : {}
    message = options[:message]
    raise InvalidArgumentException.new("message must be provided") if message.nil?
    raise ValidationFailedException.new("message has errors: #{message.errors.full_messages}") if !message.valid?

    # determine if the created_by is from the active_source or active_target workgroup
    source_workgroup = @referral.active_source.workgroup
    if source_workgroup.is_member?(message.created_by)
      created_by_belongs_to_source_workgroup = true
    end

    message.responded_at = Time.now
    message.viewed_at = Time.now # if we are completing it, it has been viewed
    message.referral_message_state_id = ReferralMessageState::COMPLETE

    message.save!

    # set source or target state properly since we have now viewed the note
    set_source_or_target_status(created_by_belongs_to_source_workgroup)

    @referral.save! # set the updated_at field
    return @referral
  end

  def void_message(*args)
    raise InvalidStateException.new("Invalid state for void_message: #{@referral.referral_state_id}") if !@referral.status_in_progress?
    options = args.last.is_a?(Hash) ? args.pop : {}
    message = options[:message]
    raise InvalidArgumentException.new("message must be provided") if message.nil?
    raise ValidationFailedException.new("message has errors: #{message.errors.full_messages}") if !message.valid?

    message.referral_message_state_id = ReferralMessageState::VOID
    message.save!

    # determine if the created_by is from the active_source or active_target workgroup
    source_workgroup = @referral.active_source.workgroup
    if source_workgroup.is_member?(message.created_by)
      created_by_belongs_to_source_workgroup = true
    end

    # set source or target state properly since we have now viewed the note
    set_source_or_target_status(created_by_belongs_to_source_workgroup)

    @referral.save! # set the updated_at field
    return @referral
  end

  def remove_message(*args)
    raise InvalidStateException.new("Invalid state for remove_message: #{@referral.referral_state_id}") if !@referral.status_in_progress?
    options = args.last.is_a?(Hash) ? args.pop : {}
    message = options[:message]
    raise InvalidArgumentException.new("message must be provided") if message.nil?
    message.destroy # acts_as_paranoid
    @referral.save! # set the updated_at field
    return @referral
  end

  #
  # Granular Exceptions
  #

  class WorkflowEngineException < Exception
  end
  class InvalidStateException < WorkflowEngineException
  end
  class InvalidArgumentException < WorkflowEngineException
  end
  class MissingTargetException < WorkflowEngineException
  end
  class ActionNotAllowedException < WorkflowEngineException
  end
  class ReferralInvalidException < WorkflowEngineException
  end
  class TargetInvalidException < WorkflowEngineException
  end
  class ValidationFailedException < WorkflowEngineException
  end


  protected

  def set_source_or_target_status(created_by_belongs_to_source_workgroup) # :nodoc:

    # logic to mark the source and target status as
    #       1) waiting response if unread messages exist
    #       2) new information if no unread messages but new info is available
    #       3) in progress if no unread messages and no new info

    # update the target status
    if !@referral.active_target.has_unread_messages? and !@referral.active_target.has_open_requests? and !@referral.status_closed?
      #puts "in progress"
      @referral.active_target.referral_target_state_id = ReferralTargetState::IN_PROGRESS
      @referral.active_target.save!
    elsif @referral.active_target.has_open_requests?
      #puts "waiting"
      @referral.active_target.referral_target_state_id = ReferralTargetState::WAITING_RESPONSE
      @referral.active_target.save!
    elsif @referral.active_target.has_unread_messages?
      #puts "new"
      @referral.active_target.referral_target_state_id = ReferralTargetState::NEW_INFO
      @referral.active_target.save!
    end

    # update the source status
    if !@referral.active_source.has_unread_messages? and !@referral.active_source.has_open_requests? and !@referral.status_closed?
      @referral.active_source.referral_source_state_id = ReferralSourceState::IN_PROGRESS
      @referral.active_source.save!
    elsif @referral.active_source.has_open_requests?
      @referral.active_source.referral_source_state_id = ReferralSourceState::WAITING_RESPONSE
      @referral.active_source.save!
    elsif @referral.active_source.has_unread_messages?
      @referral.active_source.referral_source_state_id = ReferralSourceState::NEW_INFO
      @referral.active_source.save!
    end
  end
end
