require File.dirname(__FILE__) + '/../test_helper'

class WorkgroupTypeTest < ActiveSupport::TestCase
  def test_ppw_apw
    type = WorkgroupType.find('ppw')
    type.id = "ppw"
    assert type.ppw?
    assert !type.apw?

    type = WorkgroupType.find('apw')
    assert !type.ppw?
    assert type.apw?

    type = WorkgroupType.new
    type.id = "zpw"
    assert !type.ppw?
    assert !type.apw?
  end
end
