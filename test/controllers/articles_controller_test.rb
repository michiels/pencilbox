require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  test "displays a single article" do
    @request.host = "pencilboxes.test"
    get :show, :box_id => users(:michiel).username, :article_path => articles(:single_file).slug

    assert_response :success
    assert_equal [articles(:single_file)], assigns(:articles)
  end
end
