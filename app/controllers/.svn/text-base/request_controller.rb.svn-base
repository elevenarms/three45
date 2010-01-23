class RequestController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_referral
  before_filter :initialize_workflow_engine

  def show
    render :partial => 'show'
  end

  def edit
    # determine which referral_type editing partial context to present
    @referral_tag_type_id = 'tag_consultation_type'   # default
    referral_type_selection = @target_referral.referral_type_selections.first unless @target_referral.referral_type_selections == nil
    @referral_tag_type_id = referral_type_selection.tag_id unless referral_type_selection == nil

    # override if certain tags are included in params (these are injected by observer within editor for ajax-driven referral_type change)
    Tag.find_all_by_tag_type_id( 'referral_standard_types' ).each do |referral_standard_type|
      @referral_tag_type_id = referral_standard_type.id if params.has_key? referral_standard_type.id
    end
    
    render :partial => 'edit' unless @referral_tag_type_id == 'tag_ancillary_studies_type'
    render :partial => 'edit_ancillary' if @referral_tag_type_id == 'tag_ancillary_studies_type'
  end

  def create
    referral_type_selection = ReferralTypeSelection.new( { :tag_type_id => "referral_standard_types", :tag_id=>params['type'], :diagnosis_text=>params['diagnosis'], :additional_instructions=>params['instructions'] } )
    @engine.assign_service_requested( :referral_type_selection => referral_type_selection )    
  
    @engine.referral.wizard_step_mark_complete :service_request
    @engine.referral.save!

    if @engine.referral.wizard_step == :service_request.to_s
      render :partial => 'next_step'
    else
      render :update do |page|
        page.replace_html 'referral_request', :partial => 'request/show', :locals=>{ :edit_disabled => false }
      end
    end
  end
end
