module StudiesHelper
  def study_type_options(selected_study_type = nil)
    unless selected_study_type == 'diag_tests'
      html = "<option value = 'diag_images' selected = 'selected'>Diagnostic Imaging</option><option value = 'diag_tests'>Diagnostic Tests</option>"
    else
      html = "<option value = 'diag_images'>Diagnostic Imaging</option><option value = 'diag_tests' selected = 'selected'>Diagnostic Tests</option>"
    end
    
    html
  end

  def modality_options(selected_study_type = 'diag_images', selected_modality_type_id = nil)
    html = ""
    @current_referral_target = ReferralTarget.find(:first, :conditions => {:id => @engine.referral.active_target_id})
    if @current_referral_target.user_id?
       @current_profile = Profile.find(:first, :conditions => {:user_id => @current_referral_target.user_id}) 
    else
          @current_profile = Profile.find(:first, :conditions => {:workgroup_id => @current_referral_target.workgroup_id})
    end
     
    ProfileTag.find(:all, :conditions => { :tag_type_id => selected_study_type, :profile_id => @current_profile.id}).each do |profile_tag|  
        html += "<option value = '#{profile_tag.tag_id}'>" + profile_tag.tag.name + "</option>"
    end

    html
  end
end
