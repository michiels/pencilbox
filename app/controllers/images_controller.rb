class ImagesController < ApplicationController

  def show
    dbsession = DropboxSession.deserialize(session[:dropbox_session])
    @client = DropboxClient.new(dbsession, :app_folder)

    file = "/#{params[:filename]}.#{params[:format]}"

    send_data @client.get_file(file), disposition: 'inline'
  end

end
