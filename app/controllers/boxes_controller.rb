class BoxesController < ApplicationController

  def show
    @user = User.where(username: params[:id]).first!
    @box = @user.box

    if @box.blank?
      render :not_found
      return
    end

    @box.synchronize!

    @articles = @box.articles.order('published_at desc').where(dirname: '/').paginate page: params[:page]
  end

end
