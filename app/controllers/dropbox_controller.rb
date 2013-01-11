
class DropboxController < ApplicationController

  def authorize
    if !params[:oauth_token]
      dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
      raise ENV['DROPBOX_APP_KEY']
      session[:dropbox_session] = dbsession.serialize

      redirect_to dbsession.get_authorize_url url_for(action: "authorize")
    else
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      dbsession.get_access_token

      client = DropboxClient.new(dbsession, :app_folder)
      uid = client.account_info['uid'].to_s
      display_name = client.account_info['display_name']

      box = Box.find_or_initialize_by_uid(uid.to_s)
      box.display_name = display_name
      box.dropbox_access_key = dbsession.access_token.key
      box.dropbox_access_secret = dbsession.access_token.secret

      if box.save
        session[:dropbox_session] = nil
        redirect_to box_url(box)
      else
        redirect_to root_urle
      end
    end
  end

end
