require 'rails_helper'

RSpec.describe "analytics/index.html.erb", type: :view do
  before do
    Query.create!(content: 'Rails Testing', user_ip: '127.0.0.1')
    Query.create!(content: 'Rails Testing', user_ip: '127.0.0.2')
    Query.create!(content: 'Another Query', user_ip: '127.0.0.1')

    assign(:queries, Query.group(:content)
                          .select("content, COUNT(*) as count, array_agg(user_ip) as user_ips")
                          .order(count: :desc))

    render
  end

  it "displays a list of queries grouped by content with counts and user IPs" do
    expect(rendered).to have_content('Rails Testing')
    expect(rendered).to have_content('Another Query')
    expect(rendered).to have_content('127.0.0.1')
    expect(rendered).to have_content('127.0.0.2')
  end
end
