require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in users(:michiel)

    get :index
    assert_response :success
  end

end
