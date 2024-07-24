
class MoveQueriesToDbJob
  include Sidekiq::Job

  def perform
    redis = Redis.new(url: ENV.fetch('REDIS_URL'))

    query_key_regex = /^[0-9a-fA-F:.]+-\w+/ # finds keys that hold queries, ex: "100.100.100-what"

    redis.keys('*').each do |key|
      next unless key.match?(query_key_regex)

      data = JSON.parse(redis.get(key))
      if Time.now.to_i - data['last_modified'] >= 15
        Query.create!(content: data['query'], user_ip: key.split('-').first)
        redis.del(key)
      end
    end
  end
end
