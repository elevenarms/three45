class InsuranceController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_referral
  before_filter :initialize_workflow_engine

  # lists all insurers associated with the referral
  def index
    render :partial=>"edit_index" if params['edit_mode']

    unless( params['edit_mode'] )
      @engine.referral.wizard_step_mark_complete :insurance
      @engine.referral.save!

      if @engine.referral.wizard_step == :insurance.to_s
        render :partial => 'next_step'
      else
        render :update do |page|
          page.replace_html 'referral_insurance', :partial => 'insurance/index', :locals=>{ :edit_disabled => false }
        end
      end
    end
  end

  # create new empty insurance object
  def new
    render :partial=>"edit_new_insurance_detail"
  end

  def create
    begin
      patient_carrier_plan = ReferralInsurancePlan.new

      patient_carrier_plan.insurance_carrier_tag_id = params['provider']
      patient_carrier_plan.insurance_carrier_plan_tag_id = params['plan']
      patient_carrier_plan.policy_details = params['details']

      patient_carrier_plan.authorization = params['authorization']
      patient_carrier_plan.number_of_visits = params['number_of_visits'].to_i if params['number_of_visits']
      patient_carrier_plan.expiration_date = Time.parse(params['patient_carrier_plan']['expiration_date']) if params['patient_carrier_plan'] and params['patient_carrier_plan']['expiration_date'] and !params['patient_carrier_plan']['expiration_date'].empty?

      @engine.assign_insurance(:referral_insurance_plan=>patient_carrier_plan)
      log_referral_edited_insurance(current_user, @workgroup, @engine.referral, patient_carrier_plan)

      render :partial=>"edit_index"
    rescue => e
      logger.info("Caught during create: "+e.inspect)
      flash.now[:partial] = 'PLEASE CHOOSE BOTH AN INSURANCE PROVIDER AND A PLAN'
      render :partial=>"edit_new_insurance_detail", :status => 500 and return
    end
  end

  # edit existing insurance object
  def edit
    patient_carrier_plan = ReferralInsurancePlan.find( params['patient_carrier_plan_id'] )
    render :partial=>"edit_insurance_detail", :locals => { :patient_carrier_plan => patient_carrier_plan }
  end

  def update
    begin
      patient_carrier_plan = ReferralInsurancePlan.find( params['patient_carrier_plan_id'] )

      patient_carrier_plan.authorization = params['authorization']
      patient_carrier_plan.number_of_visits = params['number_of_visits'].to_i if params['number_of_visits']
      patient_carrier_plan.expiration_date = Time.parse(params['patient_carrier_plan']['expiration_date']) if params['patient_carrier_plan'] and params['patient_carrier_plan']['expiration_date'] and !params['patient_carrier_plan']['expiration_date'].empty?

      patient_carrier_plan.insurance_carrier_tag_id = params['provider']
      patient_carrier_plan.insurance_carrier_plan_tag_id = params['plan']
      patient_carrier_plan.policy_details = params['details']
      patient_carrier_plan.save!
      log_referral_edited_insurance(current_user, @workgroup, @engine.referral, patient_carrier_plan)

      render :partial=>"insurance_detail", :locals => { :patient_carrier_plan => patient_carrier_plan, :editing_controls => true }
    rescue
      # format error messages for display
      flash[:partial] = 'PLEASE CHOOSE BOTH AN INSURANCE PROVIDER AND A PLAN'

      render :partial=>"edit_insurance_detail", :locals => { :patient_carrier_plan => patient_carrier_plan }, :status => 500 rescue render :text=>"Error", :status=>500
    end
  end

  # remove existing insurance object
  def destroy
    ReferralInsurancePlan.destroy(params['patient_carrier_plan_id'])

    render :partial=>"edit_index"
  end

  def carrier_plan_options
    @carrier_tag_id = params[:carrier_tag_id]
    @referral_target_workgroup = @target_referral.active_target.workgroup

    # render :layout=>false
    render :inline=>"<%=select_tag 'plan', insurance_carrier_plan_options_for(@referral_target_workgroup, @carrier_tag_id)%>"
  end
end
