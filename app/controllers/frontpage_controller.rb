class FrontpageController < ApplicationController

  def index
    logger.info(ENV.inspect)
  end
  
end
