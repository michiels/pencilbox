class BoxesController < ApplicationController

  def show
    @box = Box.find(params[:id])

    @dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
    @dbsession.set_access_token(@box.dropbox_access_key, @box.dropbox_access_secret)

    @client = DropboxClient.new(@dbsession, :app_folder)

    @root = @client.metadata('/')
    @ordered_files = @root['contents'].reject{ |f| f['mime_type'] != "text/plain" }.sort { |a,b| a['path'] <=> b['path'] }
  end

end
