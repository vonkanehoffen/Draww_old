class HomeController < ApplicationController
  def index
    @posts = Post.order("cached_hotness DESC").page params[:page]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
    end
  end

end
