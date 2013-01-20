class Users::RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
    box_url(resource.box)
  end

  protected

  def build_resource(hash=nil)
    hash ||= user_params || {}
    self.resource = resource_class.new_with_session(hash, session)

    self.resource.password_confirmation = self.resource.password

    if session[:signup_box_id]
      box = Box.find(session[:signup_box_id])
      self.resource.box = box
    else
      session.delete(:signup_box_id)
      redirect_to root_url
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username)
  end
end
