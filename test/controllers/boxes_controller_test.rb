require 'test_helper'

class BoxesControllerTest < ActionController::TestCase
  test "show displays box based on username" do

    Box.skip_synchronization!

    get :show, id: "michiels"

    assert_response :success
    assert_equal boxes(:for_michiel), assigns(:box)
  end
end
