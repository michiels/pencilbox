require 'test_helper'

class FrontpageControllerTest < ActionController::TestCase
  test "should show index" do
    get :index, :host => 'thisispencilbox.dev'
  end
end
