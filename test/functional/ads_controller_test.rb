require File.dirname(__FILE__) + '/../test_helper'

class AdsControllerTest < ActionController::TestCase
  def test_show_should_require_login
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_show_should_require_id
    login_as(:quentin)
    get :show
    assert_response :error
  end

  def test_show_should_create_ad_click
    count = AdClick.count
    ad = ads(:ad_for_mccoy)
    login_as(:quentin)
    get :show, :id=> ad.id
    assert_redirected_to ad.link_url
    assert count+1, AdClick.count
    assert_not_nil assigns(:ad_click)
    assert_equal users(:quentin).id, assigns(:ad_click).user_id
  end
end
