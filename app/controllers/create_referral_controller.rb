class CreateReferralController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_profile, :only=>[:create]
  before_filter :load_target_referral, :except=>[:create]
  before_filter :initialize_workflow_engine, :except=>[:create]
  include FaxSystem

  #
  # called by start_referral 'pick consultant' link
  # params[:type] == 'request_referral' if this is a reverse referral
  #
  # Based on the type of referral (standard or request referral), creates a new
  # referral and then forwards the user to the create referral wizard
  #
  def create
    @request_referral_mode = (params[:type] == 'request_referral')

    engine = WorkflowEngine.create_referral(:user=>@current_user, :workgroup=>@workgroup)

    if @request_referral_mode
      # reverse referral
      engine.assign_referring_user(:referring_workgroup=>@target_workgroup, :referring_user=>@target_profile.user)
      engine.assign_consultant(:workgroup=>@workgroup, :user=>@current_user)
      engine.referral.request_flag = true
    else
      # standard referral
      engine.assign_referring_user(:referring_user=>@current_user)

      # set the target to the user/physician or the workgroup if a workgroup profile was selected
      if(@target_profile.profile_type_id == "user")
        engine.assign_consultant(:workgroup=>@target_workgroup,:user=>@target_profile.user)
      else
        engine.assign_consultant(:workgroup=>@target_workgroup)
      end
    end

    @target_referral = engine.referral
    @target_referral.wizard_step_mark_complete :service_provider
    @target_referral.save!

    redirect_to :action=>:show, :id=>engine.referral.id
  end

  # display the current working referral
  def show
    active_source = @target_referral.active_source.user || @target_referral.active_source.workgroup
    active_target = @target_referral.active_target.user || @target_referral.active_target.workgroup
    @target_profile = Profile.find_all_for_user( active_target ).first || Profile.find_all_for_workgroup( active_target ).first
    @source_profile = Profile.find_all_for_user( active_source ).first || Profile.find_all_for_workgroup( active_source ).first

    # set up default values for individual editors
    @referral_tag_type_id = 'tag_consultation_type'

    # insure flash is cleared for any partials
    flash[:partial] = nil
  end

  #
  # Marks the referrals as finished, signed and sent to the target consultant. If the referral
  # is a request referral, the workflow engine places it in the proper state.
  #
  # The user is taken to the dashboard once completed.
  #
  def finish
    if @target_referral.request_flag == true 
      unless Workgroup.find(:first, :conditions => {:id => @target_referral.active_source.workgroup_id}).subscriber? 
        send_fax_notification
      end
    else 
      unless Workgroup.find(:first, :conditions => {:id => @target_referral.active_target.workgroup_id}).subscriber?
        send_fax_notification  
      end
    end
    begin

      # TODO: remove the skip_validation step
      @engine.finish_referral(:skip_validation=>true)
      # TODO: for demo purposes, go ahead and sign/send
      @engine.sign_and_send_referral(:skip_validation=>true)

      @engine.referral.wizard_step_mark_complete :complete
      @engine.referral.save!
       
      redirect_to dashboard_index_url
      # used for testing templates render :partial => 'faxes/uns_cover_page_initial' , :use_full_path => true
    rescue Exception => e
      logger.info("#{e}\n\n#{e.backtrace.join('\n')}")
      # format error messages for display
      e_message = 'THIS REFERRAL IS NOT COMPLETE AND WAS NOT SENT:<br>'

      @target_referral.errors.each do |heading, message|
        e_message += message.to_s + '.<br>'
      end

      flash[:error] = e_message
      redirect_to :action=>:show, :id=>@engine.referral.id
    end
  end

end
