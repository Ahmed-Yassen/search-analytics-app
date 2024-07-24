
class SearchQueryLogger
  include Sidekiq::Job

  def perform(query, ip_address)
    redis = Redis.new(url: ENV.fetch('REDIS_URL'))
    key = "#{ip_address}-#{query.split.first}"
    current_data = redis.get(key)

    if current_data
      data = JSON.parse(current_data)
      data['query'] = query
      data['last_modified'] = Time.now.to_i
      resp = redis.set(key, data.to_json)
    else
      data = { 'query' => query, 'last_modified' => Time.now.to_i }
      resp = redis.set(key, data.to_json)
    end
  end
end
