# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end

      first_time_to_login = (self.current_user.last_login_at.nil?)

      begin
        self.current_user.logged_in!
      rescue => e
        logger.error("SessionsController") { "Error trying to update user's last_login_at field" }
      end

      # audit logging
      log_user_login(self.current_user)

      # redirect to the password reset for a first_time login
      redirect_to reset_password_user_path(current_user) and return if first_time_to_login

      flash[:notice] = "Welcome back"
      # otherwise, force redirect to dashboard - Ticket #5
      redirect_to session[:return_to] || '/dashboard'
    else
      flash.now[:error] = "Invalid login or password"
      render :action => 'new'
    end
  end

  def destroy
    # audit logging
    log_user_logout(self.current_user)

    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
