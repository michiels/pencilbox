class BoxesController < ApplicationController

  def show
    @box = Box.find(params[:id])

    @dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
    @dbsession.set_access_token(@box.dropbox_access_key, @box.dropbox_access_secret)

    @client = DropboxClient.new(@dbsession, :app_folder)

    root = @client.delta(@box.dropbox_cursor)
    ordered_files = root['entries'].reject{ |path, metadata| metadata.nil? || !['text/plain', 'application/octet-stream'].include?(metadata['mime_type']) || path.count('/') > 1 }

    ordered_files.each do |path, dropbox_file|
      article = @box.articles.where(path: path).first
      article ||= @box.articles.new(path: path, body: @client.get_file(path), published_at: Time.now)

      if article.updated_at < dropbox_file['modified']
        article.body = @client.get_file(path)
        article.updated_at = dropbox_file['modified']
      end

      article.save
    end

    @box.update_column(:dropbox_cursor, root['cursor'])

    @articles = @box.articles.order(:published_at).paginate page: params[:page]
  end

end
