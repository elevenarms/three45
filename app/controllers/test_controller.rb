class TestController < ApplicationController

  def show_referral
    @referral = Referral.find(params[:id])
    pp @referral.inspect
    pp @referral.active_target.inspect 
    pp @referral.active_target.user.inspect

    pp @referral.active_target.user.profile.inspect
    pp @referral.active_target.user.profile.notify_email
    pp @referral.active_target.user.workgroup_user.workgroup.profiles[0].notify_email    
    
    redirect_to :controller => "admin", :action => "index"

  end
end
