
class SearchController < ApplicationController
  def index
    query = params[:query]
    return render json: { articles: [] } if query.blank?

    @articles = Article.where('title LIKE ?', "%#{query}%")
    render json: { articles: @articles.map { |article| { title: article.title } } }
  end
end
