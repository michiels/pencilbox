require 'iconv'

class Box < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  has_many :folders, dependent: :destroy
  
  belongs_to :user

  @@perform_sync = true

  def self.skip_synchronization!
    @@perform_sync = false
  end

  def synchronize!
    if @@perform_sync
      dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
      dbsession.set_access_token(self.dropbox_access_kic = Iconv.new('UTF-8//IGNORE', 'UTF-8')ey, self.dropbox_access_secret)

      client = DropboxClient.new(dbsession, :app_folder)

      root = client.delta(self.dropbox_cursor)
      ordered_files = root['entries']

      ordered_files.each do |path, dropbox_file|
        article = self.articles.where(path: path).first_or_initialize
        folder = self.folders.where(path: path).first_or_initialize

        if dropbox_file.nil?
          article.destroy
          folder.destroy
        else
          if dropbox_file['is_dir']
            folder.save
          else
            begin
              ic = Iconv.new('UTF8//IGNORE', 'UTF-8')
              if article.new_record?
                if %w(text/plain application/octet-stream).include?(dropbox_file['mime_type'])
                  article.published_at = Time.now
                  file_contents =  client.get_file(path)
                  article.body = ic.iconv(file_contents)
                  article.dirname = File.dirname(path)
                  article.slug = File.basename(path, File.extname(path)).parameterize
                  article.save
                end
              elsif article.updated_at < dropbox_file['modified']
                file_contents =  client.get_file(path)
                article.body = ic.iconv(file_contents)
                article.updated_at = dropbox_file['modified']
                article.dirname = File.dirname(path)
                article.slug = File.basename(path, File.extname(path)).parameterize
                article.save
              end
            rescue Exception => e
              logger.info "#{e.message}: #{file_contents.encoding.name} #{path} #{path.encoding.name}"
              raise e
            end
          end

        end

      end

      self.update_column(:dropbox_cursor, root['cursor'])
    end
  end
end
