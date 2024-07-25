require 'rails_helper'

RSpec.describe MoveQueriesToDbJob, type: :job do
  let(:redis) { double('Redis') }
  let(:query_key) { '100.100.100-what' }
  let(:query_data) { { 'query' => 'Rails Testing', 'last_modified' => (Time.now - 15).to_i }.to_json }
  let(:key_regex) { /^[0-9a-fA-F:.]+-\w+/ }

  before do
    allow(Redis).to receive(:new).and_return(redis)
    allow(redis).to receive(:keys).and_return([query_key])
    allow(redis).to receive(:get).with(query_key).and_return(query_data)
    allow(redis).to receive(:del).with(query_key)
  end

  it 'creates a Query record and deletes the Redis key if the key is old enough' do
    expect { described_class.new.perform }.to change(Query, :count).by(1)
    expect(redis).to have_received(:del).with(query_key)
  end

  it 'does not create a Query record or delete the Redis key if the key is too recent' do
    recent_data = { 'query' => 'Rails Testing', 'last_modified' => (Time.now - 5).to_i }.to_json
    allow(redis).to receive(:get).with(query_key).and_return(recent_data)

    expect { described_class.new.perform }.to change(Query, :count).by(0)
    expect(redis).not_to have_received(:del).with(query_key)
  end
end
