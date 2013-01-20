module ApplicationHelper
  def public_box_url(user)
    box_url(id: user.username)
  end
end
