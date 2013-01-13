class BoxesController < ApplicationController

  def show
    @box = Box.find(params[:id])

    @dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
    @dbsession.set_access_token(@box.dropbox_access_key, @box.dropbox_access_secret)

    @client = DropboxClient.new(@dbsession, :app_folder)

    root = @client.metadata('/')
    ordered_files = root['contents'].reject{ |f| !['text/plain', 'application/octet-stream'].include?(f['mime_type']) }

    ordered_files.each do |dropbox_file|
      article = @box.articles.where(path: dropbox_file['path']).first
      article ||= @box.articles.new(path: dropbox_file['path'], body: @client.get_file(dropbox_file['path']), published_at: Time.now)
      article.save
    end

    @articles = @box.articles.order(:published_at).paginate page: params[:page]
  end

end
