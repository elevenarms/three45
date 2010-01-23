class PatientController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_referral
  before_filter :initialize_workflow_engine

  def show
    render :partial => 'show'
  end

  def edit
    render :partial => 'edit'
  end

  def create
    # create associated patient object
    @patient = @target_referral.referral_patients.size == 0 ? ReferralPatient.new : @target_referral.referral_patients.first

    @patient.first_name = params['first']
    @patient.middle_name = params['mi']
    @patient.last_name = params['last']
    @patient.ssn = params['ssn']
    @patient.email = params['email']
    dob_year  = params['date']['year']
    dob_month = params['date']['month']
    dob_day   = params['date']['day']
    if dob_year and !dob_year.empty? and dob_month and !dob_month.empty? and dob_day and !dob_day.empty?
      @patient.dob = Date.civil( dob_year.to_i, dob_month.to_i, dob_day.to_i )
    else
      @patient.dob = nil
    end
    if params['gender'] == 'Female'
      @patient.gender = 'F'
    elsif params['gender'] == 'Male'
      @patient.gender = 'M'
    else
      @patient.gender = nil
    end
    @patient.phone = params['phone']

    @engine.assign_patient(:referral_patient=>@patient)

    @engine.referral.wizard_step_mark_complete :patient
    @engine.referral.save!
    log_referral_edited_patient(current_user, @workgroup, @engine.referral, @patient)

    if @engine.referral.wizard_step == :patient.to_s
      render :partial => 'next_step'
    else
      render :update do |page|
        page.replace_html 'referral_patient', :partial => 'patient/show', :locals=>{ :edit_disabled => false }
      end
    end
  end
end
