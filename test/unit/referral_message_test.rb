require File.dirname(__FILE__) + '/../test_helper'

class ReferralMessageTest < ActiveSupport::TestCase
  def test_fixtures_should_load
    assert ReferralMessage.count > 0
  end

  def test_find_eager_should_load
    message = ReferralMessage.find_eager(referral_messages(:welby_to_stretch_closed_message_1).id)
    assert_not_nil message
    assert_not_nil message.referral
    assert_not_nil message.referral_message_type
  end

  def test_search_and_filter_no_sort
    referral = referrals(:mccoy_to_kildare_3)
    results_per_page = 10
    filter = MessageFilter.new
    filter.referral_id = referral.id
    filter.referral_source_or_target_id = referral_sources(:mccoy_to_kildare_3_source)
    results, total_pages = ReferralMessage.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 3, results.length
    assert_equal 1, total_pages
    assert_equal referral_messages(:mccoy_to_kildare_3_general_1).id, results.first.id
  end

  def test_search_and_filter_sort_by_status
    referral = referrals(:mccoy_to_kildare_3)
    results_per_page = 10
    filter = MessageFilter.new
    filter.referral_id = referral.id
    filter.referral_source_or_target_id = referral_sources(:mccoy_to_kildare_3_source)
    filter.sort_field = 'status'
    results, total_pages = ReferralMessage.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 3, results.length
    assert_equal 1, total_pages
    assert_equal referral_messages(:mccoy_to_kildare_3_request_2).id, results.first.id
  end

  def test_search_and_filter_sort_by_type_desc
    referral = referrals(:mccoy_to_kildare_3)
    results_per_page = 10
    filter = MessageFilter.new
    filter.referral_id = referral.id
    filter.referral_source_or_target_id = referral_sources(:mccoy_to_kildare_3_source)
    filter.sort_field = 'type'
    filter.sort_order = 'desc'
    results, total_pages = ReferralMessage.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 3, results.length
    assert_equal 1, total_pages
    assert_equal referral_messages(:mccoy_to_kildare_3_request_2).id, results.first.id
  end

  def test_search_and_filter_sort_by_created
    referral = referrals(:mccoy_to_kildare_3)
    results_per_page = 10
    filter = MessageFilter.new
    filter.referral_id = referral.id
    filter.referral_source_or_target_id = referral_sources(:mccoy_to_kildare_3_source)
    filter.sort_field = 'created'
    results, total_pages = ReferralMessage.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 3, results.length
    assert_equal 1, total_pages
    assert_equal referral_messages(:mccoy_to_kildare_3_request_2).id, results.first.id
  end

  def test_search_and_filter_sort_by_subject
    referral = referrals(:mccoy_to_kildare_3)
    results_per_page = 10
    filter = MessageFilter.new
    filter.referral_id = referral.id
    filter.referral_source_or_target_id = referral_sources(:mccoy_to_kildare_3_source)
    filter.sort_field = 'subject'
    filter.sort_order = 'desc'
    results, total_pages = ReferralMessage.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 3, results.length
    assert_equal 1, total_pages
    assert_equal referral_messages(:mccoy_to_kildare_3_general_1).id, results.first.id
  end

  def test_search_and_filter_by_target
    referral = referrals(:mccoy_to_kildare_3)
    results_per_page = 10
    filter = MessageFilter.new
    filter.referral_id = referral.id
    filter.referral_source_or_target_id = referral_targets(:mccoy_to_kildare_3_target)
    filter.sort_field = 'subject'
    filter.sort_order = 'desc'
    results, total_pages = ReferralMessage.search_and_filter(filter, results_per_page)
    assert_not_nil results
    assert_not_nil total_pages
    assert_equal 3, results.length
    assert_equal 1, total_pages
    assert_equal referral_messages(:mccoy_to_kildare_3_general_1).id, results.first.id
  end

  def test_validation_general_note
    message = ReferralMessage.new

    assert !message.valid?
    assert_equal 3, message.errors.length

    message.subject = "Test"
    assert !message.valid?
    assert_equal 2, message.errors.length

    message.created_by = users(:quentin)
    assert !message.valid?
    assert_equal 1, message.errors.length

    message.referral_message_type = referral_message_types(:general_note)
    assert message.valid?
  end

  def test_validation_request
    message = ReferralMessage.new

    assert !message.valid?
    assert_equal 3, message.errors.length

    message.subject = "Test"
    assert !message.valid?
    assert_equal 2, message.errors.length

    message.created_by = users(:quentin)
    assert !message.valid?
    assert_equal 1, message.errors.length

    message.referral_message_type = referral_message_types(:request)
    assert !message.valid?
    assert_equal 1, message.errors.length

    message.response_required_by = 1.day.from_now
    assert message.valid?
  end
end
