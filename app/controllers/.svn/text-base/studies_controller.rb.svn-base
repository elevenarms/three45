class StudiesController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_referral
  before_filter :initialize_workflow_engine

  def index
    render :partial => 'index'
  end

  def new
    study_type = 'diag_images'
    study_type = 'diag_tests' if params.has_key? 'diag_tests'

    render :partial => 'edit_new_study_detail', :locals => { :study_type => study_type }
  end

  def create
    study = ReferralStudy.new({:study_type_tag_id=>params['study_type'],
                             :study_modality_tag_id=>params['modality'],
                             :location_tag_id=>"tag_provider_type_physician",
                             :location_detail_tag_id=>"tag_provider_type_physician",
                             :body_part=>params['body_part'],
                             :additional_comments=>params['instructions']})
                             
    @engine.attach_study( :study => study )
    
    render :partial => 'index'
  end

  def edit
    referral_study = ReferralStudy.find( params['referral_study_id'] )

    # use saved study type unless observed control overrides (through subsequent edit action invocations)
    study_type = referral_study.study_type_tag.id
    study_type = 'diag_images' if params.has_key? 'diag_images'
    study_type = 'diag_tests' if params.has_key? 'diag_tests'

    # load saved modality
    modality = referral_study.study_modality_tag.id

    render :partial => 'edit_study_detail', :locals => { :referral_study => referral_study, :study_type => study_type, :modality => modality }
  end

  def update
    referral_study = ReferralStudy.find( params['referral_study_id'] )

    referral_study.study_type_tag_id = params['study_type']
    referral_study.study_modality_tag_id = params['modality']
    referral_study.body_part = params['body_part']
    referral_study.additional_comments = params['instructions']
    referral_study.save!
    
    render :partial => 'index'
  end

  def destroy
    ReferralStudy.destroy(params['referral_study_id'])

    render :partial => 'index'
  end
end
