
class AnalyticsController < ApplicationController
  def index
    @queries = Query.group(:content).select("content, COUNT(*) as count, array_agg(user_ip) as user_ips").order(count: :desc)
  end
end
