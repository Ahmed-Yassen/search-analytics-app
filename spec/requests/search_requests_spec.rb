require 'rails_helper'

RSpec.describe "SearchRequests", type: :request do
  before do
    Query.delete_all
    ActiveJob::Base.queue_adapter = :test
  end

  describe "GET /search" do
    context "with valid query" do
      it "creates a Query record if enter key was pressed" do
        get "/search", params: { query: "Rails Testing", enter_key_pressed: "true" }
        expect(Query.all.size).to eq(1)
        expect(Query.first.content).to eq("Rails Testing")
      end

      it "logs the query to Redis if Enter key was not pressed" do
        allow(SearchQueryLogger).to receive(:perform_async)

        get "/search", params: { query: "Rails Testing" }
        expect(SearchQueryLogger).to have_received(:perform_async).with('Rails Testing', '127.0.0.1')
      end
    end
  end
end
