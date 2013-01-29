class ArticlesController < ApplicationController

  layout "boxes"

  def show
    @user = User.where(username: params[:box_id]).first
    @box = @user.box

    dirname = File.dirname(params[:article_path])
    dirname = "" if dirname == "."
    filename = File.basename(params[:article_path])

    @folder = @box.folders.where(path: "/#{params[:article_path]}").first
    @articles = @box.articles.where(dirname: "/#{params[:article_path]}")

    if @folder
      @asset_dir = @folder.path
    else
      @asset_dir = dirname.slice(1,-1)
    end

    if !@articles.any?
      @articles = [@box.articles.where(dirname: "/#{dirname}", slug: filename).first!]
    end
  end

end
