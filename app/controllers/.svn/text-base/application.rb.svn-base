# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include AuditSystem
  include RoleSystem
  include SearchSystem

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_three45_session_id'
  expire_session_in 10.minutes, :after_expiration => :handle_expired_session

  def handle_expired_session
    flash[:notice] = "You have been logged out due to inactivity"
  end

  before_filter :lookup_workgroup_using_subdomain, :validate_workgroup_membership

  def lookup_workgroup_using_subdomain
    if RAILS_ENV == "test"
      logger.info("Injecting the default TEST workgroup 'workgroup_mccoy'")
      subdomain = 'workgroup_mccoy'
    else
      subdomain = "in-house-testing"   # not listed in database (produces nil workgroup)
    end
     if request.subdomains.first == 'www'
      subdomain = request.subdomains[1]
    else
      subdomain = request.subdomains.first unless request.subdomains.first == nil
    end

    # use subdomain to lookup appropriate workgroup
    @workgroup = Workgroup.find( :first, :conditions => [ "subdomain = ?", subdomain ] )
    logger.info("Processing request for workgroup: #{@workgroup.id}") unless @workgroup.nil?
    logger.info("Processing request for UNKNOWN workgroup") if @workgroup.nil?
  end

  def validate_workgroup_membership
    # check that user should have access to current workgroup
    if logged_in?
      wu = WorkgroupUser.find( :first, :conditions => [ "workgroup_id = ? AND user_id = ?", @workgroup.id, current_user.id ] )

      if wu.nil?
        # mark the user as logged out, clear their session, and redirect them to the login page
        log_user_logout(self.current_user)

        self.current_user.forget_me if logged_in?
        cookies.delete :auth_token
        reset_session
        flash[:notice] = "You do not have permission for this workgroup. Please recheck the web address or contact support."
        redirect_to :controller => '/sessions', :action => 'new'
        return false
      end
    end unless @workgroup == nil
    return true
  end

  def load_default_profile
    if logged_in?
      @profile = current_user.load_default_profile(@workgroup)

      if @workgroup.nil? and RAILS_ENV == "test" and current_user and current_user.workgroup_user
        # default tests to use the user's default workgroup if possible, allowing for any user to become
        # the active user, not just 'quentin'
        @workgroup = current_user.workgroup_user.workgroup
      end

      # if subdomain mechanism did not bring in a workgroup, try to grab using profile instead - last chance to get it right
      @workgroup = @profile.load_member_workgroup if @workgroup == nil and @profile
    end
  end

  def load_target_profile
    if(params[:profile_id] || params[:id])
      @target_profile = Profile.find_by_id(params[:profile_id] || params[:id], :include=>[:user, :workgroup, { :profile_tags=>[:tag, :tag_type]}], :conditions=>["profile_tags.deleted_at is null"])

      if @target_profile.nil?
        handle_error "This profile could not be found or no longer exists" and return false
      end

      @target_workgroup = @target_profile.load_member_workgroup

      return true if @target_profile
    else
      handle_error "Must supply a target profile id" and return false
    end

    handle_error "Must supply a valid target profile id" and return false
  end

  def load_target_tag
    if(params[:id])
      @target_tag = Tag.find_by_id(params[:id], :include=>[:tag_type, :tag_sponsors])

      if @target_tag.nil?
        handle_error "This tag could not be found or no longer exists" and return false
      end

      return true if @target_tag
    else
      handle_error "Must supply a target tag id" and return false
    end

    handle_error "Must supply a valid target tag id" and return false
  end

  def load_target_sponsor
    if(params[:id])
      @target_sponsor = TagSponsor.find_by_id(params[:id])

      if @target_sponsor.nil?
        handle_error "This tag sponsor could not be found or no longer exists" and return false
      end

      return true if @target_sponsor
    else
      handle_error "Must supply a target tag sponsor id" and return false
    end

    handle_error "Must supply a valid target tag sponsor id" and return false
  end

  def load_target_friendship
    if(params[:id])
      @target_friendship = ProfileFriendship.find_by_id(params[:id])

      if @target_friendship.nil?
        handle_error "This profile friendship could not be found or no longer exists" and return false
      end

      return true if @target_friendship
    else
      handle_error "Must supply a target profile friendship id" and return false
    end

    handle_error "Must supply a valid target friendship profile id" and return false
  end

  def load_target_referral_eager
    return load_target_referral(true)
  end

  def load_target_referral(eager=false)
    # since we use nested resources for the create_referral_controller, we must first
    # check for a create_referral_id param, then check for id as a fallback
    if(params[:id] or params[:referral_id] or params[:create_referral_id])
      @target_referral = Referral.find_by_id(params[:referral_id] || params[:create_referral_id] || params[:id]) unless eager
      @target_referral = Referral.find_eager(params[:referral_id] || params[:create_referral_id] || params[:id]) if eager

      if @target_referral.nil?
        handle_error "Referral #{(params[:id] or params[:create_referral_id])} could not be found or no longer exists" and return false
      end

      return true if @target_referral
    else
      handle_error "Must supply a referral id" and return false
    end

    handle_error "Must supply a valid referral id" and return false
  end

  def load_target_message_eager
    return load_target_message(true)
  end

  def load_target_message(eager=false)
    id = params[:message_id] || params[:id]
    if(id)
      @target_message = ReferralMessage.find_eager(id) if eager
      @target_message = ReferralMessage.find_by_id(id) unless eager

      if @target_message.nil?
        handle_error "Referral Message #{id} could not be found or no longer exists" and return false
      end

      return true if @target_message
    else
      handle_error "Must supply a referral message id" and return false
    end

    handle_error "Must supply a valid referral message id" and return false
  end

  def load_target_fax
    id = params[:fax_id] || params[:id]
    if(id)
      @target_fax = ReferralFax.find_by_id(id)

      if @target_fax.nil?
        handle_error "Referral Fax #{id} could not be found or no longer exists" and return false
      end

      @target_referral = @target_fax.referral if @target_referral.nil?
      return true if @target_fax
    else
      handle_error "Must supply a referral fax id" and return false
    end

    handle_error "Must supply a valid referral fax id" and return false
  end

  def load_target_fax_file
    id = params[:fax_file_id] || params[:id]
    if(id)
      @target_fax_file = ReferralFaxFile.find_by_id(id)

      if @target_fax_file.nil?
        handle_error "Referral Fax File #{id} could not be found or no longer exists" and return false
      end

      return true if @target_fax_file
    else
      handle_error "Must supply a referral fax file id" and return false
    end

    handle_error "Must supply a valid referral fax file id" and return false
  end

  def load_target_file
    id = params[:file_id] || params[:id]
    if(id)
      @target_file = ReferralFile.find_by_id(id)

      if @target_file.nil?
        handle_error "Referral File #{id} could not be found or no longer exists" and return false
      end

      return true if @target_file
    else
      handle_error "Must supply a referral file id" and return false
    end

    handle_error "Must supply a valid referral file id" and return false
  end

  def load_target_referral_insurance_plan
    if(params[:referral_insurance_plan_id] || params[:id])
      @target_referral_insurance_plan = ReferralInsurancePlan.find_by_id(params[:referral_insurance_plan_id] || params[:id])

      if @target_referral_insurance_plan.nil?
        handle_error "Referral Referral_Insurance_Plan #{params[:referral_insurance_plan_id] or params[:id]} could not be found or no longer exists" and return false
      end

      @target_referral = @target_referral_insurance_plan.referral if @target_referral.nil?
      return true if @target_referral_insurance_plan
    else
      handle_error "Must supply a referral referral_insurance_plan id" and return false
    end

    handle_error "Must supply a valid referral referral_insurance_plan id" and return false
  end

  def load_target_ad
    if(params[:id])
      @target_ad = Ad.find_by_id(params[:id])

      if @target_ad.nil?
        handle_error "This ad could not be found or no longer exists" and return false
      end

      return true if @target_ad
    else
      handle_error "Must supply a target ad id" and return false
    end

    handle_error "Must supply a valid target ad id" and return false
  end

  def load_target_profile_tag
    logger.info("profile_tag_id=#{params[:profile_tag_id]}")
    logger.info("id=#{params[:id]}")
    id = (params[:profile_tag_id] || params[:id])
    if(id)
      logger.info "loading::::: #{id}"
      @target_profile_tag = ProfileTag.find_by_id(id)

      if @target_profile_tag.nil?
        handle_error "This profile tag could not be found or no longer exists" and return false
      end

      return true if @target_profile_tag
    else
      handle_error "Must supply a target profile tag id" and return false
    end

    handle_error "Must supply a valid target profile tag id" and return false
  end

  def load_target_profile_friendly
    if(params[:target_profile_id])
      @target_profile = Profile.find_by_id(params[:target_profile_id], :conditions=>["profile_tags.deleted_at IS NULL"], :include=>[:user, :workgroup, { :profile_tags=>[:tag, :tag_type]}])

      if @target_profile.nil?
        handle_error "This profile could not be found or no longer exists" and return false
      end

      @target_workgroup = @target_profile.load_member_workgroup

      return true if @target_profile
    else
      handle_error "Must supply a target profile id" and return false
    end

    handle_error "Must supply a valid target profile id" and return false
  end

  def initialize_workflow_engine
    @engine = WorkflowEngine.new(@target_referral, @current_user, @workgroup)
    return true
  end

  def set_referral_context
    @context = "referral"
    return true
  end

  def handle_error(text,e=nil)
    if e.nil?
      render :text=>text, :status=>500
    else
      render :text=>text+" Details:#{e.to_s}", :status=>500
    end
  end

  def three45_data_entry_required
    @groups = current_user.user_groups.map {|ug| ug.group_id}
    if @groups.select { |g| g == "three45_data_entry" }[0].nil? then
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end
  def original_request
    session[:return_to] = request.request_uri
  end

end
