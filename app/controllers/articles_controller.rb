class ArticlesController < ApplicationController

  layout "boxes"

  def show
    @user = User.where(username: params[:box_id]).first
    @box = @user.box

    dirname = File.dirname(params[:article_path])
    dirname = "" if dirname == "."
    filename = File.basename(params[:article_path])

    if dirname.blank?
      @asset_dir = "#{filename}"
    else
      @asset_dir = dirname.slice(1,-1)
    end

    @articles = Article.where(dirname: "/#{params[:article_path]}")

    if !@articles.any?
      @articles = [@box.articles.where(dirname: "/#{dirname}", slug: filename).first!]
    end
  end

end
