class ReferralsController < ApplicationController
  before_filter :original_request, :only => :show
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_referral_eager
  before_filter :initialize_workflow_engine
  
  
  include MessagesQuerySystem

  def summary
    render :layout=>false if request.xhr?
  end

  def new_info
    @new_messages = ReferralMessage.find_unread_messages_for(@target_referral.id, @target_referral.source_or_target_for(@workgroup.id))
    now = Time.now
    @new_messages.each do |new_message|
      new_message.update_attributes({ :viewed_at=>now})
    end
    render :layout=>"print"
  end

  def all_info
    @all_messages = ReferralMessage.find_all_top_level_messages_for(@target_referral.id)

    active_target = @target_referral.active_target.user || @target_referral.active_target.workgroup
    @target_profile = Profile.find_all_for_user( active_target ).first || Profile.find_all_for_workgroup( active_target ).first

    active_source = @target_referral.active_source.user || @target_referral.active_source.workgroup
    @source_profile = Profile.find_all_for_user( active_source ).first || Profile.find_all_for_workgroup( active_source ).first

    render :layout=>"print"
  end

  def show
    # messages grid setup
    setup_messages_filter_from_session_or_request
    query_messages_using_filter

    # instance variables needed by the partials
    active_target = @target_referral.active_target.user || @target_referral.active_target.workgroup
    @target_profile = Profile.find_all_for_user( active_target ).first || Profile.find_all_for_workgroup( active_target ).first

    active_source = @target_referral.active_source.user || @target_referral.active_source.workgroup
    @source_profile = Profile.find_all_for_user( active_source ).first || Profile.find_all_for_workgroup( active_source ).first

    # accept/decline and withdraw support and other UI decision drivers
    @accept_decline_required = true if (@target_referral.status_provisional? and @target_referral.active_target.is_target?(@workgroup.id))
    @withdraw_allowed = true if (@target_referral.status_provisional? and @target_referral.active_source.is_source?(@workgroup.id))
    @edit_disabled = true if (@target_referral.status_provisional?)
    @change_consultant_allowed = (@target_referral.status_in_progress? and @target_referral.active_target.is_target?(@workgroup.id) and @target_referral.active_target.workgroup.ppw?)

    # a little insurance -- in case artifacts around from early days
    @target_referral.wizard_step_mark_complete :complete
    @target_referral.save!
  end

  def accept
    begin
      # load the physician, if provided
      physician_user = User.find_by_id(params[:physician_user]) if params[:physician_user]
      @engine.accept_referral(:physician_user=>physician_user)
      flash[:notice] = "Referral Accepted"
    rescue WorkflowEngine::WorkflowEngineException => e
      flash[:error] = e.to_s
    end
    redirect_to referral_path(@target_referral)
  end

  def decline
    begin
      @engine.decline_referral
      flash[:notice] = "Referral Declined"
    rescue WorkflowEngine::WorkflowEngineException => e
      flash[:error] = e.to_s
    end
    redirect_to referral_path(@target_referral)
  end

  def withdraw
    begin
      @engine.withdraw_referral
      flash[:notice] = "Referral Withdrawn"
    rescue WorkflowEngine::WorkflowEngineException => e
      flash[:error] = e.to_s
    end
    redirect_to referral_path(@target_referral)
  end

  def cancel
    begin
      @engine.cancel_referral
      #flash[:notice] = "Referral Canceled"
    rescue WorkflowEngine::WorkflowEngineException => e
      flash[:error] = e.to_s
    end
    redirect_to :back
  end

  def select_consultant
    render :partial => "select_consultant"
  end

  def change_consultant
    begin
      if params[:physician_user] and !params[:physician_user].empty?
        physician_user = User.find_by_id(params[:physician_user])
        @engine.change_consulting_user(:physician_user=>physician_user)
        flash[:notice] = "Consultant Assigned"
      end
    rescue WorkflowEngine::WorkflowEngineException => e
      flash[:error] = e.to_s
    end
    redirect_to referral_path(@target_referral)
  end

  def close
    begin
      @engine.close_referral
      flash[:notice] = "Referral Closed"
    rescue WorkflowEngine::WorkflowEngineException => e
      flash[:error] = e.to_s
    end
    redirect_to referral_path(@target_referral)
  end

  def reopen
    begin
      @engine.reopen_referral
      flash[:notice] = "Referral Reopened"
    rescue WorkflowEngine::WorkflowEngineException => e
      flash[:error] = e.to_s
    end
    redirect_to referral_path(@target_referral)
  end
end
