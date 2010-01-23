class CustomerAdminController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  include FaxSystem

  def index
    setup_for_index
  end

  #
  #
  #  W O R K G R O U P
  #
  #

  def edit_workgroup # display current info and allow edit
    @prfle = Profile.find_by_workgroup_id(@workgroup[:id])
  end

  def update_workgroup # both workgroup & profile tables
    @prfle = Profile.find_by_workgroup_id(@workgroup.id)
    params[:workgroup][:fax_number] = extract_phone_number(params[:workgroup][:fax_number])
    params[:workgroup][:office_number] = extract_phone_number(params[:workgroup][:office_number])
    if @workgroup.update_attributes(params[:workgroup]) && (@prfle.nil? || @prfle.update_attributes(params[:profile]))
      # audit log
      log_admin_edit_workgroup(current_user, @workgroup)

      flash[:notice] = "Workgroup information has been updated"
      redirect_to :controller => 'customer_admin', :action => 'index'
    else
      flash[:error] = 'Error updating workgroup information'
      redirect_to :controller => 'customer_admin',  :action => 'edit_workgroup'
    end
  end

  def new_address_for_workgroup
    @workgroup_addresses = @workgroup.workgroup_addresses
    @address_types = AddressType.find(:all, :order => "name" ).map {|w| [w.name, w.id] }
  end

  def add_address_to_workgroup
    @address_type = AddressType.find(params[:address_type][:id])
    @address = Address.new(params[:address])
    @workgroup_address = WorkgroupAddress.new
    @address.save!
    @workgroup_address.address = @address
    @workgroup_address.workgroup = @workgroup
    @workgroup_address.address_type = @address_type
    unless @workgroup_address.save then
      flash[:error] = "Problem adding an address.  Please report to three45 support."
      # audit log
      log_admin_edit_workgroup(current_user, @workgroup)     
      render :template=>"customer_admin/new_address_for_workgroup" and return
    end
    @workgroup_addresses = @workgroup.workgroup_addresses
    @address_types = AddressType.find(:all, :order => "name" ).map {|w| [w.name, w.id] }

    # audit log
    log_admin_edit_workgroup(current_user, @workgroup)

    flash[:notice] = 'New address has been added'
    render :template=>"customer_admin/new_address_for_workgroup"
  end

  def delete_address
    workgroup_address = WorkgroupAddress.find(params[:id])
    address= Address.find(workgroup_address[:address_id])
    WorkgroupAddress.destroy(workgroup_address)
    unless Address.destroy(address) then
      flash[:error] = "Problem deleting an address.  Please report to three45 support."
      # audit log
      log_admin_edit_workgroup(current_user, @workgroup)
      render :template=>"customer_admin/new_address_for_workgroup" and return
    end
    @address_types = AddressType.find(:all, :order => "name" ).map {|w| [w.name, w.id] }
    @workgroup_addresses = @workgroup.workgroup_addresses

    # audit log
    log_admin_edit_workgroup(current_user, @workgroup)

    flash[:notice] = 'Address has been deleted'
    render :template=>"customer_admin/new_address_for_workgroup"
  end

  def create_photo_for_workgroup
    @prfle = Profile.find_by_workgroup_id(@workgroup.id)
    p = params[:profile_image]
    p[:profile_id] = @prfle[:id]
    @profile_image = ProfileImage.new(p)
    unless @prfle.profile_images << @profile_imagethen
      flash[:error] = "Problem uploading image for workgroup.  Please report to three45 support."
      redirect_to :action => 'index' and return
    end
    flash[:notice] = 'Graphic has been added to workgroup'
    redirect_to :action => 'index'
  end

  #
  #
  #  U S E R
  #
  #

  def remote_cancel_edit_user_subset
    @user = current_user
  render :partial => "/customer_admin/display_user_subset", :layout => false and return
  end

  def remote_edit_user_subset
    @user = current_user
    if request.xhr? then
      render :partial => "/customer_admin/edit_user_subset", :layout => false and return  
    else 
      setup_for_index
      puts "was not an XHHTRequest!!!!!!!!!!!!!!!!!!!!!!"   
      @mode = "edit"  
      render :template => "/customer_admin/index" and return      
      render 
    end
  end
  
  def remote_update_user_subset
    @user = User.find(params[:id])
    params[:user][:fax_number] = extract_phone_number(params[:user][:fax_number])
    @errors_present = !@user.update_attributes(params[:user])   
    # if request is an XHTTPRequest, this is the user updating himself
    if request.xhr? then
      if @errors_present then 
        render :partial => "/customer_admin/edit_user_subset", :layout => false and return
      else
        render :partial => "/customer_admin/display_user_subset", :layout => false and return  
      end 
    else
      current_user.reload
      setup_for_index
      if @errors_present
        flash[:error] = "Problem updating user information - see below."
        @mode = "edit"
      else
        flash[:notice] = "Your user information has been updated"
        @mode = "display"
      end      
      render :template => "/customer_admin/index" and return
    end  #of XHTTPRequest
  end
  
  def new_user
    @user = User.new
    workgroup_users = @workgroup.workgroup_users
    @workgroup_users = []
    workgroup_users.each do |wu|
      user = User.find(wu[:user_id])
      @workgroup_users << wu unless user.last_name == 'three45Administrator'
    end
    @groups = []
    @groups[0] = ['Physician', 'ppw_physician_user']
    @groups[1] = ['Non-Physician', 'ppw_admin']
  end

  def create_user
    @groups = []
    @groups[0] = ['Physician', 'ppw_physician_user']
    @groups[1] = ['Non-Physician', 'ppw_admin']
    params[:user][:fax_number] = extract_phone_number(params[:user][:fax_number])
    @user = User.new(params[:user])
    unless @user.save
      workgroup_users = @workgroup.workgroup_users
      @workgroup_users = []
      workgroup_users.each do |wu|
        user = User.find(wu[:user_id])
        @workgroup_users << wu unless user.last_name == 'three45Administrator'
      end
      
      flash[:error] = "Problem creating user.  Correct errors below and re-submit."
      render :template => 'customer_admin/new_user' and return
    end   

    @workgroup_user = WorkgroupUser.new
    @workgroup_user[:workgroup_id] = @workgroup[:id]
    @workgroup_user[:user_id] = @user[:id]
    unless @workgroup_user.save then
      workgroup_users = @workgroup.workgroup_users
      @workgroup_users = []
      workgroup_users.each do |wu|
        user = User.find(wu[:user_id])
        @workgroup_users << wu unless user.last_name == 'three45Administrator'
      end
      
      flash[:error] = "Problem creating user.  Please report to three45 support."
      render :template=>'customer_admin/new_workgroup' and return
    end
    
    workgroup_users = @workgroup.workgroup_users.reload
    @workgroup_users = []
    workgroup_users.each do |wu|
      user = User.find(wu[:user_id])
      @workgroup_users << wu unless user.last_name == 'three45Administrator'
    end

    @user_group = UserGroup.new
    @user_group[:group_id] = params[:group][:id]
    @user_group[:user_id] = @user[:id]
    unless @user_group.save then
      flash[:error] = "Problem creating user.  Please report to three45 support."
      render :template=>'customer_admin/new_workgroup' and return
    end
     
    if @user_group[:group_id] == 'ppw_physician_user' then
        @prfle = Profile.new
        @prfle[:user_id] = @user[:id]
        @prfle[:profile_type_id] = 'user'
        unless @prfle.save then
          flash[:error] = "Problem creating user.  Please report to three45 support."
          render :template=>'customer_admin/new_workgroup' and return
        end
        
    end
    @created_user = @user
    @user = User.new
    workgroup_users = @workgroup.workgroup_users
    @workgroup_users = []
    workgroup_users.each do |wu|
      user = User.find(wu[:user_id])
      @workgroup_users << wu unless user.last_name == 'three45Administrator'
    end
    @groups = []
    @groups[0] = ['Physician', 'ppw_physician_user']
    @groups[1] = ['Non-Physician', 'ppw_admin']

    # audit log
    log_admin_new_user(current_user, @workgroup, @user)

    flash[:notice] = "User #{@user.full_name} has been created successfully"
    render :template => 'customer_admin/new_user'
  end
  
  def different_user_group
    #change user between physician and non-physician
    @usr = User.find(params[:user][:id])
    @usr_group = UserGroup.find(:first, :conditions=>"user_id = '#{params[:user][:id]}'")
    @current_group = Group.find(@usr_group[:group_id])
    @groups = []
    @groups[0] = ['Physician', 'ppw_physician_user']
    @groups[1] = ['Non-Physician', 'ppw_admin']    
  end
  
  def change_user_group
    usr_group = UserGroup.find(:first, :conditions=>"user_id = '#{params[:usr_id]}'")
    if usr_group[:group_id] == "ppw_physician_user" && params[:new_group] == "ppw_admin" then 
      #was a physician; must delete profile
      unless usr_group.update_attribute("group_id", "ppw_admin") then
        flash[:error] = "Problem changing user type"
        redirect_to :action => "index" and return
      end
      prfle = Profile.find(:first, :conditions=>"user_id = '#{params[:usr_id]}'")
      Profile.delete(prfle[:id]) 
      flash[:notice] = "User type changed to administrator"      
    elsif usr_group[:group_id] == "ppw_admin" && params[:new_group] == "ppw_physician_user"
      #was admin; must create profile
      usr_group[:group_id] = "ppw_physician_user"
      unless usr_group.update_attribute("group_id", "ppw_physician_user") then
        flash[:error] = "Problem changing user type"
        redirect_to :action => "index" and return
      end
      prfle = Profile.new
      prfle[:user_id] = params[:usr_id]
      prfle[:profile_type_id] = 'user'
      if prfle.save then
        flash[:notice] = "User type changed to physician and profile added"
      else
        flash[:error] = "Problem changing user type"
      end
    end
    redirect_to :action => "index"
  end

  def create_photo
    ## create a photo for a user OR the workgroup
    @prfle = Profile.find(params[:target_profile_id])
    p = params[:profile_image]
    params[:profile_image][:profile_id] = @prfle[:id]
    @profile_image = ProfileImage.new(params[:profile_image])
    if @prfle.profile_images << @profile_image then
      flash[:notice] = 'New photo or logo successfully added'
      redirect_to :action => 'index'
    else
      flash[:error] = 'Error adding photo or logo'
      redirect_to :action => 'index'
    end
  end
  
  def request_provider
    # get the provider info and email it to us
    source = @current_user.full_name + " of " + @workgroup.name
    message_content = "Request for new provider: \nfrom " + source + ":\n" + params[:last_name].to_s + ", " + params[:first_name].to_s + " " + params[:middle_name].to_s + "\nPhone: " + params[:phone].to_s + ", Fax: " + params[:fax].to_s + "\nComments:   " + params[:additional_info].to_s
    Notification.deliver_sysadmin(message_content)
    ActionMailer::Base.deliveries.inspect
    flash[:notice] = "Request for new provider has been sent.  Provider will be added shortly."
    redirect_to :action=>'index' and return
  end
  
  private 
  
  def setup_for_index
    workgroup_users = @workgroup.workgroup_users
    usr = []  
    @mode = "display"
    @user = current_user
    @errors_present = false
    workgroup_users.each do |wu|
      user = User.find(wu[:user_id])
      usr << user unless user.last_name == 'three45Administrator'
    end
    @users = usr.sort_by {|u| u.last_name}
    @users = [["-- Select a User --", ""]] + @users.map {|u| [u.full_name, u.id] }
    prfles = Profile.find_all_profiles_for_workgroup(@workgroup) if @workgroup
    prfles = Array.new unless @workgroup
    @profiles = prfles.sort_by do |p|
      if p.profile_type_id == "user" then 
        User.find(p.user_id).last_name
      else Workgroup.find(p.workgroup_id)[:name]
      end
    end
    # @profiles = prfles
    @carriers = Tag.find(:all, :conditions => "tags.tag_type_id = 'insurance_carriers'", :order => "name").map {|t| [t.name, t.id] }
    session[:admin_type] = 'customer_admin'    
  end  

end
