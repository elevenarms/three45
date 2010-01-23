require File.dirname(__FILE__) + '/../test_helper'

class WorkflowEngineTest < Test::Unit::TestCase
  def setup
    @workgroup_mccoy = workgroups(:workgroup_mccoy)
    @workgroup_kildare = workgroups(:workgroup_kildare)
    @workgroup_welby = workgroups(:workgroup_welby)
    @dr_gillespie = users(:dr_gillespie) # phys for kildare
    @quentin = users(:quentin) # phys for mccoy
    @joyce_kildare_admin = users(:joyce_kildare_admin) # admin for kildare
    @kildare_to_mccoy_new_referral = referrals(:kildare_to_mccoy_new_referral)
    @welby_to_stretch_in_progress = referrals(:welby_to_stretch_in_progress)
    @aaron = users(:aaron) # source user for welby in progress
    @stretch_brewster = users(:stretch_brewster) # target user for welby in progress
  end

  def test_should_fail_if_user_not_member
    begin
      engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_kildare)
      fail("should raise an exception")
    rescue WorkflowEngine::WorkflowEngineException => e
      # good
    end
  end

  def test_create_referral_should_fail_if_user_not_member
    begin
      engine = WorkflowEngine.create_referral(:user=>@quentin, :workgroup=>@workgroup_kildare)
      fail("should raise an exception")
    rescue WorkflowEngine::WorkflowEngineException => e
      # good
    end
  end

  def test_create_referral_should_not_allow_nil
    begin
      WorkflowEngine.create_referral
      fail "create_referral should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end

    begin
      WorkflowEngine.create_referral(:user=>@dr_gillespie)
      fail "create_referral should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_create_referral_succeeds_without_referring_user
    count = Referral.count
    source_count = ReferralSource.count
    engine = WorkflowEngine.create_referral(:user=>@dr_gillespie, :workgroup=>@workgroup_kildare)
    assert_not_nil engine
    assert_equal count+1, Referral.count
    assert_equal source_count, ReferralSource.count
    assert_not_nil engine.referral.updated_at
    assert engine.referral.updated_at > 1.minute.ago
  end

  def test_create_referral_succeeds_with_referring_user
    count = Referral.count
    source_count = ReferralSource.count
    engine = WorkflowEngine.create_referral(:user=>@dr_gillespie, :workgroup=>@workgroup_kildare, :referring_user=>@dr_gillespie)
    assert_not_nil engine
    assert_equal count+1, Referral.count
    assert_equal source_count+1, ReferralSource.count
    engine.referral.reload
    assert_not_nil engine.referral.active_source
    assert_equal 1, engine.referral.referral_sources.length
    assert_equal engine.referral.referral_sources.first.id, engine.referral.active_source.id
    assert engine.referral.updated_at > 1.minute.ago
  end

  def test_assign_referring_user_succeeds
    count = Referral.count
    source_count = ReferralSource.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    engine.assign_referring_user(:referring_user=>@dr_gillespie)
    assert_equal count, Referral.count
    assert_equal source_count, ReferralSource.count
    engine.referral.reload
    assert_not_nil engine.referral.active_source
    assert_equal 1, engine.referral.referral_sources.length
    assert_equal engine.referral.referral_sources.first.id, engine.referral.active_source.id
    assert engine.referral.updated_at > last_updated_at
    assert_equal engine.referral.active_source.display_name, engine.referral.from_name
  end

  def test_assign_referring_user_only_creates_one_source
    count = Referral.count
    source_count = ReferralSource.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    engine.assign_referring_user(:referring_user=>@dr_gillespie)
    assert_equal count, Referral.count
    assert_equal source_count, ReferralSource.count
    engine.assign_referring_user(:referring_user=>@dr_gillespie)
    assert_equal source_count, ReferralSource.count
    engine.referral.reload
    assert_not_nil engine.referral.active_source
    assert_equal 1, engine.referral.referral_sources.length
    assert_equal engine.referral.referral_sources.first.id, engine.referral.active_source.id
    assert engine.referral.updated_at > last_updated_at
    assert_equal engine.referral.active_source.display_name, engine.referral.from_name
  end

  def test_assign_referring_user_fails_if_not_new
    count = Referral.count
    source_count = ReferralSource.count
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      engine.assign_referring_user(:referring_user=>@dr_gillespie)
      fail("Exception expected")
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
    assert_equal count, Referral.count
    assert_equal source_count, ReferralSource.count
  end

  def test_assign_consultant_fails_if_type_nil
    count = Referral.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    begin
      engine.assign_consultant
      fail("should raise an exception")
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
    assert_equal count, Referral.count
  end

  def test_assign_consultant_succeeds
    count = Referral.count
    target_count = @kildare_to_mccoy_new_referral.referral_targets.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    engine.assign_consultant(:workgroup=>@workgroup_kildare)
    assert count, Referral.count
    assert_equal target_count, @kildare_to_mccoy_new_referral.referral_targets.length
    engine.referral.reload
    assert_not_nil engine.referral.active_target
    assert_equal 1, engine.referral.referral_targets.length
    assert_equal engine.referral.referral_targets.first.id, engine.referral.active_target.id
    assert_equal engine.referral.active_target.display_name, engine.referral.to_name
  end

  def test_assign_consultant_fails_when_referral_in_progress
    count = Referral.count
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      engine.assign_consultant(:workgroup=>@workgroup_kildare)
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_assign_consultant_only_deletes_targets_in_new_state
    target_to_change = referral_targets(:kildare_to_mccoy_new_target)
    target_to_change.referral_target_state_id = ReferralTargetState::DECLINED
    target_to_change.save!
    count = Referral.count
    target_count = @kildare_to_mccoy_new_referral.referral_targets.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    engine.assign_consultant(:workgroup=>@workgroup_kildare)
    assert count, Referral.count
    assert_equal target_count+1, @kildare_to_mccoy_new_referral.referral_targets.length
    engine.referral.reload
    assert_not_nil engine.referral.active_target
    assert_equal 2, engine.referral.referral_targets.length
    assert_equal engine.referral.referral_targets.first.id, engine.referral.active_target.id
  end

  def test_assign_service_requested_should_not_allow_nil
    begin
      engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
      engine.assign_service_requested
      fail "assign_service_requested should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_assign_service_requested_succeeds
    count = Referral.count
    @kildare_to_mccoy_new_referral.delete_referral_type_selections!
    type_count = ReferralTypeSelection.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    referral_type_selection = ReferralTypeSelection.new({ :tag_type_id => "referral_standard_types", :tag_id=>"tag_consultation_type", :diagnosis_text=>"Some text" })
    engine.assign_service_requested(:referral_type_selection=>referral_type_selection)
    assert_equal count, Referral.count
    assert_equal type_count+1, ReferralTypeSelection.count
    assert engine.referral.updated_at > last_updated_at
  end

  def test_assign_service_requested_succeeds_twice
    count = Referral.count
    type_count = ReferralTypeSelection.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral_type_selection = ReferralTypeSelection.new({ :tag_type_id => "referral_standard_types", :tag_id=>"tag_consultation_type", :diagnosis_text=>"Some text" })
    engine.assign_service_requested(:referral_type_selection=>referral_type_selection)
    assert_equal count, Referral.count
    assert_equal type_count, ReferralTypeSelection.count
  end

  def test_assign_service_requested_fails_when_referral_in_progress
    count = Referral.count
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      engine.assign_service_requested(:diagnosis_text=>"Some diagnosis")
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_change_consulting_user_should_not_allow_nil
    begin
      referral = referrals(:kildare_to_mccoy_4)
      engine = WorkflowEngine.new(referral, @dr_gillespie, @workgroup_kildare)
      engine.change_consulting_user
      fail "should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_change_consulting_user_should_set_to_in_progress_status_if_physician_supplied
    # create new engine for the opposite side (consulting side)
    referral = referrals(:kildare_to_mccoy_4)
    engine = WorkflowEngine.new(referral, @quentin, @workgroup_mccoy)
    last_updated_at = engine.referral.updated_at
    referral = engine.change_consulting_user(:physician_user=>users(:quentin))
    assert engine.referral.updated_at > last_updated_at
    assert_not_nil referral
    assert_equal ReferralState::IN_PROGRESS, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target
    assert_equal ReferralTargetState::IN_PROGRESS, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    assert_equal ReferralSourceState::IN_PROGRESS, source.referral_source_state_id
    referral.reload
    assert_equal engine.referral.active_target.display_name, engine.referral.to_name
    assert_equal users(:quentin).id, engine.referral.active_target.user.id
  end

  def test_assign_patient_should_not_allow_nil
    begin
      engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
      engine.assign_patient
      fail "should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_assign_patient_succeeds
    referral_patients(:kildare_to_mccoy_patient).destroy!
    count = ReferralPatient.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    patient = create_default_patient
    referral = engine.assign_patient(:referral_patient=>patient)
    assert_equal count+1, ReferralPatient.count
    assert_equal referral.id, referral.referral_patients.first.referral_id
    assert engine.referral.updated_at > last_updated_at
  end

  def test_assign_patient_succeeds_with_patient_already_assigned
    count = ReferralPatient.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    patient = create_default_patient
    referral = engine.assign_patient(:referral_patient=>patient)
    assert_equal count, ReferralPatient.count
    assert_equal referral.id, referral.referral_patients.first.referral_id
  end

  def test_assign_consultant_fails_if_type_nil
    count = Referral.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    begin
      engine.assign_consultant
      fail("should raise an exception")
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
    assert_equal count, Referral.count
  end

  def test_assign_consultant_succeeds
    count = Referral.count
    target_count = @kildare_to_mccoy_new_referral.referral_targets.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    engine.assign_consultant(:workgroup=>@workgroup_kildare)
    assert engine.referral.updated_at > last_updated_at
    assert count, Referral.count
    assert_equal target_count, @kildare_to_mccoy_new_referral.referral_targets.length
    engine.referral.reload
    assert_not_nil engine.referral.active_target
    assert_equal 1, engine.referral.referral_targets.length
    assert_equal engine.referral.referral_targets.first.id, engine.referral.active_target.id
  end

  def test_assign_consultant_fails_when_referral_in_progress
    count = Referral.count
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      engine.assign_consultant(:workgroup=>@workgroup_kildare)
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_assign_consultant_only_deletes_targets_in_new_state
    target_to_change = referral_targets(:kildare_to_mccoy_new_target)
    target_to_change.referral_target_state_id = ReferralTargetState::DECLINED
    target_to_change.save!
    count = Referral.count
    target_count = @kildare_to_mccoy_new_referral.referral_targets.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    engine.assign_consultant(:workgroup=>@workgroup_kildare)
    assert count, Referral.count
    assert_equal target_count+1, @kildare_to_mccoy_new_referral.referral_targets.length
    engine.referral.reload
    assert_not_nil engine.referral.active_target
    assert_equal 2, engine.referral.referral_targets.length
    assert_equal engine.referral.referral_targets.first.id, engine.referral.active_target.id
  end

  def test_assign_diagnosis_selections_fails_if_type_nil
    count = Referral.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    begin
      engine.assign_diagnosis_selections
      fail("should raise an exception")
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
    assert_equal count, Referral.count
  end

  def test_assign_diagnosis_selections_succeeds
    count = ReferralDiagnosisSelection.count
    target_count = @kildare_to_mccoy_new_referral.referral_targets.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    diagnosis_selections = Array.new
    diagnosis_selections << ReferralDiagnosisSelection.new
    diagnosis_selections << ReferralDiagnosisSelection.new
    engine.assign_diagnosis_selections(:diagnosis_selections=>diagnosis_selections)
    assert count+diagnosis_selections.length, ReferralDiagnosisSelection.count
    assert engine.referral.updated_at > last_updated_at
  end

  def test_assign_diagnosis_selections_fails_when_referral_in_progress
    count = Referral.count
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      engine.assign_diagnosis_selections
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_attach_study_should_not_allow_nil
    begin
      engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
      engine.attach_study
      fail "should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_attach_study_should_fail_if_not_new
    begin
      engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
      engine.attach_study
      fail "should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_attach_study_succeeds
    count = ReferralStudy.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    study = ReferralStudy.new({:study_type_tag_id=>"tag_provider_type_physician",
                             :study_modality_tag_id=>"tag_provider_type_physician",
                             :location_tag_id=>"tag_provider_type_physician",
                             :location_detail_tag_id=>"tag_provider_type_physician"})
    referral = engine.attach_study(:study=>study)
    assert_equal count+1, ReferralInsurancePlan.count
    assert_equal referral.id, referral.referral_studies.first.referral_id
    assert engine.referral.updated_at > last_updated_at
  end

  def test_attach_study_succeeds_second_plan
    count = ReferralStudy.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    study = ReferralStudy.new({:study_type_tag_id=>"tag_provider_type_physician",
                             :study_modality_tag_id=>"tag_provider_type_physician",
                             :location_tag_id=>"tag_provider_type_physician",
                             :location_detail_tag_id=>"tag_provider_type_physician"})
    referral = engine.attach_study(:study=>study)
    assert_equal count+1, ReferralStudy.count
    assert_equal referral.id, referral.referral_studies.first.referral_id

    # second one
    study = ReferralStudy.new({:study_type_tag_id=>"tag_provider_type_physician",
                             :study_modality_tag_id=>"tag_provider_type_physician",
                             :location_tag_id=>"tag_provider_type_physician",
                             :location_detail_tag_id=>"tag_provider_type_physician"})
    referral = engine.attach_study(:study=>study)
    assert_equal count+2, ReferralStudy.count
    assert_equal referral.id, referral.referral_studies.last.referral_id
  end

  def test_update_study_succeeds
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    study = ReferralStudy.new({:study_type_tag_id=>"tag_provider_type_physician",
                             :study_modality_tag_id=>"tag_provider_type_physician",
                             :location_tag_id=>"tag_provider_type_physician",
                             :location_detail_tag_id=>"tag_provider_type_physician"})
    referral = engine.attach_study(:study=>study)
    count = ReferralStudy.count
    study.reload
    study.study_type_tag_id = tags(:tag_provider_type_ancillary).id
    referral = engine.update_study(:study=>study)
    assert_equal count, ReferralStudy.count
    study.reload
    assert_equal tags(:tag_provider_type_ancillary).id, study.study_type_tag_id
  end

  def test_remove_study_succeeds_second_plan
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    study = ReferralStudy.new({:study_type_tag_id=>"tag_provider_type_physician",
                             :study_modality_tag_id=>"tag_provider_type_physician",
                             :location_tag_id=>"tag_provider_type_physician",
                             :location_detail_tag_id=>"tag_provider_type_physician"})
    referral = engine.attach_study(:study=>study)
    count = ReferralStudy.count
    study.reload

    referral = engine.remove_study(:study=>study)
    assert_equal count-1, ReferralStudy.count
  end

  def test_assign_insurance_should_not_allow_nil
    begin
      engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
      engine.assign_insurance
      fail "should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_assign_insurance_succeeds
    count = ReferralInsurancePlan.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    referral_insurance_plan = ReferralInsurancePlan.new({ :insurance_carrier_tag=> tags(:tag_carrier_blue_cross),
                                                               :insurance_carrier_plan_tag=> tags(:tag_carrier_blue_cross_1),
                                                               :policy_details=> "Policy Details Here"})
    referral = engine.assign_insurance(:referral_insurance_plan=>referral_insurance_plan)
    assert_equal count+1, ReferralInsurancePlan.count
    assert_equal referral.id, referral.referral_insurance_plans.first.referral_id
    assert engine.referral.updated_at > last_updated_at
  end

  def test_assign_insurance_succeeds_second_plan
    count = ReferralInsurancePlan.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral_insurance_plan = ReferralInsurancePlan.new({ :insurance_carrier_tag=> tags(:tag_carrier_blue_cross),
                                                               :insurance_carrier_plan_tag=> tags(:tag_carrier_blue_cross_1),
                                                               :policy_details=> "Policy Details Here"})
    referral = engine.assign_insurance(:referral_insurance_plan=>referral_insurance_plan)
    assert_equal count+1, ReferralInsurancePlan.count
    assert_equal referral.id, referral.referral_insurance_plans.first.referral_id

    # second one
    referral_insurance_plan = ReferralInsurancePlan.new({ :insurance_carrier_tag=> tags(:tag_carrier_blue_cross),
                                                               :insurance_carrier_plan_tag=> tags(:tag_carrier_blue_cross_1),
                                                               :policy_details=> "Policy Details Here"})
    referral = engine.assign_insurance(:referral_insurance_plan=>referral_insurance_plan)
    assert_equal count+2, ReferralInsurancePlan.count
    assert_equal referral.id, referral.referral_insurance_plans.last.referral_id
  end

  def test_update_insurance_succeeds
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral_insurance_plan = ReferralInsurancePlan.new({ :insurance_carrier_tag=> tags(:tag_carrier_blue_cross),
                                                               :insurance_carrier_plan_tag=> tags(:tag_carrier_blue_cross_1),
                                                               :policy_details=> "Policy Details Here"})
    referral = engine.assign_insurance(:referral_insurance_plan=>referral_insurance_plan)
    count = ReferralInsurancePlan.count
    referral_insurance_plan.reload

    referral_insurance_plan.policy_details = "Changed"
    referral = engine.update_insurance(:referral_insurance_plan=>referral_insurance_plan)
    assert_equal count, ReferralInsurancePlan.count
    referral_insurance_plan.reload
    assert_equal "Changed", referral_insurance_plan.policy_details
  end

  def test_remove_insurance_succeeds_second_plan
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral_insurance_plan = ReferralInsurancePlan.new({ :insurance_carrier_tag=> tags(:tag_carrier_blue_cross),
                                                               :insurance_carrier_plan_tag=> tags(:tag_carrier_blue_cross_1),
                                                               :policy_details=> "Policy Details Here"})
    referral = engine.assign_insurance(:referral_insurance_plan=>referral_insurance_plan)
    count = ReferralInsurancePlan.count
    referral_insurance_plan.reload

    referral = engine.remove_insurance(:referral_insurance_plan=>referral_insurance_plan)
    assert_equal count-1, ReferralInsurancePlan.count
  end

  def test_cancel_referral_should_delete_all_rows
    audit_count = AuditLog.count
    # force this to be in 'new' state to test deleting the relationships
    @welby_to_stretch_in_progress.referral_state_id = 'new'
    @welby_to_stretch_in_progress.save!
    referral_count = Referral.count
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    engine.cancel_referral
    assert_equal referral_count-1, Referral.count
    assert_equal 0, ReferralMessage.count('id', :conditions=>["referral_id = ?",@welby_to_stretch_in_progress.id])
    assert_equal 0, ReferralPatient.count('id', :conditions=>["referral_id = ?",@welby_to_stretch_in_progress.id])
    assert_equal 0, ReferralDiagnosisSelection.count('id', :conditions=>["referral_id = ?",@welby_to_stretch_in_progress.id])
    assert_equal 0, ReferralInsurancePlan.count('id', :conditions=>["referral_id = ?",@welby_to_stretch_in_progress.id])
    assert_equal 0, ReferralTarget.count('id', :conditions=>["referral_id = ?",@welby_to_stretch_in_progress.id])
    assert_equal 0, ReferralSource.count('id', :conditions=>["referral_id = ?",@welby_to_stretch_in_progress.id])
    assert_equal audit_count, AuditLog.count # no audit log entries are created anymore (by Dave)
  end

  def test_cancel_referral_should_fail_if_not_new_or_waiting
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      engine.cancel_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_finish_referral_should_set_to_waiting_approval_status
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    referral = engine.finish_referral
    assert_not_nil referral
    assert_equal ReferralState::WAITING_APPROVAL, referral.referral_state.id
    assert engine.referral.updated_at > last_updated_at
  end

  def test_finish_referral_should_fail_if_not_new
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      referral = engine.finish_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_finish_referral_should_fail_if_not_valid
    @kildare_to_mccoy_new_referral.active_source_id = nil
    @kildare_to_mccoy_new_referral.save!
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    begin
      referral = engine.finish_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::ReferralInvalidException => e
      # good
    end
  end

  def test_sign_and_send_referral_should_set_to_provisional_status
    count = AuditLog.count
    assert !@kildare_to_mccoy_new_referral.request_referral?
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral
    assert_not_nil referral
    assert_equal ReferralState::PROVISIONAL, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target
    target.reload
    assert_equal ReferralTargetState::WAITING_ACCEPTANCE, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    source.reload
    assert_equal ReferralSourceState::WAITING_ACCEPTANCE, source.referral_source_state_id
    assert_equal count+1, AuditLog.count
  end

  def test_sign_and_send_referral_should_set_to_in_progress_when_request_referral
    count = AuditLog.count
    message_count = ReferralMessage.count

    # swap the source/target
    curr_source_workgroup_id = @kildare_to_mccoy_new_referral.active_source.workgroup_id
    curr_source_user_id = @kildare_to_mccoy_new_referral.active_source.user_id
    @kildare_to_mccoy_new_referral.active_source.workgroup_id = @kildare_to_mccoy_new_referral.active_target.workgroup_id
    @kildare_to_mccoy_new_referral.active_source.user_id = @kildare_to_mccoy_new_referral.active_target.user_id
    @kildare_to_mccoy_new_referral.active_target.workgroup_id = curr_source_workgroup_id
    @kildare_to_mccoy_new_referral.active_target.user_id = curr_source_user_id
    @kildare_to_mccoy_new_referral.active_source.save!
    @kildare_to_mccoy_new_referral.active_target.save!

    # set the created_by_workgroup_id to the new target
    @kildare_to_mccoy_new_referral.created_by_workgroup_id = @kildare_to_mccoy_new_referral.active_target.workgroup_id
    @kildare_to_mccoy_new_referral.save!

    assert @kildare_to_mccoy_new_referral.request_referral?
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral
    assert_not_nil referral
    referral.reload
    assert_equal ReferralState::IN_PROGRESS, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target
    target.reload
    assert_equal ReferralTargetState::IN_PROGRESS, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    source.reload
    assert_equal ReferralSourceState::WAITING_RESPONSE, source.referral_source_state_id
    assert_equal count+2, AuditLog.count
    assert_equal message_count+1, ReferralMessage.count
  end

  def test_sign_and_send_referral_should_fail_if_not_waiting_approval
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      referral = engine.sign_and_send_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_sign_and_send_referral_should_fail_if_user_not_a_physician
    # force a workgroup to require only a physician
    @workgroup_kildare.anyone_can_sign_referral_flag = false
    @workgroup_kildare.save!
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @joyce_kildare_admin, @workgroup_kildare)
    referral = engine.finish_referral
    begin
      referral = engine.sign_and_send_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::ActionNotAllowedException => e
      # good
    end
  end

  def test_accept_referral_should_set_to_in_progress_status
    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    # ppw phys user for target
    referral_target.update_attributes({ :user=>users(:quentin) })
    engine.referral.reload

    # create new engine for the opposite side (consulting side)
    audit_count = AuditLog.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    last_updated_at = engine.referral.updated_at
    referral = engine.accept_referral
    assert engine.referral.updated_at > last_updated_at
    assert_not_nil referral
    assert_equal ReferralState::IN_PROGRESS, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target
    assert_equal ReferralTargetState::IN_PROGRESS, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    assert_equal ReferralSourceState::IN_PROGRESS, source.referral_source_state_id
    assert_equal audit_count+1, AuditLog.count
  end

  def test_accept_referral_should_require_physician_selection_for_target
    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    # create new engine for the opposite side (consulting side)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    last_updated_at = engine.referral.updated_at
    begin
      referral = engine.accept_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::TargetInvalidException => e
      # good
    end
  end

  def test_accept_referral_should_set_to_in_progress_status_if_physician_supplied
    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    # create new engine for the opposite side (consulting side)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    last_updated_at = engine.referral.updated_at
    referral = engine.accept_referral(:physician_user=>users(:quentin))
    assert engine.referral.updated_at > last_updated_at
    assert_not_nil referral
    assert_equal ReferralState::IN_PROGRESS, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target
    assert_equal ReferralTargetState::IN_PROGRESS, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    assert_equal ReferralSourceState::IN_PROGRESS, source.referral_source_state_id
    referral.reload
    assert_equal engine.referral.active_target.display_name, engine.referral.to_name
    assert_equal users(:quentin).id, engine.referral.active_target.user.id
  end

  def test_accept_referral_should_set_to_in_progress_status_for_apw_with_no_user
    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    # apw target
    workgroup = workgroups(:workgroup_mccoy)
    workgroup.update_attributes({ :workgroup_type_id => 'apw'})
    engine.referral.reload

    # create new engine for the opposite side (consulting side)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    last_updated_at = engine.referral.updated_at
    referral = engine.accept_referral
    assert engine.referral.updated_at > last_updated_at
    assert_not_nil referral
    assert_equal ReferralState::IN_PROGRESS, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target
    assert_equal ReferralTargetState::IN_PROGRESS, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    assert_equal ReferralSourceState::IN_PROGRESS, source.referral_source_state_id
  end

  def test_accept_referral_should_fail_if_ppw_and_user_not_physician
    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    # create new engine for the opposite side (consulting side)
    # ppw w/ no user assigned
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    begin
      referral = engine.accept_referral
      fail("should raise exception")
    rescue WorkflowEngine::TargetInvalidException => e
      # good
    end

    # ppw admin
    referral_target.update_attributes({ :user=>users(:joyce_kildare_admin) })
    engine.referral.reload
    begin
      referral = engine.accept_referral
      fail("should raise exception")
    rescue WorkflowEngine::TargetInvalidException => e
      # good
    end
  end

  def test_accept_referral_should_fail_if_not_provisional
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      referral = engine.accept_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_accept_referral_should_fail_if_referral_not_valid
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral
    @kildare_to_mccoy_new_referral.delete_referral_sources!
    @kildare_to_mccoy_new_referral.reload
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    begin
      referral = engine.accept_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::TargetInvalidException => e
      # good
    end
  end

  def test_accept_referral_should_not_email_patient_if_no_email_provided
    @emails = ActionMailer::Base.deliveries
    @emails.clear

    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    # create new engine for the opposite side (consulting side)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    referral = engine.accept_referral(:physician_user=>users(:quentin))
    assert_not_nil referral
    assert_equal ReferralState::IN_PROGRESS, referral.referral_state.id
    assert_equal 0, @emails.length
  end

  def test_accept_referral_should_email_patient
    @emails = ActionMailer::Base.deliveries
    @emails.clear

    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    # setup the email address of the patient
    patient = referral.referral_patients.first
    patient.email = "foo@bar.com"
    patient.save!

    # create new engine for the opposite side (consulting side)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    referral = engine.accept_referral(:physician_user=>users(:quentin))
    assert_not_nil referral
    assert_equal ReferralState::IN_PROGRESS, referral.referral_state.id
    # Removed for Alpha - assert_equal 1, @emails.length
  end

  def test_decline_referral_should_set_to_new
    audit_count = AuditLog.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral

    # create new engine for the opposite side (consulting side)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    engine.referral.reload
    last_updated_at = engine.referral.updated_at
    referral = engine.decline_referral
    assert engine.referral.updated_at > last_updated_at
    assert_not_nil referral

    assert_equal ReferralState::NEW, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target # should still come back, even though they have declined it
    target = referral.referral_targets.first
    assert_not_nil target
    assert_equal ReferralTargetState::DECLINED, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    assert_equal ReferralSourceState::DECLINED_BY_TARGET, source.referral_source_state_id

    engine.referral.reload
    assert_not_nil engine.referral.active_target
    assert_equal 1, engine.referral.referral_targets.length # still exists, just not active
    assert_equal audit_count+1, AuditLog.count
  end

  def test_decline_referral_should_fail_if_not_provisional
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
    referral = engine.decline_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_withdraw_referral_should_set_to_new_status
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral
    last_updated_at = engine.referral.updated_at
    referral = engine.withdraw_referral
    assert engine.referral.updated_at > last_updated_at
    assert_not_nil referral
    assert_equal ReferralState::NEW, referral.referral_state.id
    target = referral.active_target
    assert_nil target # shouldn't come back, as they have declined it
    target = referral.referral_targets.first
    assert_not_nil target
    assert_equal ReferralTargetState::WITHDRAWN_BY_SOURCE, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    assert_equal ReferralSourceState::WITHDRAWN, source.referral_source_state_id

    engine.referral.reload
    assert_nil engine.referral.active_target
    assert_equal 1, engine.referral.referral_targets.length # still exists, just not active
  end

  def test_withdraw_referral_should_fail_if_not_waiting_approval
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    begin
      referral = engine.withdraw_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_close_referral_should_set_to_closed_status
    message_count = ReferralMessage.count
    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral
    assert_not_nil referral

    # ppw phys user for target
    referral_target.update_attributes({ :user=>users(:quentin) })
    engine.referral.reload

    # create new engine for the opposite side (consulting side)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    referral = engine.accept_referral
    referral.reload
    referral = engine.close_referral
    referral.reload
    referral.active_source.reload
    referral.active_target.reload

    assert_equal ReferralState::CLOSED, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target
    assert_equal ReferralTargetState::CLOSED, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    assert_equal ReferralSourceState::NEW_INFO, source.referral_source_state_id
    assert_equal message_count+1, ReferralMessage.count
  end

  def test_close_referral_should_fail_if_not_in_progress
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    begin
      referral = engine.close_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_reopen_referral_should_set_to_in_progress
    referral_target = referral_targets(:kildare_to_mccoy_new_target)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    referral = engine.finish_referral
    referral = engine.sign_and_send_referral
    assert_not_nil referral

    # ppw phys user for target
    referral_target.update_attributes({ :user=>users(:quentin) })
    engine.referral.reload

    # create new engine for the opposite side (consulting side)
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    referral = engine.accept_referral
    referral.reload
    referral = engine.close_referral
    referral.reload

    message_count = ReferralMessage.count
    referral = engine.reopen_referral
    referral.reload
    assert_equal ReferralState::IN_PROGRESS, referral.referral_state.id
    target = referral.active_target
    assert_not_nil target
    assert_equal ReferralTargetState::IN_PROGRESS, target.referral_target_state_id
    source = referral.active_source
    assert_not_nil source
    assert_equal ReferralSourceState::NEW_INFO, source.referral_source_state_id
    assert_equal message_count+1, ReferralMessage.count
  end

  def test_reopen_referral_should_fail_if_not_closed
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    begin
      referral = engine.reopen_referral
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_attach_file_should_succeed
    count = ReferralFile.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    file = ReferralFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt", :mime_type=>mime_types(:jpg), :referral_file_type=>referral_file_types(:xray)})
    referral = engine.attach_file(:file=>file)
    assert_equal count+1, ReferralFile.count
  end

  def test_attach_file_should_fail_if_file_nil
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    begin
      referral = engine.attach_file
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_update_file_succeeds
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    file = ReferralFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt", :mime_type=>mime_types(:jpg), :referral_file_type=>referral_file_types(:xray)})
    referral = engine.attach_file(:file=>file)
    file.reload
    file.size = 5678
    count = ReferralFile.count
    referral = engine.update_file(:file=>file)
    assert_equal count, ReferralFile.find_with_deleted(:all).length
    file.reload
    assert_equal 5678, file.size
  end

  def test_remove_file_should_destroy_for_new_referral
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    file = ReferralFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt", :mime_type=>mime_types(:jpg), :referral_file_type=>referral_file_types(:xray)})
    referral = engine.attach_file(:file=>file)
    count = ReferralFile.count
    referral = engine.remove_file(:file=>file)
    assert_equal count-1, ReferralFile.find_with_deleted(:all).length
  end

  def test_remove_file_should_delete_for_in_progress_referral
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    file = ReferralFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt", :mime_type=>mime_types(:jpg), :referral_file_type=>referral_file_types(:xray)})
    referral = engine.attach_file(:file=>file)
    count = ReferralFile.count
    referral = engine.remove_file(:file=>file)
    assert_equal count, ReferralFile.find_with_deleted(:all).length
    assert_equal count-1, ReferralFile.count # filtered by acts_as_paranoid
  end

  def test_remove_file_should_fail_if_file_nil
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    begin
      referral = engine.remove_file
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_attach_fax_should_not_allow_nil
    begin
      engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
      engine.attach_fax
      fail "should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_attach_fax_succeeds
    count = ReferralFax.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    fax = ReferralFax.new({:referral_fax_state_id=>"waiting"})
    referral = engine.attach_fax(:fax=>fax)
    assert engine.referral.updated_at > last_updated_at
    assert_equal count+1, ReferralFax.count
    assert_equal referral.id, referral.referral_faxes.first.referral_id
  end

  def test_attach_fax_succeeds_second_plan
    count = ReferralFax.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    fax = ReferralFax.new({:referral_fax_state_id=>"waiting"})
    referral = engine.attach_fax(:fax=>fax)
    assert_equal count+1, ReferralFax.count
    assert_equal referral.id, referral.referral_faxes.first.referral_id

    # second one
    fax = ReferralFax.new({:referral_fax_state_id=>"waiting"})
    referral = engine.attach_fax(:fax=>fax)
    assert_equal count+2, ReferralFax.count
    assert_equal referral.id, referral.referral_faxes.last.referral_id
  end

  def test_update_fax_state_should_not_allow_nil
    begin
      engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
      engine.update_fax_state
      fail "should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_update_fax_state_succeeds
    count = ReferralFaxFile.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    fax = referral_faxes(:test_referral_fax_one)
    referral = engine.update_fax_state(:fax=>fax, :fax_state=>referral_fax_states(:received_successfully).id)
    assert engine.referral.updated_at > last_updated_at
    assert_equal count, ReferralFaxFile.count
    fax.reload
    assert_equal referral_fax_states(:received_successfully).id, fax.referral_fax_state_id
  end

  def test_update_fax_succeeds
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    fax = ReferralFax.new({:referral_fax_state_id=>"waiting"})
    referral = engine.attach_fax(:fax=>fax)
    count = ReferralFax.count
    fax.comments = "Changed"
    referral = engine.update_fax(:fax=>fax)
    fax.reload
    assert_equal count, ReferralFax.count # filtered by acts_as_paranoid
    assert_equal "Changed", fax.comments
  end

  def test_remove_fax_succeeds
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    fax = ReferralFax.new({:referral_fax_state_id=>"waiting"})
    referral = engine.attach_fax(:fax=>fax)
    count = ReferralFax.count
    referral = engine.remove_fax(:fax=>fax)
    assert_equal count-1, ReferralFax.count # filtered by acts_as_paranoid
  end

  def test_attach_fax_file_should_not_allow_nil
    begin
      engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
      engine.attach_fax_file
      fail "should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_attach_fax_file_succeeds
    count = ReferralFaxFile.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    last_updated_at = engine.referral.updated_at
    fax_file = ReferralFaxFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt"})
    referral = engine.attach_fax_file(:fax_file=>fax_file, :fax=>referral_faxes(:test_referral_fax_one))
    assert engine.referral.updated_at > last_updated_at
    assert_equal count+1, ReferralFaxFile.count
    assert_equal referral.id, referral.referral_fax_files.first.referral_id
  end

  def test_attach_fax_file_succeeds_second_plan
    count = ReferralFaxFile.count
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    fax_file = ReferralFaxFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt"})
    referral = engine.attach_fax_file(:fax_file=>fax_file, :fax=>referral_faxes(:test_referral_fax_one))
    assert_equal count+1, ReferralFaxFile.count
    assert_equal referral.id, referral.referral_fax_files.first.referral_id

    # second one
    fax_file = ReferralFaxFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt"})
    referral = engine.attach_fax_file(:fax_file=>fax_file, :fax=>referral_faxes(:test_referral_fax_one))
    assert_equal count+2, ReferralFaxFile.count
    assert_equal referral.id, referral.referral_fax_files.last.referral_id
  end

  def test_update_fax_file_succeeds
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    fax_file = ReferralFaxFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt"})
    referral = engine.attach_fax_file(:fax_file=>fax_file, :fax=>referral_faxes(:test_referral_fax_one))
    fax_file.reload
    fax_file.size = 5678
    count = ReferralFaxFile.count
    referral = engine.update_fax_file(:fax_file=>fax_file)
    assert_equal count, ReferralFaxFile.find_with_deleted(:all).length
    fax_file.reload
    assert_equal 5678, fax_file.size
  end

  def test_remove_fax_file_succeeds
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @dr_gillespie, @workgroup_kildare)
    fax_file = ReferralFaxFile.new({:size=>1234, :content_type=>"application/text", :filename=>"test.txt"})
    referral = engine.attach_fax_file(:fax_file=>fax_file, :fax=>referral_faxes(:test_referral_fax_one))
    count = ReferralFaxFile.count
    referral = engine.remove_fax_file(:fax_file=>fax_file)
    assert_equal count-1, ReferralFaxFile.count # filtered by acts_as_paranoid
  end

  def test_attach_message_should_succeed_note
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    last_updated_at = engine.referral.updated_at
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @aaron})
    count = ReferralMessage.count
    referral = engine.attach_message(:message=>message)
    assert engine.referral.updated_at > last_updated_at
    assert_equal count+1, ReferralMessage.count
    referral.reload
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_new_info?

    message.reload
    assert message.status_new_info?
  end

  def test_attach_message_should_succeed_note_target_to_source
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @stretch_brewster})
    count = ReferralMessage.count
    referral = engine.attach_message(:message=>message)
    assert_equal count+1, ReferralMessage.count
    referral.reload
    assert referral.active_source.status_new_info?
    assert referral.active_target.status_in_progress?

    message.reload
    assert message.status_new_info?
  end

  def test_attach_message_should_succeed_request_source_to_target
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                  :created_by => @aaron, :response_required_by=>10.days.from_now})
    count = ReferralMessage.count
    referral = engine.attach_message(:message=>message)
    assert_equal count+1, ReferralMessage.count
    referral.reload
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?

    message.reload
    assert message.status_waiting_response?
  end

  def test_attach_message_should_succeed_request_target_to_source
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                  :created_by => @stretch_brewster, :response_required_by=>10.days.from_now})
    count = ReferralMessage.count
    referral = engine.attach_message(:message=>message)
    assert_equal count+1, ReferralMessage.count
    referral.reload
    assert referral.active_source.status_waiting_response?
    assert referral.active_target.status_in_progress?

    message.reload
    assert message.status_waiting_response?
  end

  def test_attach_message_should_fail_if_message_validation_fails
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message"})
    count = ReferralMessage.count
    begin
      referral = engine.attach_message(:message=>message)
      fail "engine should have raised an exception"
    rescue WorkflowEngine::ValidationFailedException => e
      # good
    end
    assert_equal count, ReferralMessage.count
  end

  def test_attach_message_should_fail_if_message_nil
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @dr_gillespie, @workgroup_kildare)
    begin
      referral = engine.attach_message
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_mark_message_read_should_succeed_note
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    last_updated_at = engine.referral.updated_at
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @aaron})
    referral = engine.attach_message(:message=>message)
    assert engine.referral.updated_at > last_updated_at
    count = ReferralMessage.count
    assert_nil message.responded_at
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_new_info?
    referral = engine.mark_message_read(:message=>message)
    message.reload
    assert_nil message.responded_at
    assert_equal count, ReferralMessage.count
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_in_progress?
    assert message.status_complete?
  end

  def test_mark_message_read_should_succeed_request
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    last_updated_at = engine.referral.updated_at
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                  :created_by => @aaron, :response_required_by=>10.days.from_now})
    referral = engine.attach_message(:message=>message)
    assert engine.referral.updated_at > last_updated_at
    count = ReferralMessage.count
    assert_nil message.responded_at
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?

    referral = engine.mark_message_read(:message=>message)
    message.reload
    assert_nil message.responded_at
    assert_equal count, ReferralMessage.count
    # no change, as it hasn't been completed
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?
    assert message.status_waiting_response?
  end

  def test_mark_message_read_should_fail_if_not_in_progress
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @dr_gillespie})
    begin
      referral = engine.mark_message_read(:message=>message)
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_mark_message_read_for_note_keep_waiting_status_with_request_pending
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    last_updated_at = engine.referral.updated_at
    # request first
    message_request = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                  :created_by => @aaron, :response_required_by=>10.days.from_now})
    referral = engine.attach_message(:message=>message_request)
    # note last - still should remain 'waiting' since requests supercede general notes
    message_note = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @aaron})
    referral = engine.attach_message(:message=>message_note)

    assert engine.referral.updated_at > last_updated_at
    count = ReferralMessage.count
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?
    referral = engine.mark_message_read(:message=>message_note)
    assert_equal count, ReferralMessage.count
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?

    referral = engine.complete_message(:message=>message_request)
    assert_equal count, ReferralMessage.count
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_in_progress?
  end

  def test_complete_message_should_fail_if_not_in_progress
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @dr_gillespie})
    begin
      referral = engine.complete_message(:message=>message)
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_complete_message_should_succeed_note
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    last_updated_at = engine.referral.updated_at
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @aaron})
    referral = engine.attach_message(:message=>message)
    assert engine.referral.updated_at > last_updated_at
    count = ReferralMessage.count
    assert_nil message.responded_at
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_new_info?
    referral = engine.complete_message(:message=>message)
    message.reload
    assert_not_nil message.responded_at
    assert_equal count, ReferralMessage.count
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_in_progress?
    assert message.status_complete?
  end

  def test_complete_message_should_succeed_request
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                  :created_by => @aaron, :response_required_by=>10.days.from_now})
    referral = engine.attach_message(:message=>message)
    count = ReferralMessage.count
    assert_nil message.responded_at
    referral.reload
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?

    last_updated_at = engine.referral.updated_at
    referral = engine.complete_message(:message=>message)
    assert engine.referral.updated_at > last_updated_at
    message.reload
    assert_not_nil message.responded_at
    assert_equal count, ReferralMessage.count

    referral.reload
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_in_progress?
    assert message.status_complete?
  end

  def test_complete_message_should_succeed_two_requests
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    # request #1
    message1 = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                  :created_by => @aaron, :response_required_by=>10.days.from_now})
    referral = engine.attach_message(:message=>message1)
    # request #2
    message2 = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                  :created_by => @aaron, :response_required_by=>10.days.from_now})
    referral = engine.attach_message(:message=>message2)
    referral.reload
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?

    # complete #1
    referral = engine.complete_message(:message=>message1)
    message1.reload
    message2.reload
    assert_not_nil message1.responded_at
    assert_nil message2.responded_at

    # should still have a waiting response status, since there is a second message pending
    referral.reload
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?

    # complete #2
    referral = engine.complete_message(:message=>message2)
    message1.reload
    message2.reload
    assert_not_nil message1.responded_at
    assert_not_nil message2.responded_at

    referral.reload
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_in_progress?
  end

  def test_complete_message_should_fail_if_message_nil
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    begin
      referral = engine.complete_message
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_complete_message_should_fail_if_not_in_progress
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @dr_gillespie})
    begin
      referral = engine.complete_message(:message=>message)
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_ticket_67_request_message_should_mark_source_as_in_progress
    #
    # 1. Request sent from aaron/welby to stretch
    #
    welby_engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    welby_message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                       :created_by => @aaron, :response_required_by=>10.days.from_now})
    welby_referral = welby_engine.attach_message(:message=>welby_message)
    assert_nil welby_message.responded_at
    welby_referral.reload
    assert welby_referral.active_source.status_in_progress?
    assert welby_referral.active_target.status_waiting_response?
    assert_equal welby_referral.active_target.id, welby_message.referral_source_or_target_id

    #
    # 2. stretch_brewster/stretch views message
    #
    @stretch_brewster = users(:stretch_brewster)
    @workgroup_phys_therapy = workgroups(:workgroup_phys_therapy)
    stretch_engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @stretch_brewster, @workgroup_phys_therapy)
    stretch_referral = stretch_engine.mark_message_read(:message=>welby_message)
    stretch_referral.reload
    assert stretch_referral.active_source.status_in_progress?
    assert stretch_referral.active_target.status_waiting_response?

    #
    # 3. stretch_brewster/stretch replies to the message and it is marked as complete
    #
    message_reply = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:reply_provided), :message_text=>"Some reply",
                                        :created_by => @stretch_brewster, :reply_to_message=>welby_message})
    stretch_referral = stretch_engine.attach_message(:message=>message_reply)
    message_reply.reload
    assert_equal welby_referral.active_source.id, message_reply.referral_source_or_target_id
    #stretch_referral = stretch_engine.complete_message(:message=>welby_message)
    stretch_referral.reload
    assert stretch_referral.active_source.status_new_info?, "stretch_referral.active_source.referral_source_state_id=#{stretch_referral.active_source.referral_source_state_id}"
    assert stretch_referral.active_target.status_in_progress?, "stretch_referral.active_target.referral_target_state_id=#{stretch_referral.active_target.referral_target_state_id}"
    welby_message.reload
    assert welby_message.status_complete?

    #
    # 4. aaron/welby reads the message
    #
    welby_referral = welby_engine.mark_message_read(:message=>message_reply)
    welby_referral.reload
    assert welby_referral.active_source.status_in_progress?, "stretch_referral.active_source.referral_source_state_id=#{stretch_referral.active_source.referral_source_state_id}"
    assert welby_referral.active_target.status_in_progress?, "stretch_referral.active_target.referral_target_state_id=#{stretch_referral.active_target.referral_target_state_id}"
  end

  def test_remove_message_should_succeed
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @dr_gillespie})
    last_updated_at = engine.referral.updated_at
    referral = engine.attach_message(:message=>message)
    count = ReferralMessage.count
    assert_nil message.responded_at
    referral = engine.remove_message(:message=>message)
    assert referral.updated_at > last_updated_at
    assert_equal count-1, ReferralMessage.count
  end

  def test_remove_message_should_fail_if_message_nil
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    begin
      referral = engine.remove_message
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidArgumentException => e
      # good
    end
  end

  def test_remove_message_should_fail_if_not_in_progress
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @dr_gillespie})
    begin
      referral = engine.remove_message(:message=>message)
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  def test_void_message_should_succeed_note
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    last_updated_at = engine.referral.updated_at
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @aaron})
    referral = engine.attach_message(:message=>message)
    assert engine.referral.updated_at > last_updated_at
    count = ReferralMessage.count
    assert_nil message.responded_at
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_new_info?
    referral = engine.void_message(:message=>message)
    message.reload
    assert_nil message.responded_at
    assert_nil message.viewed_at
    assert_equal count, ReferralMessage.count
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_in_progress?
    assert message.status_void?
  end

  def test_mark_message_read_should_succeed_request
    engine = WorkflowEngine.new(@welby_to_stretch_in_progress, @aaron, @workgroup_welby)
    last_updated_at = engine.referral.updated_at
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:request), :message_text=>"Some message",
                                  :created_by => @aaron, :response_required_by=>10.days.from_now})
    referral = engine.attach_message(:message=>message)
    assert engine.referral.updated_at > last_updated_at
    count = ReferralMessage.count
    assert_nil message.responded_at
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_waiting_response?
    referral = engine.void_message(:message=>message)
    message.reload
    assert_nil message.responded_at
    assert_nil message.viewed_at
    assert_equal count, ReferralMessage.count
    assert referral.active_source.status_in_progress?
    assert referral.active_target.status_in_progress?
    assert message.status_void?
  end

  def test_void_message_should_fail_if_not_in_progress
    engine = WorkflowEngine.new(@kildare_to_mccoy_new_referral, @quentin, @workgroup_mccoy)
    message = ReferralMessage.new({ :subject=>"Test", :referral_message_type=>referral_message_types(:general_note), :message_text=>"Some message",
                                  :created_by => @dr_gillespie})
    begin
      referral = engine.void_message(:message=>message)
      fail "engine should have raised an exception"
    rescue WorkflowEngine::InvalidStateException => e
      # good
    end
  end

  protected

  def create_default_patient
    return ReferralPatient.new({ :first_name=>"Joe", :middle_name=>"B", :last_name=>"Patient", :ssn=>"111-11-1111", :dob=>32.years.ago, :gender=>'M'})
  end
end
