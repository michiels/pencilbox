require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase
  test "should create new account when box in session" do
    session['devise.signup_box_id'] = boxes(:no_user)
    @request.env['devise.mapping'] = Devise.mappings[:user]

    post :create, user: { username: "michiels", email: "michiel.sikkes@gmail.com", password: "password"}

    assert_redirected_to box_url(boxes(:no_user))
    assert_equal "michiels", boxes(:no_user).reload.user.username

    assert_nil session['devise.signup_box_id']
  end
end
