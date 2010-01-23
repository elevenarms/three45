require File.dirname(__FILE__) + '/../test_helper'

class TagTest < ActiveSupport::TestCase
  def test_fixture_should_load
    assert Tag.count >= 6
  end

  def test_should_find_with_tag_type
    tags = Tag.find_tags_for_type 'location'
    assert_equal 3, tags.size
  end

  def test_tag_delete
    tag = Tag.find 'tag_location_north_austin'
    assert tag

    original_count = Tag.count

    # mark as deleted
    tag.destroy

    begin
      tag = Tag.find 'tag_location_north_austin'
    rescue
      tag = nil
    end
    assert_nil tag

    tag = Tag.find_with_deleted 'tag_location_north_austin'
    assert tag

    assert_equal original_count-1, Tag.count
    assert_equal original_count, Tag.count_with_deleted

    # really delete
    tag.destroy!

    begin
      tag = Tag.find 'tag_location_north_austin'
    rescue
      tag = nil
    end
    assert_nil tag

    assert_equal original_count-1, Tag.count
    assert_equal original_count-1, Tag.count_with_deleted
  end
end
