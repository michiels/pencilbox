class FrontpageController < ApplicationController

  def index
    raise "meh"
    if user_signed_in?
      redirect_to dashboard_url
    end
  end
  
end
