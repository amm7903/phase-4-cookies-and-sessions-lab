class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  # def show
  #   article = Article.find(params[:id])
  #   render json: article
  # end

  def show
    session[:page_views] ||= 0
    session[:page_views] += 1
    article = Article.find(params[:id])
    if session[:page_views] < 3
      session[:page_views] 
      render json: article
    else
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    end
  end

  private

  # def current_user
  #   @_current_user ||= session[:current_user_id] && 
  #   user.find_by(id: session[:current_user_id])
  # end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
