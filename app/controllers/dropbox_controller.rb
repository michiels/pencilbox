
class DropboxController < ApplicationController

  def authorize
    if !params[:oauth_token]
      dbsession = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
      session[:dropbox_session] = dbsession.serialize

      redirect_to dbsession.get_authorize_url url_for(action: "authorize")
    else
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      dbsession.get_access_token

      client = DropboxClient.new(dbsession, :app_folder)
      uid = client.account_info['uid'].to_s
      display_name = client.account_info['display_name']

      box = Box.where(uid: uid).first_or_initialize
      box.display_name = display_name
      box.dropbox_access_key = dbsession.access_token.key
      box.dropbox_access_secret = dbsession.access_token.secret

      if box.save
        session[:dropbox_session] = nil

        if box.user.present?
          redirect_to box_url(box)
        else
          session[:signup_box_id] = box.id
          redirect_to new_user_registration_url
        end
      else
        redirect_to root_urle
      end
    end
  end

end
