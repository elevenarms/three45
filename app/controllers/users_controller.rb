class UsersController < ApplicationController
  before_filter :login_required, :only=>[:reset_password, :change_password, :reset_password_on_behalf, :change_password_on_behalf, :customer_edit]
  include FaxSystem

  # render new.rhtml
  def new
    redirect_to dashboard_index_url and return
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])

    @user.save!
    self.current_user = @user
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def reset_password
    @user = User.find(current_user.id)
  end

  def change_password
    @user = User.find(current_user.id)
    if params["user"] and params["user"]["password"] and !params["user"]["password"].empty?
      if @user.update_attributes(params["user"])
        redirect_to dashboard_index_url and return
      else
        logger.error("update failed: #{@user.errors.full_messages}")
        flash[:error] = "#{@user.errors.full_messages}"
      end
    else
      flash[:error] = "Please provide a password"
    end

    render :action=>"reset_password"
  end

  def reset_password_on_behalf
    @user = User.find(params[:user][:id]) if params[:user]
    @user = User.find(params[:id]) unless params[:user]
  end

  def change_password_on_behalf
    @user = User.find(params[:id])
    @user[:last_login_at] = nil
    if params["user"] and params["user"]["password"] and !params["user"]["password"].empty?
      if @user.update_attributes(params["user"])
        flash[:notice] = "The password for login '#{@user.login}' has been changed"        
        redirect_to dashboard_index_url and return
      else
        logger.error("update failed: #{@user.errors.full_messages}")
        flash[:error] = "#{@user.errors.full_messages}"
      end
    else
      flash[:error] = "Please provide a password"
    end

    render :action=>"reset_password_on_behalf"
  end

  def edit
    @user = User.find(params[:user][:id])
    @prfle = Profile.find_by_user_id(@user.id)
    # TODO allow editing of group membership as well.    
    # @groups = Group.find(:all, :order => "name" ).map {|g| [g.name, g.id] } 
    # group_id = UserGroup.find_by_user_id(@user[:id])[:group_id]
    # group_name = Group.find(group_id)[:name]
    # @default_group = [group_name, group_id]
  end
  
  def update
    @user = User.find(params[:id])
    params[:user][:fax_number] = extract_phone_number(params[:user][:fax_number])
    if params[:profile][:display_name] == 'no profile' then  #non-physicain, i.e. no profile
      if @user.update_attributes(params[:user])
        flash[:notice] = "User info updated"
        redirect_to :controller => session[:admin_type], :action => 'index' and return
      else
        render :action => 'edit' and return
      end
    else #this is a physician user who has a profile
      @prfle = Profile.find_by_user_id(@user[:id])
      #if the workgroup notify_email has not been set, set it to this user's email
      if @user.update_attributes(params[:user]) && @prfle.update_attributes(params[:profile])
        @user.reload
        workgroup_profile = @user.workgroup_user.workgroup.profiles[0]
        pp "+++++++++++=================+++++++++++++++================+++++++++++++++++==============="
        pp workgroup_profile.inspect
        workgroup_profile.update_attribute(:notify_email, @prfle.notify_email)  if workgroup_profile.notify_email == ""

        flash[:notice] = "User info and profile updated"
        redirect_to :controller => session[:admin_type], :action => 'index' and return
      else
        render :action => 'edit' and return
      end
    end    
  end
  
end
