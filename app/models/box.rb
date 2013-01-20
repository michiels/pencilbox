class Box < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  
  belongs_to :user

  @@perform_sync = true

  def self.skip_synchronization!
    @@perform_sync = false
  end

  def synchronize!
    if @@perform_sync
      dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
      dbsession.set_access_token(self.dropbox_access_key, self.dropbox_access_secret)

      client = DropboxClient.new(dbsession, :app_folder)

      root = client.delta(self.dropbox_cursor)
      ordered_files = root['entries']

      ordered_files.each do |path, dropbox_file|
        article = self.articles.where(path: path).first_or_initialize

        if dropbox_file.nil?
          article.destroy
        else
          if article.new_record?
            if %w(text/plain application/octet-stream).include?(dropbox_file['mime_type']) && path.count('/') < 2
              article.published_at = Time.now
              article.body = client.get_file(path)
              article.save
            end
          elsif article.updated_at < dropbox_file['modified']
            article.body = client.get_file(path)
            article.updated_at = dropbox_file['modified']
            article.save
          end

        end

      end

      self.update_column(:dropbox_cursor, root['cursor'])
    end
  end
end
