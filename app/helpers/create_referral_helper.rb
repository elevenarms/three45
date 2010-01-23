module CreateReferralHelper
  include RequestHelper
  include InsuranceHelper
  include FilesHelper
  include FaxesHelper

  def display_referral_request
    @target_referral.wizard_step_complete? :service_request
  end

  def edit_referral_request
    @target_referral.wizard_step == :service_provider.to_s || @target_referral.wizard_step == nil
  end

  def display_referral_patient
    @target_referral.wizard_step_complete? :patient
  end

  def edit_referral_patient
    @target_referral.wizard_step == :service_request.to_s
  end

  def display_referral_insurance
    @target_referral.wizard_step_complete? :insurance
  end

  def edit_referral_insurance
    @target_referral.wizard_step == :patient.to_s
  end



  def display_referral_referrer
    @target_referral.wizard_step_complete? :referring_physician
  end

  def edit_referral_referrer
    @target_referral.wizard_step_complete? :insurance
  end

  def display_referral_files
    @target_referral.wizard_step_complete? :files
  end

  def edit_referral_files
    unless @target_referral.created_by_user.is_physician?
      @target_referral.wizard_step == :referring_physician.to_s
    else
      @target_referral.wizard_step == :insurance.to_s
    end
  end




  # def display_referral_files
  #   @target_referral.wizard_step_complete? :files
  # end
  #
  # def edit_referral_files
  #   @target_referral.wizard_step == :insurance.to_s
  # end

  def display_referral_faxes
    @target_referral.wizard_step_complete? :faxes
  end

  def edit_referral_faxes
    @target_referral.wizard_step == :files.to_s
  end

# def display_referral_referrer
#   @target_referral.wizard_step_complete? :faxes
# end
#
# def edit_referral_referrer
#   @target_referral.wizard_step == :faxes.to_s
# end

#  def display_referral_submit
#    unless @target_referral.created_by_user.is_physician?
#      @target_referral.wizard_step_complete? :referring_physician
#    else
#      @target_referral.wizard_step_complete? :faxes
#    end
#  end

  def display_referral_submit
    @target_referral.wizard_step_complete? :files
  end
end
