require 'rails_helper'

RSpec.describe SearchQueryLogger, type: :job do
  let(:redis) { double('Redis') }
  let(:query) { 'Rails Testing' }
  let(:ip_address) { '127.0.0.1' }
  let(:key) { "#{ip_address}-Rails" }
  let(:current_time) { Time.now.to_i }

  before do
    allow(Redis).to receive(:new).and_return(redis)
  end

  context 'when the key already exists' do
    before do
      existing_data = { 'query' => 'Old Query', 'last_modified' => (Time.now - 20).to_i }.to_json
      allow(redis).to receive(:get).with(key).and_return(existing_data)
      allow(redis).to receive(:set)
    end

    it 'updates the existing Redis entry with the new query and current timestamp' do
      expected_data = {
        'query' => query,
        'last_modified' => kind_of(Integer)
      }

      allow(Time).to receive(:now).and_return(Time.at(current_time))

      expected_json = JSON.dump(expected_data)

      expect(redis).to receive(:set) do |actual_key, actual_data|
        expect(actual_key).to eq(key)
        actual_data_hash = JSON.parse(actual_data)
        expect(actual_data_hash['query']).to eq(query)
        expect(actual_data_hash['last_modified']).to be_within(1).of(current_time)
      end

      SearchQueryLogger.new.perform(query, ip_address)
    end
  end

  context 'when the key does not exist' do
    before do
      allow(redis).to receive(:get).with(key).and_return(nil)
      allow(redis).to receive(:set)
    end

    it 'creates a new Redis entry with the query and current timestamp' do
      expected_data = {
        'query' => query,
        'last_modified' => kind_of(Integer)
      }

      allow(Time).to receive(:now).and_return(Time.at(current_time))

      expected_json = JSON.dump(expected_data)

      expect(redis).to receive(:set) do |actual_key, actual_data|
        expect(actual_key).to eq(key)
        actual_data_hash = JSON.parse(actual_data)
        expect(actual_data_hash['query']).to eq(query)
        expect(actual_data_hash['last_modified']).to be_within(1).of(current_time)
      end

      SearchQueryLogger.new.perform(query, ip_address)
    end
  end
end
