require File.dirname(__FILE__) + '/../test_helper'

class ReferralTest < ActiveSupport::TestCase
  def test_fixtures_should_load
    assert Referral.count > 0
  end

  def test_find_eager_should_load_model
    referral = Referral.find_eager(referrals(:kildare_to_mccoy_new_referral).id)
    assert_not_nil referral
    assert_not_nil referral.referral_state
    assert_equal 1, referral.referral_sources.length
    assert_equal 1, referral.referral_targets.length
  end

  def test_active_target_should_load_only_active_when_more_than_one
    referral = Referral.find(referrals(:welby_to_stretch_closed_referral).id)
    assert_not_nil referral
    target = referral.active_target
    assert_not_nil target
    assert_equal referral_targets(:welby_to_stretch_closed_target).id, target.id
  end

  def test_active_target_should_not_return_target_if_declined
    # remove the one that would normally return - the closed one
    referrals(:welby_to_stretch_closed_referral).active_target = nil
    referrals(:welby_to_stretch_closed_referral).save!
    referral_targets(:welby_to_stretch_closed_target).destroy!
    referral = Referral.find(referrals(:welby_to_stretch_closed_referral).id)
    target = referral.active_target
    assert_nil target
  end

  def test_valid_for_finish
    referral = Referral.new
    # brand new instance
    referral.valid_for_finish?
    assert_equal 3, referral.errors.length

    # active_source
    referral.active_source_id = 'fake_id'
    referral.valid_for_finish?
    assert_equal 2, referral.errors.length

    # active_target
    referral.active_target_id = 'fake_id'
    referral.valid_for_finish?
    assert_equal 1, referral.errors.length

    # patient
    referral.referral_patients.build({ })
    referral.valid_for_finish?
    assert_equal 0, referral.errors.length

    # referral_type_selections
    # TODO: commenting out this check since the block isn't complete yet
    #referral.referral_type_selections << ReferralTypeSelection.new
    #referral.valid_for_finish?
    #assert_equal 0, referral.errors.length
  end

  def test_valid_target_for_accept
    referral = referrals(:kildare_to_mccoy_new_referral)
    referral_target = referral_targets(:kildare_to_mccoy_new_target)

    # ppw w/ no user id
    assert !referral.valid_target_for_accept?

    # ppw w/ admin user
    referral_target.update_attributes({ :user=>users(:joyce_kildare_admin) })
    referral.reload
    assert !referral.valid_target_for_accept?

    # ppw w/ physician
    referral_target.update_attributes({ :user=>users(:quentin) })
    referral.reload
    assert referral.valid_target_for_accept?
  end

  def test_valid_target_for_accept_apw
    workgroup = workgroups(:workgroup_mccoy)
    workgroup.update_attributes({ :workgroup_type_id => 'apw'})
    referral = referrals(:kildare_to_mccoy_new_referral)
    referral.reload
    assert referral.valid_target_for_accept?
  end

  def test_search_and_filter_pagination
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    results_per_page = 5

    # page 1
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 5, results.length
    assert_equal 2, total_pages

    # page 2
    filter.page_number = 2
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 2, results.length
    assert_equal 2, total_pages
  end

  def test_search_and_filter_sort_by_patient
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    results_per_page = 5

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 5, results.length
    assert_equal 2, total_pages
    assert_equal referrals(:mccoy_to_kildare_2).id, results.first['referral_id']

    # page 2 - last result
    filter.page_number = 2
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 2, results.length
    assert_equal 2, total_pages
    assert_equal referrals(:mccoy_to_kildare_3).id, results.last['referral_id']
  end

  def test_search_and_filter_search_by_string
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.search = 'Stretch'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 2, results.length
    assert_equal 1, total_pages
    assert_equal referrals(:mccoy_to_stretch_7).id, results.first['referral_id']
  end

  def test_search_and_filter_search_by_string_dob_match
    patient = referral_patients(:mccoy_to_stretch_7_patient)

    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.search = patient.display_dob_search_format
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 1, results.length
    assert_equal 1, total_pages
    assert_equal referrals(:mccoy_to_stretch_7).id, results.first['referral_id']
  end

  def test_search_and_filter_direction_filter_out
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_direction = 'out'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 5, results.length
    assert_equal 1, total_pages
    assert_equal referrals(:mccoy_to_kildare_2).id, results.first['referral_id']
  end

  def test_search_and_filter_direction_filter_in
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_direction = 'in'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 2, results.length
    assert_equal 1, total_pages
    assert_equal referrals(:kildare_to_mccoy_4).id, results.first['referral_id']
  end

  def test_search_and_filter_owner_filter_unassigned
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_owner = 'unassigned'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 1, results.length
    assert_equal 1, total_pages
    assert_equal referrals(:stretch_to_mccoy_9).id, results.first['referral_id']
  end

  def test_search_and_filter_owner_filter_with_user_id
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_owner = users(:quentin).id.to_s
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 1, results.length
    assert_equal 1, total_pages
    assert_equal referrals(:kildare_to_mccoy_4).id, results.first['referral_id']
  end

  def test_search_and_filter_owner_filter_unassigned_and_out
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_direction = 'out'
    filter.filter_owner = 'unassigned'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 1, results.length
    assert_equal 1, total_pages
    assert_equal referrals(:stretch_to_mccoy_9).id, results.first['referral_id']
  end

  def test_search_and_filter_owner_filter_unassigned_and_in
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_direction = 'in'
    filter.filter_owner = 'unassigned'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 1, results.length
    assert_equal 1, total_pages
    assert_equal referrals(:stretch_to_mccoy_9).id, results.first['referral_id']
  end

  def test_search_and_filter_type_transfer_patient
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_type = 'tag_transfer_patient_type'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 0, results.length
    assert_equal 0, total_pages
  end

  def test_search_and_filter_type_treatment_direction_in
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_type = 'tag_treatment_type'
    filter.filter_direction = 'in'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 2, results.length
    assert_equal 1, total_pages
  end

  def test_search_and_filter_type_treatment_direction_out
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_type = 'tag_treatment_type'
    filter.filter_direction = 'out'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 5, results.length
    assert_equal 1, total_pages
  end

  def test_search_and_filter_type_other
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_type = 'other'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 0, results.length
    assert_equal 0, total_pages
  end

  def test_search_and_filter_status_in
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_status = 'in_progress'
    filter.filter_direction = 'in'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 1, results.length
    assert_equal 1, total_pages
  end

  def test_search_and_filter_status_out
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_status = 'complete'
    filter.filter_direction = 'out'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 0, results.length
    assert_equal 0, total_pages
  end

  def test_search_and_filter_status_both
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_status = 'in_progress'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 1, results.length
    assert_equal 1, total_pages
  end

  def test_search_and_filter_status_both_by_new_status
    filter = DashboardFilter.new
    filter.workgroup_id = workgroups(:workgroup_mccoy).id
    filter.sort_field = 'patient'
    filter.sort_order = 'asc'
    filter.filter_status = 'new'
    results_per_page = 10

    # page 1 - first result
    results, total_pages, total_count = Referral.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 4, results.length
    assert_equal 1, total_pages
  end

  def test_count_profile_referral_in_user_profile
    workgroup = workgroups(:workgroup_mccoy)
    profile = profiles(:profile_quentin)
    assert_equal 3, Referral.count_profile_referral_in(profile)
  end

  def test_count_profile_referral_out_user_profile
    workgroup = workgroups(:workgroup_mccoy)
    profile = profiles(:profile_quentin)
    assert_equal 5, Referral.count_profile_referral_out(profile)
  end

  def test_count_profile_referral_in_workgroup_profile
    workgroup = workgroups(:workgroup_mccoy)
    profile = profiles(:profile_workgroup_mccoy)
    assert_equal 6, Referral.count_profile_referral_in(profile)
  end

  def test_count_profile_referral_out_workgroup_profile
    workgroup = workgroups(:workgroup_mccoy)
    profile = profiles(:profile_workgroup_mccoy)
    assert_equal 5, Referral.count_profile_referral_out(profile)
  end
end

