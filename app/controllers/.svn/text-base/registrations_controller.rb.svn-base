class RegistrationsController < ApplicationController

  def new
    session[:plan] =  params[:plan]
    session[:fee] = params[:fee]
    @wkgrp = Workgroup.new
    @usr = User.new
    @workgroup_name_error = ""
    @user_name_error = ""
    @email_error = ""
    @physician_reg = false
  end
  
  def capture_form1
    @workgroup_name_error = ""
    @user_name_error = ""
    @email_error = ""
    @wkgrp = Workgroup.new(params[:workgroup])
    @usr = User.new(params[:user])
    flash.clear
    wkgrp = Workgroup.find(:all, :conditions => "subdomain = '#{@wkgrp[:subdomain]}'")
    @registration = Registration.find(:all, :conditions => "subdomain = '#{@wkgrp[:subdomain]}'")
    if params[:physician_reg] == '1' then
      @physician_reg = true 
    else @physician_reg = false
    end
    unless wkgrp.empty? && @registration.empty?  then 
      @workgroup_name_error = "The group ID you chose, #{@wkgrp[:subdomain]}, is already taken.  Please try another."
      @wkgrp[:subdomain] = ""
    end
    temp_usr = User.find(:first, :conditions=> "email = '#{ @usr[:email] }'")
    unless temp_usr.nil? then
      @email_error = "You may have mistyped your email address, since another user in the system already has what you typed.  Pleast try again"
    end
    unless User.find(:all, :conditions => "login = '#{@usr[:login]}'").empty?   then 
      @user_name_error = "The login name you chose, #{@usr[:login]} is already taken.  Please try another."
      @usr[:login] = ""
    end
    if @workgroup_name_error == "" && @user_name_error == "" && @email_error == ""  then 
      # store all the form1 info into a registration record and move on to form 2
      @registration = Registration.new(:workgroup_name => @wkgrp[:name], :last_name => @usr[:last_name], :first_name => @usr[:first_name],
        :login => @usr[:login], :email => @usr[:email], :password => params[:pwd], :subdomain => @wkgrp[:subdomain], :office_phone => @wkgrp[:office_number],
        :office_fax => @wkgrp[:fax_number], :plan => session[:plan], :fee => session[:fee], :physician_reg => @physician_reg, :status_code => "saved first screen only")
      unless @registration.save
        flash[:error] = "Trouble completing the registration.  Please contact three45 at 877-345-3553 ext. 205 for help completing this registration"
      end
      Notification.deliver_registration_received("Initial registration record written")
      @ccards = [['Visa', 'VISA'],  ['Mastercard', 'MC'], ['AMEX', 'AMEX']]
      @months = [["1-January", "JAN"], ["2-February", "FEB"], ["3-March", "MAR"], ["4-April", "APR"], ["5-May", "MAY"], ["6-June", "JUN"], 
        ["7-July", "JUL"], ["8-August", "AUG"], ["9-September", "SEP"], ["10-October", "OCT"], ["11-November", "NOV"], ["12-December", "DEC"] ]
      @years = [["2008", "2008"], ["2009", "2009"], ["2010", "2010"], ["2011", "2011"]]
      session[:workgroup_subdomain] = @wkgrp[:subdomain]
      render :template => "/registrations/new2"
    else  
      flash[:error] = "Please see field errors below"
      render :template => '/registrations/new'
    end
  end


  def create
    #have collected two forms worth of stuff
    @agree_error = ""
    @npi_error = ""
    @med_license_error = ""  
    @ccard_error = ""
    @registration = Registration.new(params[:registration])   
    #first check to see if they have checked the boxes to agree with both agreements
    @agree_error = "To complete the registration you must agree to the terms of both the three45 HIPAA Business Associate and the three45 Service agreements"  unless params[:hipaa_agree] == '1' && params[:service_agree] == '1'
    # no NPI?
    @npi_error = "You must provide the NPI number for the physician you have named above"   if @registration[:physician_npi] == ""       
    #no medical license?
    @med_license_error = "You must provide the medical license number for the physician you have named above"    if  @registration[:physician_med_license] == ""  
    #check the credit card
    unless session[:plan] == "Free"
      if @registration.card_type == 'VISA' or @registration.card_type == 'MC' then
        #Visa and Mastercard
        @ccard_error = "Invalid Visa or Mastercard card number.   "  if @registration[:card_number].length != 16 
      else @ccard_error = "Invalid AMEX card number. "  if @registration[:card_number].length != 15
      end      
      @ccard_error += "Expiration date not correct. "  if @registration[:expiration_month].nil? || @registration[:expiration_year].nil? 
      @ccard_error += "The zip code is invalid.  "  if @registration[:billing_zip_code].length != 5
      unless @ccard_error == "" 
        @registration[:card_number] = ""  
        @ccard_error += "Please enter again."      
      end
    end  #not free plan
    unless @agree_error == "" && @npi_error == "" && @med_license_error == "" && @ccard_error == "" then
      flash[:error] = "Please see field errors below"
      @ccards = [['Visa', 'VISA'],  ['Mastercard', 'MC'], ['AMEX', 'AMEX']]
      @months = [["1-January", "JAN"], ["2-February", "FEB"], ["3-March", "MAR"], ["4-April", "APR"], ["5-May", "MAY"], ["6-June", "JUN"], 
        ["7-July", "JUL"], ["8-August", "AUG"], ["9-September", "SEP"], ["10-October", "OCT"], ["11-November", "NOV"], ["12-December", "DEC"] ]
      @years = [["2008", "2008"], ["2009", "2009"], ["2010", "2010"], ["2011", "2011"]]
      render :template => '/registrations/new2'  and return
    else 
      # now get everything set up
      # add the new values to the registration record already created
      @registration = Registration.find(:first, :conditions => "subdomain = '#{session[:workgroup_subdomain]}'")
      @registration.update_attributes(params[:registration])
    end

    #Do all the error checking and creation of new records and generate a confirmation
    # workgroup, registering user, physician user, and three45 admin user
    # also have to add associations: user_groups, workgroup_users, profile(s) for physician and workgroup
    reg_update = Hash.new  #a place to put all the updates being created    
    unless @registration[:num_physicians] == 1 then
      subtype = "workgroup_subtype_phy_practice"
    else subtype = "workgroup_subtype_solo_practice"
    end
    #create workgroup
    wkgrp = Workgroup.new(:workgroup_subtype_id => subtype, :workgroup_state_id => 'active', :workgroup_type_id => 'ppw',
      :name => @registration[:workgroup_name], :subdomain => @registration[:subdomain], :office_number => @registration[:office_phone], 
      :fax_number => @registration[:office_fax], :anyone_can_sign_referral_flag => true, :subscriber_flag => true, :description => " ")
    unless wkgrp.save then
      flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help completing this registration" 
      reg_update[:status_code] = "workgroup failed to create" 
      @registration.update_attributes(reg_update)
      render :template => "/registrations/failure" and return
    end
    reg_update[:workgroup_id] = wkgrp.id
    #workgroup profile
    prfle = Profile.new
    prfle.workgroup = wkgrp
    prfle[:profile_type_id] = 'workgroup'
    prfle[:display_name] = @registration[:workgroup_name]
    unless prfle.save then
      flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help  completing this registration"
      reg_update[:status_code] = "workgroup profile failed to create"
      @registration.update_attributes(reg_update)
      render :template => "/registrations/failure" and return
    end        
    # create registrant user
    chars = ("a".."z").to_a + ("1".."9").to_a + ("A".."Z").to_a
    password = Array.new(8, '').collect{chars[rand(chars.size)]}.join  #change the first integer in this line to set the password length (currently 8 chars)   
    usr_temp = {:login => @registration[:login], :email => @registration[:email], :password => password, :password_confirmation => password, 
      :first_name => @registration[:first_name], :last_name => @registration[:last_name], :middle_name => @registration[:middle_name]}   
    usr = User.new(usr_temp)    
    unless usr.save then
      flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help completing this registration" 
      reg_update[:status_code] = "registering user failed to create"
      @registration.update_attributes(reg_update)
      render :template => "/registrations/failure" and return
    end 
    reg_update[:password] = password    
    reg_update[:user_id] = usr.id
    username =  @registration[:last_name] 
    #workgroup_user for registrant
    wkgrp_user = WorkgroupUser.new
    wkgrp_user[:workgroup_id] = wkgrp[:id]
    wkgrp_user[:user_id] = usr[:id]
    unless wkgrp_user.save then
      flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help completing this registration"
      reg_update[:status_code] = "workgroup-registrant association failed to create"
      @registration.update_attributes(reg_update)
      render :template => "/registrations/failure" and return
    end
    #user_group for registrant
    user_group = UserGroup.new
    if @registration[:physician_reg] then
      user_group[:group_id] = "ppw_admin"
    else user_group[:group_id] = "ppw_physician_user"
    end
    user_group[:user_id] = usr.id
    unless user_group.save then
      flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help completing this registration"
      reg_update[:status_code] = "user_group for registrant association (whether physician or not) failed to create"
      @registration.update_attributes(reg_update)
      render :template => "/registrations/failure" and return
    end
    
    #create physician user unless the registrant was a physician
    unless @registration[:physician_reg]
      #find a unique login id
      login_id = @registration[:physician_last_name] 
      temp_id = login_id
      usr2 = nil
      x = 1
      usr2 = User.find_by_login(login_id)
      while !usr2.nil? && (x < 25) do        
        if usr2.nil? then puts "usr2 is nil" + ";  x=" + "#{ x }" + "; login_id=" + "#{ login_id }" end
        x += 1
        login_id = temp_id + x.to_s
        usr2 = User.find_by_login(login_id)
      end   
      password = Array.new(12, '').collect{chars[rand(chars.size)]}.join  #password never used - just keeps physician accounts safe
      usr2 = User.new(:login => login_id, :password => password, :password_confirmation => password, 
        :first_name => @registration[:physician_first_name], :last_name => @registration[:physician_last_name], 
        :middle_name => @registration[:physician_middle_name])
      unless usr2.save  then
        flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help with completing this registration"
        reg_update[:status_code] = "physician user failed to create"
        @registration.update_attributes(reg_update)
        render :template => "/registrations/failure" and return
      end
      reg_update[:physician_uid] = usr2.id
      username =  @registration[:physician_last_name]
      #workgroup-user association for physician when differnet from registrant
      wkgrp_user = WorkgroupUser.new
      wkgrp_user[:workgroup_id] = wkgrp[:id]
      wkgrp_user[:user_id] = usr[:id]
      unless wkgrp_user.save then
        flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help  completing this registration"
        reg_update[:status_code] = "workgroup-physician association failed to create"
        @registration.update_attributes(reg_update)
        render :template => "/registrations/failure" and return
      end  
      #user_group for registrant
      user_group = UserGroup.new
      user_group[:group_id] = "ppw_physician_user"
      user_group[:user_id] = usr2.id
      unless user_group.save then
        flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help completing this registration"
        reg_update[:status_code] = "physician-group association failed to create"
        @registration.update_attributes(reg_update)
        render :template => "/registrations/failure" and return
      end
      usr = usr2
    end      
    
    #whomever the last user is that got created is the physician, so he gets a profile
    prfle = Profile.new
    prfle.user = usr
    prfle[:profile_type_id] = 'user'
    prfle[:display_name] = username
    unless prfle.save then
      flash[:error] = "Failed to create registration.  Please contact three45 at 877-345-3553 ext. 205 for help  completing this registration"
      reg_update[:status_code] = "physician profile failed to create (could be physician or registrant)"
      @registration.update_attributes(reg_update)
       render :template => "/registrations/failure" and return
    end 
    #everything worked
    # save any values created along the way and display the SUCCESS confirmation page
    reg_update[:status_code] = "Successful registration - first try."
    @registration.update_attributes(reg_update)
    Notification.deliver_registration_received("Successful completion")
    render :template => "/registrations/confirmation" and return
  end
  
  def list
    #lists recent registrations
    params[:num_reg] = 25 if params[:num_reg] == params.default
    @registrations = Registration.find(:all, :order=>'created_at DESC', :limit=>params[:num_reg])
  end
  
  def show
    #find a specific registration by registrant login
    @registration = Registration.find(:all, :conditions=>"subdomain = '#{params[:reg_subdomain]}'")
  end
end  
