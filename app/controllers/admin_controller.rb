class AdminController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :three45_data_entry_required
  
  include FaxSystem

  def index
    @wkgrps = Workgroup.find(:all, :order => "name" ).map {|w| [w.name, w.id] }
    @users = User.find(:all, :order => "last_name" ).map {|u| [u.full_name, u.id] }
    # TODO: create @physicians that is list of just physicain users
    @carriers = Tag.find(:all, :conditions => "tags.tag_type_id = 'insurance_carriers'", :order => "name").map {|t| [t.name, t.id] }
    @specialties = Tag.find(:all, :conditions => "tags.tag_type_id = 'specialties'", :order => "name").map {|t| [t.name, t.id] }
    @tag_types = TagType.find(:all, :conditions => "parent_tag_type_id IS NULL", :order => "name").map {|tt| [tt.name, tt.id]}
    session[:admin_type] = 'admin'
  end
  #
  #
  #  W O R K G R O U P
  #
  #
  def new_workgroup # set up form to fill out
    @wkgrp = Workgroup.new
    @user = User.new
    @address = Address.new
    @wkgrp_subtypes = WorkgroupSubtype.find(:all, :order => "name" ).map {|w| [w.name, w.id] }
    @groups = Group.find(:all, :order => "name" ).map {|g| [g.name, g.id] }
    @address_types = AddressType.find(:all, :order => "name" ).map {|a| [a.name, a.id] }
    @subscriber_types = [["Non-Subscriber","false"], ["Subscriber","true"]]
  end

  def create_workgroup
    ## create the workgroup with the form data
    # Get ready to go back to the new_workgroup form if errors
    @user = User.new
    @address = Address.new    
    @wkgrp_subtypes = WorkgroupSubtype.find(:all, :order => "name" ).map {|w| [w.name, w.id] }
    @groups = Group.find(:all, :order => "name" ).map {|g| [g.name, g.id] }
    @address_types = AddressType.find(:all, :order => "name" ).map {|a| [a.name, a.id] }
    @subscriber_types = [["Non-Subscriber","false"], ["Subscriber","true"]]
    # add the first user, and
    # get ready to add more users
    params[:workgroup][:fax_number] = extract_phone_number(params[:workgroup][:fax_number])
    params[:workgroup][:office_number] = extract_phone_number(params[:workgroup][:office_number])
    @wkgrp = Workgroup.new(params[:workgroup])
    @wkgrp[:workgroup_state_id] = 'active'
    @wkgrp[:workgroup_type_id] = 'ppw'
    @wkgrp[:anyone_can_sign_referral_flag] = 1
    render :template=>'admin/new_workgroup' and return unless @wkgrp.save
    
    prfle = Profile.new
    prfle.workgroup = @wkgrp
    prfle[:profile_type_id] = 'workgroup'
    unless prfle.save then
      flash[:error] = "1001: Workgroup created OK. But not its profile.  Skip this workgroup and go on to the next group."
      render :template=>'admin/new_workgroup' and return
    end
    params[:user][:fax_number] = extract_phone_number(params[:user][:fax_number])
    @user = User.new(params[:user])
    render :template=>'admin/new_workgroup' and return unless @user.save

    @wkgrp_user = WorkgroupUser.new
    @wkgrp_user[:workgroup_id] = @wkgrp[:id]
    @wkgrp_user[:user_id] = @user[:id]
    unless  @wkgrp_user.save then
      flash[:error] = "1002: Workgroup and user created OK, but not their association.  Move on to the next group "
      render :template=>'admin/new_workgroup' and return
    end


    @user_group = UserGroup.new
    @user_group[:group_id] = params[:group][:id]
    @user_group[:user_id] = @user[:id]
    unless @user_group.save  then
      flash[:error] = "1003: Workgroup and user created OK, but not user-group association.  Move on to the next group "
      render :template=>'admin/new_workgroup' and return
    end

    if @user_group[:group_id] == 'ppw_physician_user' then
      prfle = Profile.new
      prfle.user = @user
      prfle[:profile_type_id] = 'user'
      unless prfle.save  then
        flash[:error] = "1004: Workgroup and user created OK, but not profile for physician user.  Move on to the next group "
        render :template=>'admin/new_workgroup' and return
      end

    end

    @address = Address.new(params[:address])
    unless  @address.save  then
      flash[:error] = "1005: Workgroup and user created OK, problem with address.  Move on to the next group or add more users in this group "
      render :template=>'admin/new_workgroup' and return
    end

    @wkgrp_address = WorkgroupAddress.new
    @wkgrp_address.address = @address
    @wkgrp_address.workgroup = @wkgrp
    @wkgrp_address.address_type = AddressType.find(params[:address_type][:id])
    unless  @wkgrp_address.save  then
      flash[:error] = "1006: Workgroup, user, and address created OK, problem address could not be associated with workgroup.  Move on to the next group or add more users in this group "
      render :template=>'admin/new_workgroup' and return
    end

    @user = User.new
    @groups = Group.find(:all, :order => "name" ).map {|g| [g.name, g.id] }
    redirect_to :action=>'new_user', :workgroup=>{:id=>@wkgrp[:id]}
    
  end

  def edit_workgroup # display current info and allow edit
    @wkgrp = Workgroup.find(params[:workgroup][:id])
    @wkgrp_users = @wkgrp.workgroup_users
    @prfle = Profile.find_by_workgroup_id(@wkgrp.id)
    @subscriber_types = [["Non-Subscriber","false"], ["Subscriber","true"]]
  end

  def update_workgroup # both workgroup & profile tables
    @wkgrp = Workgroup.find(params[:id])
    @wkgrp_users = @wkgrp.workgroup_users
    @subscriber_types = [["Non-Subscriber","false"], ["Subscriber","true"]]
    @prfle = Profile.find_by_workgroup_id(@wkgrp.id)
    if @prfle.nil? && params[:workgroup][:workgroup_subtype_id] == "workgroup_subtype_phy_practice" then
      #changing to multi-physician practice - add workgroup profile
      params[:profile] = Hash[:profile_type_id =>"workgroup", :display_name => @wkgrp.name, :workgroup_id => @wkgrp.id]    
      @prfle = Profile.new(params[:profile])       
      flash[:error] = "Profile not saved"   unless @prfle.save 
    end
    if !@prfle.nil? && params[:workgroup][:workgroup_subtype_id] == "workgroup_subtype_solo_practice" then
      #changing to a solo practice - remove workgroup profile
      Profile.delete(@prfle.id)   
      @prfle = nil      
    end
    params[:workgroup][:fax_number] = extract_phone_number(params[:workgroup][:fax_number])
    params[:workgroup][:office_number] = extract_phone_number(params[:workgroup][:office_number])
    if @wkgrp.update_attributes(params[:workgroup]) && (@prfle.nil? || @prfle.update_attributes(params[:profile]))
      flash[:notice] = "workgroup info and profile updated"
      redirect_to :controller => 'admin', :action => 'index' and return
    else
      flash[:error] =  "1007: Error updating workgroup or its profile"
      render :action => 'edit_workgroup' and return
    end
  end

  def new_address_for_workgroup
    @wkgrp = Workgroup.find_eager_paranoid(params[:workgroup][:id])
    @address_types = AddressType.find(:all, :order => "name" ).map {|w| [w.name, w.id] }
  end

  def add_address_to_workgroup
    @wkgrp = Workgroup.find(params[:workgroup][:id])
    @address_type = AddressType.find(params[:address_type][:id])
    @address = Address.new(params[:address])
    @wkgrp_address = WorkgroupAddress.new
    unless @address.save then
      flash[:error] = "Problem adding a new address"
    end
    @wkgrp_address.address = @address
    @wkgrp_address.workgroup = @wkgrp
    @wkgrp_address.address_type = @address_type
    flash[:error] = "Problem adding new address" unless @wkgrp_address.save
    @address_types = AddressType.find(:all, :order => "name" ).map {|w| [w.name, w.id] }
    render :template=>"admin/new_address_for_workgroup"
  end

  def delete_address
    workgroup_address = WorkgroupAddress.find(params[:id])
    wkgrp_id = workgroup_address[:workgroup_id]
    address= Address.find(workgroup_address[:address_id])
    WorkgroupAddress.destroy(workgroup_address)
    Address.destroy(address)
    @wkgrp = Workgroup.find(wkgrp_id)
    @address_types = AddressType.find(:all, :order => "name" ).map {|w| [w.name, w.id] }
    render :template=>"admin/new_address_for_workgroup"
  end

  def create_photo_for_workgroup
    workgroup_id = params[:profile_image][:profile_id]
    @prfle = Profile.find_by_workgroup_id(workgroup_id)
    params[:profile_image][:profile_id] = @prfle[:id]
    @profile_image = ProfileImage.new(params[:profile_imageg]) 
    flash[:error] = "1008: problem creating image for workgroup" unless @prfle.profile_images << @profile_image
    redirect_to :action => 'index' and return
  end
  
  #
  #
  # UNS Creation: workgroup, admin user, physician user, etc.
  #
  #
      #
      # NOT COMPLETE - DOES NOT WORK YET
      #
  
  


  #
  #
  #  U S E R
  #
  #

  def new_user
    @user = User.new
    @wkgrp = Workgroup.find(params[:workgroup][:id])
    @wkgrp_users = @wkgrp.workgroup_users
    @groups = Group.find(:all, :order => "name" ).map {|g| [g.name, g.id] }
  end

  def create_user
    @wkgrp = Workgroup.find(params[:id])
    @wkgrp_users = @wkgrp.workgroup_users
    @groups = Group.find(:all, :order => "name" ).map {|g| [g.name, g.id] }
    params[:user][:fax_number] = extract_phone_number(params[:user][:fax_number])
    @user = User.new(params[:user])
    unless @user.save
      flash[:error] = "Could not save user.  See error messages below and try again."
      render :template => 'admin/new_user' and return
    end 
    @wkgrp_user = WorkgroupUser.new
    @wkgrp_user[:workgroup_id] = @wkgrp[:id]
    @wkgrp_user[:user_id] = @user[:id]
    unless @wkgrp_user.save then
      flash[:error] = "1009: User created OK, but not association with workgroup. Move on to next user"
      render :template=>'admin/new_workgroup' and return
    end

    @user_group = UserGroup.new
    @user_group[:group_id] = params[:group][:id]
    @user_group[:user_id] = @user[:id]
   
    unless @user_group.save then
      flash[:error] = "1010: User created OK and associated with workgroup, but not group. Move on to next user"
      render :template=>'admin/new_workgroup' and return
    end
    

    if @user_group[:group_id] == 'ppw_physician_user' then
        @prfle = Profile.new
        @prfle[:user_id] = @user[:id]
        @prfle[:profile_type_id] = 'user'      
        unless @prfle.save then
          flash[:error] = "1011: User, workgroup association, and group association created OK, but not physicain profile. Move on to next user"
          render :template=>'admin/new_workgroup' and return
        end
    end
    @created_user = @user
    @user = User.new
    @groups = Group.find(:all, :order => "name" ).map {|g| [g.name, g.id] }
    @wkgrp_users = @wkgrp.workgroup_users
    @groups = Group.find(:all, :order => "name" ).map {|g| [g.name, g.id] }
    render :template => 'admin/new_user'
  end
  
  def different_user_group
    #change user between physician and non-physician
    @usr = User.find(params[:user][:id])
    @usr_group = UserGroup.find(:first, :conditions=>"user_id = '#{params[:user][:id]}'")
    @current_group = Group.find(@usr_group[:group_id])
    @groups = Group.find(:all, :order => "name").map {|g| [g.name, g.id]}  
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
    ## create a photo for a user
    user_id = params[:profile_image][:profile_id]
    @prfle = Profile.find_by_user_id(user_id)
    params[:profile_image][:profile_id] = @prfle[:id]
    @profile_image = ProfileImage.new(params[:profile_image])
    flash[:error] = "1002: problem creating photo for user" unless @prfle.profile_images << @profile_image
    redirect_to :action => 'new_photo'
  end
  #
  #
  #
  # T A G S   -  simple, parent, or child
  # 
  # 
  # 
  # 
  # to make index_tag_values callable from multiple places
  def index_tag_values_fix
    tag_type_id = params[:tag_type][:id]
    redirect_to :action => 'index_tag_values', :id => tag_type_id
  end
  # show all values for the selected tag_type
  # if a parent tag_type, then do not show the delete link
  def index_tag_values
    @tag_type = TagType.find(params[:id])
    @tags = Tag.find(:all, :conditions => "tag_type_id = '#{params[:id]}'", :order => 'name')
    @child_tag_type = nil
    @parent = nil
  end

  # tee up change to a tag value for ANY tag_type, whether simple, parent, or child
  def edit_tag_value
    @tag_type = TagType.find(params[:tag_type_id])
    @tag = Tag.find(params[:id])
    if @tag.parent_tag_id.nil? then
      @parent = @tag
    else @parent = Tag.find(@tag.parent_tag_id)  # this is a child tag
    end
    @children = []
    if @tag_type[:id] == "insurance_carriers" || @tag_type[:id] == "specialties" then
      # this is a parent tag and there MAY BE children
      @children = Tag.find(:all, :conditions => "parent_tag_id = '#{@tag[:id]}'", :order => 'name')
      if !@children.empty? then @child_tag_type = TagType.find(@children[0][:tag_type_id])
      else @child_tag_type = TagType.find(:first, :conditions => "parent_tag_type_id = '#{@tag_type[:id]}'")
      end
    end
  end

  # make the change to a tag value
  def update_tag_value
    tag = Tag.find(params[:id])
    if params[:id] == params[:parent] then # this is a simple or parent tag
      tag_type_id = tag.tag_type_id
      parent_id = nil
    else # this is a child tag
      parent_tag = Tag.find(params[:parent])
      tag_type_id = parent_tag.tag_type_id
      parent_id = parent_tag.id
    end
    tag.update_attribute(:name, params[:tag][:name])
    redirect_to :action => 'display_switch', :id => tag  , :parent => parent_id , :tag_type_id => tag_type_id
  end

  # delete a tag value for simple and child tags (not parents)
  def delete_tag_value
    tag = Tag.find(params[:id])
    parent_id = tag.parent_tag_id
    tag_type_id = tag[:tag_type_id]
    Tag.destroy(params[:id])
    redirect_to :action => 'display_switch', :id => nil, :parent => parent_id, :tag_type_id => tag_type_id
  end

  # add a tag value, whether simple, parent, or child
  def create_tag_value
    tag = Tag.new
    tag[:tag_type_id] = params[:tag][:id]
    tag[:name] = params[:tag][:name]
    parent = nil
    if params[:parent] then
      tag[:parent_tag_id] = params[:parent]
    end
    if !tag.save then flash[:error] = "new tag not created" end
    redirect_to :action => 'display_switch', :id => tag[:id], :parent => params[:parent]
  end

  #figure out whether to show the edit page for a parent or child; of the index page for simple
  def display_switch
    tag_type_id = nil
    if params[:id].nil? && params[:parent].nil? then
      # we have destroyed a simple tag value, so no tag; or we want to go to a parent tag value list
      action = 'index_tag_values'
      tag_id = params[:tag_type_id]
      tag_type_id = params[:tag_type_id]
    elsif  params[:parent] != nil then  #this is a child tag; edit parent value
      tag = Tag.find(params[:parent])
      action = 'edit_tag_value'
      tag_id = tag.id
      tag_type_id = tag.tag_type_id
    else
      children = Tag.find(:first, :conditions => "parent_tag_id = '#{params[:id]}'")
      if children.nil?  #this is a simple tag
        tag_id = Tag.find(params[:id])[:tag_type_id]
        action = 'index_tag_values'
      else  #parent tag
        tag = Tag.find(params[:id])
        action = 'edit_tag_value'
        tag_id = tag.id
        tag_type_id = tag.tag_type_id
        flash[:notice] = "Tag name updated"
      end
    end
    redirect_to :action => action, :id => tag_id, :tag_type_id => tag_type_id
  end
  
 ##
  #
  #
  #  U T I L I T I E S
  #
  #

  def undelete_workgroup_profile
    wkgrp = Workgroup.find(params[:workgroup][:id])
    @prfle = Profile.find_with_deleted(:all, :conditions=>["workgroup_id = ?", wkgrp[:id]])
    @prfle.update_attribute('deleted_at', '')
    redirect_to :action => 'index'
  end
  
  def referrals_index  #table of referrals
    if params[:show_what] == "show all" then
        @referrals = Referral.find(:all, :limit => 50, :order => params[:sort])
    else 
       @referrals = Referral.find(:all,  :limit => 50, :order => params[:sort], :conditions => "referral_state_id != 'new'")      
    end
    @show_what = params[:show_what]
    @sort = params[:sort]
  end
  
  def referral_history  #all about ONE referral
    @sort = params[:sort]
    @show_what = params[:show_what]
    @referral = Referral.find(params[:ref_id])
    @active_target = ReferralTarget.find(@referral[:active_target_id])
    @active_source = ReferralSource.find(@referral[:active_source_id])
    @log_entries = AuditLog.find(:all, :conditions => "referral_id = '#{ params[:ref_id] }' ", :order => "created_at DESC")
  end
  
  def delete_referral
    referral = Referral.find(params[:referral_id])
    referral.delete_with_cascade!
    
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_patients WHERE referral_id = '#{ params[:referral_id] }' ")
    #referral.update_attributes(:active_source_id => nil, :active_target_id => nil)
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_sources WHERE referral_id = '#{ params[:referral_id] }' ")
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_targets WHERE referral_id = '#{ params[:referral_id] }' ")
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_type_selections WHERE referral_id = '#{ params[:referral_id] }' ")
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_files WHERE referral_id = '#{ params[:referral_id] }' ")
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_messages WHERE referral_id = '#{ params[:referral_id] }' ")
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_fax_files WHERE referral_id = '#{ params[:referral_id] }' ")
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_insurance_plans WHERE referral_id = '#{ params[:referral_id] }' ")
    #referral.referral_faxes.each do |f|
      #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_fax_content_selections WHERE id = '#{ f.id }' ")
    #end
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referral_faxes WHERE referral_id = '#{ params[:referral_id] }' ")
    #ActiveRecord::Base.connection.delete("DELETE LOW_PRIORITY FROM referrals WHERE id = '#{params[:referral_id]}'  LIMIT 1")
    
    redirect_to :action => "referrals_index" , :show_what => params[:show_what], :sort => params[:sort]  
  end
  
  def show_workgroup_user_by_id  #put in a user id and/or a workgroup id and see the object(s)
    @wkgrp = Workgroup.find(params[:wid]) unless params[:wid] == ""
    @usr = User.find(params[:uid]) unless params[:uid] == ""
  end
  
end
