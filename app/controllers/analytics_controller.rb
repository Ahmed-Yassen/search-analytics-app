
class AnalyticsController < ApplicationController
  def index
    @queries = Query.group(:content, :user_ip).count
  end
end
