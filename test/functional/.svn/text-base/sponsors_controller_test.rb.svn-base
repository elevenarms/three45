require File.dirname(__FILE__) + '/../test_helper'

class SponsorsControllerTest < ActionController::TestCase
  def test_show_should_require_login
    get :show
    assert_redirected_to :controller=>"sessions", :action=>"new"
  end

  def test_show_should_require_id
    login_as(:quentin)
    get :show
    assert_response :error
  end

  def test_show_should_save_click_and_redirect
    initial_count = TagSponsorClick.count
    login_as(:quentin)
    get :show, :id=>tag_sponsors(:tag_sponsor_humana_one)
    assert_response 302
    assert_equal initial_count+1, TagSponsorClick.count
  end
end
