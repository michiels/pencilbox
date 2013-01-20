class BoxesController < ApplicationController

  def show
    @box = User.where(username: params[:id]).first.try(:box)

    if @box.blank?
      render :not_found
      return
    end

    @box.synchronize!

    @articles = @box.articles.order('published_at desc').paginate page: params[:page]
  end

end
