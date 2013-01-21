require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase
  test "should create new account when box in session" do
    session['devise.signup_box_id'] = boxes(:no_user)
    @request.env['devise.mapping'] = Devise.mappings[:user]

    post :create, user: { username: "newuser", email: "newuser@newdomain.com", password: "password"}

    assert_redirected_to box_url(id: boxes(:no_user).reload.user.username)
    assert_equal "newuser", boxes(:no_user).reload.user.username

    assert_nil session['devise.signup_box_id']
  end

  test "new should redirect to homepage when no Dropbox connected in session" do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    get :new

    assert_redirected_to root_url
  end
end
