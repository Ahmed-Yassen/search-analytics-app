
class SearchController < ApplicationController
  def index
    query = params[:query]
    return render json: { articles: [] } if query.blank?

    ip = request.remote_ip
    if params[:enter_key_pressed] == 'true'
      # Save complete query directly if Enter key is pressed
      Query.create!(content: query, user_ip: ip)
    else
      # Otherwise, log the query to Redis
      SearchQueryLogger.perform_async(query, ip) if query.split.size > 1
    end

    @articles = Article.where('title LIKE ?', "%#{query}%")
    render json: { articles: @articles.map { |article| { title: article.title } } }
  end
end
