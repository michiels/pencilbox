class FrontpageController < ApplicationController

  def index
    if user_signed_in?
      redirect_to dashboard_url
    end
  end
  
end
