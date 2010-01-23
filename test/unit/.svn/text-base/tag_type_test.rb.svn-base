require File.dirname(__FILE__) + '/../test_helper'

class TagTypeTest < ActiveSupport::TestCase
  def test_fixture_should_load
    assert TagType.count >= 3
  end

  def test_delete
    tag_type = TagType.find 'location'
    assert tag_type

    original_count = TagType.count

    # mark as deleted
    tag_type.destroy

    begin
      tag_type = TagType.find 'location'
    rescue
      tag_type = nil
    end
    assert_nil tag_type

    tag_type = TagType.find_with_deleted 'location'
    assert tag_type

    assert_equal original_count-1, TagType.count
    assert_equal original_count, TagType.count_with_deleted

    # really delete
    tag_type.destroy!

    begin
      tag_type = TagType.find 'location'
    rescue
      tag_type = nil
    end
    assert_nil tag_type

    assert_equal original_count-1, TagType.count
    assert_equal original_count-1, TagType.count_with_deleted
  end
end
