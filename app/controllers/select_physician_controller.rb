class SelectPhysicianController < ApplicationController
  helper :files

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

  def update
    @referring_physician = User.find_by_id(params['referring_physician'])

    if @referring_physician.nil?
      render :update do |page|
        flash.now[:partial] = "Please select a referring physician"
        page.replace_html 'referral_referrer', :partial => 'select_physician/edit', :locals=>{ :edit_disabled => false }
      end
      return
    end

    if @target_referral.request_referral?
      @engine.assign_consultant(:workgroup=>@workgroup, :user=>@referring_physician)
    else
      @engine.assign_referring_user(:referring_user=>@referring_physician) unless @referring_physician == nil
    end

    @engine.referral.wizard_step_mark_complete :referring_physician
    @engine.referral.save!

    if @engine.referral.wizard_step == :referring_physician.to_s
      render :partial => 'next_step'
    else
      render :update do |page|
        page.replace_html 'referral_referrer', :partial => 'select_physician/show', :locals=>{ :edit_disabled => false }
      end
    end
  end
end
