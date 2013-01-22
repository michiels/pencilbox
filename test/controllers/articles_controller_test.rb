require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  test "get show displays a single article" do
    @request.host = "pencilboxes.test"
    get :show, :box_id => users(:michiel).username, :article_path => articles(:single_file).slug

    assert_response :success
    assert_equal [articles(:single_file)], assigns(:articles)
  end

  test "get show displays a list of articles for folder" do
    articles(:single_file).update_column(:dirname, "/folder")
    articles(:single_file).update_column(:path, "/folder/single_file.md")
    article_two = articles(:single_file).dup
    article_two.attributes = { dirname: "/folder", path: "/folder/single_file_two.md" }
    article_two.box = boxes(:for_michiel)
    article_two.save

    @request.host = "pencilboxes.test"
    get :show, :box_id => users(:michiel).username, :article_path => "folder"

    assert_response :success
    assert assigns(:articles).include?(articles(:single_file))
    assert assigns(:articles).include?(article_two)
  end

  test "get show displays article inside folder" do
    articles(:single_file).update_column(:dirname, "/folder")
    articles(:single_file).update_column(:path, "/folder/single_file.md")

    get :show, :box_id => users(:michiel).username, :article_path => "folder/single_file"

    assert_response :success
    assert_equal [articles(:single_file)], assigns(:articles)
  end
end
