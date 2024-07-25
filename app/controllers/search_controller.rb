
class SearchController < ApplicationController
  def index
    query = params[:query]
    return render json: { articles: [] } if query.blank?

    ip = request.remote_ip
    if params[:enter_key_pressed] == 'true'
      # Save complete query directly if Enter key is pressed
      Query.create!(content: query, user_ip: ip)
      remove_duplicate_from_redis(query, ip)
    else
      # Otherwise, log the query to Redis
      SearchQueryLogger.perform_async(query, ip) if query.split.size > 1
    end

    @articles = Article.where('title LIKE ?', "%#{query}%")
    render json: { articles: @articles.map { |article| { title: article.title } } }
  end

  private

  def remove_duplicate_from_redis(query, ip)
    redis = Redis.new(url: ENV.fetch('REDIS_URL'))
    key = "#{ip}-#{query.split.first}"
    redis.del(key)
  end
end
