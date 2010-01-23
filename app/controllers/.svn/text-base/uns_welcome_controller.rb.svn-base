#
# User Non Subscriber (UNS) landing page controller
#
class UnsWelcomeController < ApplicationController

  #
  # Primary entry point.
  #
  # Determines what to show based on the workgroup's subscription status. If the workgroup is a subscriber,
  # it simply forwards to the login screen. Otherwise, it presents the UNS login screen w/ agreement checkbox, etc.
  #
  def show
    if @workgroup and @workgroup.subscriber?
      redirect_to :controller => '/sessions', :action => 'new' and return
    else
      if @workgroup and @workgroup.workgroup_users.first
        @first_user = @workgroup.workgroup_users.first.user
        if @first_user
          redirect_to :action=>"new" and return
        else
          # user id in the workgroup_users table doesn't exist!!
          handle_error "Could not locate the default user account assigned to this workgroup" and return
        end
      else
        # no user assigned to the workgroup!!
        handle_error "Could not locate the user account for this workgroup" and return
      end
    end
  end

  # login screen - w/ agreement if first time visit
  def new
    @referral = Referral.find_first_for(@workgroup)
    @user = @workgroup.workgroup_users.first.user if @workgroup
  end

  # process login form for either first-time or returning
  def create
    @referral = Referral.find_first_for(@workgroup)
    first_user = @workgroup.workgroup_users.first.user

    # verify the agree checkbox was checked
    if params[:agree] != "1"
      flash.now[:error] = "You must check the 'I Agree' checkbox to proceed"
      render :action=>"new" and return
    end

    # process login
    @user = User.authenticate(params[:login], params[:password])
    self.current_user = @user

    # if the authentication succeeded
    if logged_in?
      # check for previous login prior to actually logging in
      previously_logged_in = first_user.has_logged_in?

      begin
        self.current_user.logged_in!
      rescue => e
        logger.error("UnsWelcomeController") { "Error trying to update user's last_login_at field" }
      end

      # audit logging
      log_user_login(self.current_user)

      # determine where to take the user next
      if previously_logged_in
        # returning user
        redirect_to dashboard_index_url and return
      else
        # first time - ask to reset the password
        redirect_to reset_password_user_path(@user) and return
      end
    else
      flash.now[:error] = "Invalid login or password"
    end

    # didn't work, so let's reload the user instance and redisplay
    @user = @workgroup.workgroup_users.first.user if @workgroup
    render :action=>"new"
  end

end
