require 'test_helper'

class BoxesControllerTest < ActionController::TestCase
  test "show displays box based on username" do
    Box.skip_synchronization!

    get :show, id: "michiels"

    assert_response :success
    assert_equal boxes(:for_michiel), assigns(:box)
  end

  test "show displays articles in top level for username" do
    Box.skip_synchronization!

    article_in_subfolder = Article.create(box: boxes(:for_michiel), path: "/subfolder/article.txt", slug: "article", dirname: "/subfolder")

    get :show, id: "michiels"

    assert_response :success
    assert assigns(:articles).include?(articles(:single_file))
    assert !assigns(:articles).include?(article_in_subfolder)
  end
end
