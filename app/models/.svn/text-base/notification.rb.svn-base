#
# ActionMailer class that can send an email notification to users and/or patients
#
# See the ActionMailer documentation for more details on using this class
#
#
#
class Notification < ActionMailer::Base
  APP_NAME = "three45"
  DEFAULT_FROM = "three45 - Referral Management System <noreply@three45.net>"
  
  def sysadmin(message_content)
     # for sending messages to three45 system administrators
     wkgrp = Workgroup.find(:first, :conditions=>"name = 'three45 Administration' ")
     recipients   recipient_list(wkgrp.id)
     from         DEFAULT_FROM
     body         message_content
     subject      "three45 Sys Admin message"
  end
  
  def registration_received(message_content)
    # to let us know an online registration has been received
     wkgrp = Workgroup.find(:first, :conditions=>"name = 'three45 Administration' ")
     recipients   recipient_list(wkgrp.id)
     from         DEFAULT_FROM
     body         message_content   
     subject      "three45 sys admin: New online registration"     
  end

  def referral_details_to_patient(referral)
     patient = referral.referral_patients.first
     setup_email(patient)
     @subject += "Referral Notification"
     @body["referral"] = referral
  end
  
  def new_referral(workgroup, referral)
    recipients endpoint_recipient(referral.active_target)
    from       DEFAULT_FROM
    subject    "A New Referral Is Awaiting Acceptance"
    body       :r => referral, :t => Workgroup.find(:first, :conditions => {:id => referral.active_target.workgroup_id})
  end
  
  def new_request_referral(workgroup, referral)
    recipients endpoint_recipient(referral.active_source)
    from       DEFAULT_FROM
    subject    "A New Request For Referral Is Awaiting Your Action"
    body       :r => referral, :s => Workgroup.find(:first, :conditions => {:id => referral.active_source.workgroup_id})
  end
  
  def new_info(workgroup, to, from)
    recipients  workgroup_recipient(workgroup, to, from)
    from       DEFAULT_FROM
    subject    "New Information Has Been Added To An Existing Referral"
    body       :to => to, :from => from
  end
  
  def action_requested(workgroup, to, from)
    recipients  workgroup_recipient(workgroup, to, from)
    from       DEFAULT_FROM
    subject    "There Is A Referral That Requires Your Action"
    body       :to => to, :from => from
  end
  
  #
  # Helpers
  #

  def setup_email(user)
    @recipients = "#{user.email}" if user
    @from       = DEFAULT_FROM
    @subject    = "#{APP_NAME}: "
    @sent_on    = Time.now
    @headers['Content-Type'] = "text/plain; charset=UTF8; format=flowed"
  end
 
  # Takes a workgroup_id as a param; finds all users for the given workgroup_id and builds an array of all non-null email addresses
  def recipient_list(workgroup)
    list = Array.new
    wrkgrpusrs = WorkgroupUser.find(:all, :conditions => {:workgroup_id => workgroup})
    wrkgrpusrs.each do |usr|
      s = User.find(:first, :conditions => {:id => usr.user_id})
      list << s.email unless s.email.nil? || s.email == ""
    end
    if list.length < 1
      list << "blank@example" #duct-tape-uber-hack an empty array of recipients breaks the mailer and cause the referral to not be sent...
    end
      return list
    end
    
  def workgroup_recipient(workgroup, to, from)
    # figure out which endpoint gets the email
    if workgroup.id == to.workgroup_id then
      #using target - could be physician or workgroup
      return endpoint_recipient(to)
    else
      #using source - always a physician
      return endpoint_recipient(from)
    end

  end

  def endpoint_recipient(endpoint)
    #given endpoint, return list of one email address of either physician or workgroup
    list = Array.new
    if !endpoint.user.nil? && endpoint.user.profile.notify_email != "" then
      list << endpoint.user.profile.notify_email
      return(list)
    end
    #send email to workgroup notify_email if the target is a workgroup OR if the user has no email
    if endpoint.workgroup.profiles[0].notify_email != "" then
      list << endpoint.workgroup.profiles[0].notify_email
    else list << "blank@example" #duct-tape-uber-hack an empty array of recipients breaks the mailer and cause the referral to not be sent...
    end
  end
end
  