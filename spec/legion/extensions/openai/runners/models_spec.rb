# frozen_string_literal: true

RSpec.describe Legion::Extensions::Openai::Runners::Models do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Openai::Helpers::Client
      extend Legion::Extensions::Openai::Runners::Models
    end
  end
  let(:api_key) { 'sk-test-key' }
  let(:conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#list' do
    it 'lists all models' do
      body = { 'data' => [{ 'id' => 'gpt-4o' }, { 'id' => 'gpt-3.5-turbo' }] }
      allow(conn).to receive(:get).with('/v1/models').and_return(instance_double(Faraday::Response, body: body))

      result = test_class.list(api_key: api_key)
      expect(result[:result]['data'].length).to eq(2)
    end
  end

  describe '#retrieve' do
    it 'retrieves a specific model' do
      body = { 'id' => 'gpt-4o', 'object' => 'model' }
      allow(conn).to receive(:get).with('/v1/models/gpt-4o').and_return(instance_double(Faraday::Response, body: body))

      result = test_class.retrieve(model: 'gpt-4o', api_key: api_key)
      expect(result[:result]['id']).to eq('gpt-4o')
    end
  end

  describe '#delete' do
    it 'deletes a fine-tuned model' do
      body = { 'id' => 'ft:gpt-3.5-turbo:org:custom', 'deleted' => true }
      allow(conn).to receive(:delete)
        .with('/v1/models/ft:gpt-3.5-turbo:org:custom')
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.delete(model: 'ft:gpt-3.5-turbo:org:custom', api_key: api_key)
      expect(result[:result]['deleted']).to be(true)
    end
  end
end
