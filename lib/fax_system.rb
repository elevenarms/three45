#
# Fax Integration logic for the Interfax third-party fax service. This service utilizes a SOAP API.
#
# Note: The integration logic only runs in production mode by default.
#
#
module FaxSystem
  require "soap/wsdlDriver"
  require 'ruby-debug'
  INTERFAX_USERNAME = "three45_out_staging"
  INTERFAX_PASSWORD = "test123"
  INTERFAX_WSDL_URL = "http://ws.interfax.net/dfs.asmx?wsdl"

  
  def generate_password     # generates a random easily readable password
  chars = ("a".."z").to_a + ("1".."9").to_a
  Array.new(8, '').collect{chars[rand(chars.size)]}.join  #change the first integer in this line to set the password length (currently 8 chars)
  end
  
  def set_initial_password_uns   
    @uns_admin_pass = generate_password                                                         #the user account sent via fax for UNS login will have  
    #this needs to be chagned to the user_controller update password method         # the same login username as the subdomain name of the UNS workgroup
    @uns_admin_user.update_attributes({:password => @uns_admin_pass, :password_confirmation => @uns_admin_pass})     
  end

    def send_fax_notification
    if @target_referral.request_flag?
      @uns_workgroup = Workgroup.find(:first, :conditions => {:id => @target_referral.active_source.workgroup_id})
      @request_q = true #record that this referral is a request in a variable to avoid a second db querry
      @active_source = @target_referral.active_target 
      @active_target = ReferralSource.find(:first, :conditions => {:id => @target_referral.active_source_id})
    else
      @uns_workgroup = Workgroup.find(:first, :conditions => {:id => @target_referral.active_target.workgroup_id})
      @active_source = ReferralSource.find(:first, :conditions => {:id => @target_referral.active_source_id})
      @active_target = @target_referral.active_target
    end
    #the user account sent via fax for UNS login will have the same login username as the subdomain name of the UNS workgroup
    
   
    
    @uns_admin_user = User.find(:first , :conditions => {:login=>@uns_workgroup.subdomain})
   
    factory = SOAP::WSDLDriverFactory.new(INTERFAX_WSDL_URL)
    driver = factory.create_rpc_driver
    
    #Fax Number
    if @active_target.user_id.nil?  #if the userid in active target is nil than the target of the referral is a workgroup and the workgroup fax should be used
      @faxnumber =  @uns_workgroup.fax_number
    else
      @target_user = User.find(@active_target.user_id)
      unless @target_user.fax_number.nil? #if the user has a fax number, use it to send the fax
        @faxnumber = @target_user.fax_number 
      else #if the user doesn't have a fax number use the workgroup fax number
        @faxnumber =  @uns_workgroup.fax_number
      end
    end
    debugger
    @filetype = "html"
    
    unless @uns_admin_user.has_logged_in?   
      set_initial_password_uns
      if @request_q
        @data = render_to_string :partial => 'faxes/req_cover_page_initial' , :use_full_path => true  #uns_cover_page partial as string 
      else
        @data = render_to_string :partial => 'faxes/uns_cover_page_initial' , :use_full_path => true  #uns_cover_page partial as string 
      end
        
    else
      if @request_q
        @data = render_to_string :partial => 'faxes/req_cover_page' , :use_full_path => true
      else
        @data = render_to_string :partial => 'faxes/uns_cover_page' , :use_full_path => true
      end
     end
    if ENV["RAILS_ENV"] == "production"
    @result = driver.SendCharFax(   :Username   => INTERFAX_USERNAME, 
                                    :Password   => INTERFAX_PASSWORD,
                                    :FaxNumber  => @faxnumber,
                                    :Data       => @data, 
                                    :FileType   => @filetype)
  
    else
      flash[:notice]="UNS Referral Sent (fax not sent in dev ENV)"
      
    end
  end
  
  def extract_phone_number(string, default_area_code = "512")
    phone_10 = /.*?([1-9][0-9]{2}).*?([1-9][0-9]{2}).*?([0-9]{4}).*/
    result = phone_10.match(string) #found 10-digit number
    unless result
      phone_7 = /.*?([1-9][0-9]{2}).*?([0-9]{4}).*/
      result = phone_7.match(string) #found 7-digit number (no area code)
    end
    unless result
      return string  #no phone number found so use the string as is
    end
 
    return_string = result.captures.to_s
    return_string = default_area_code + return_string if return_string.length == 7
    return return_string

  end
end
