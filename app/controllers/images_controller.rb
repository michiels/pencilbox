class ImagesController < ApplicationController

  def show
    @box = User.where(username: params[:id]).first.try(:box)

    @dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
    @dbsession.set_access_token(@box.dropbox_access_key, @box.dropbox_access_secret)

    @client = DropboxClient.new(@dbsession, :app_folder)

    file = "/#{params[:filename]}"

    send_data @client.get_file(file), disposition: 'inline'
  end

end
