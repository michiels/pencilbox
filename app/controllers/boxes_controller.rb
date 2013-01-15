class BoxesController < ApplicationController

  def show
    @box = Box.find(params[:id])

    @dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
    @dbsession.set_access_token(@box.dropbox_access_key, @box.dropbox_access_secret)

    @client = DropboxClient.new(@dbsession, :app_folder)

    root = @client.delta(@box.dropbox_cursor)
    ordered_files = root['entries']

    ordered_files.each do |path, dropbox_file|
      article = @box.articles.where(path: path).first_or_initialize

      if dropbox_file.nil?
        article.destroy
      else
        if article.new_record? && %w(text/plain application/octet-stream).include?(dropbox_file['mime_type']) && (path.count('/') == 1)
          article.published_at = Time.now
          article.body = @client.get_file(path)
        elsif article.updated_at < dropbox_file['modified']
          article.body = @client.get_file(path)
          article.updated_at = dropbox_file['modified']
        end

        article.save
      end

    end

    @box.update_column(:dropbox_cursor, root['cursor'])

    @articles = @box.articles.order('published_at desc').paginate page: params[:page]
  end

end
