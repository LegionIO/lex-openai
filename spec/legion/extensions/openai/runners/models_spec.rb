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
    let(:response_body) { { 'data' => [{ 'id' => 'gpt-4o' }, { 'id' => 'gpt-3.5-turbo' }] } }

    it 'lists all models' do
      allow(conn).to receive(:get).with('/v1/models').and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.list(api_key: api_key)
      expect(result[:result]['data'].length).to eq(2)
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:get).with('/v1/models').and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.list(api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:get).with('/v1/models').and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.list(api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end

  describe '#retrieve' do
    let(:response_body) { { 'id' => 'gpt-4o', 'object' => 'model' } }

    it 'retrieves a specific model' do
      allow(conn).to receive(:get).with('/v1/models/gpt-4o').and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.retrieve(model: 'gpt-4o', api_key: api_key)
      expect(result[:result]['id']).to eq('gpt-4o')
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:get).with('/v1/models/gpt-4o').and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.retrieve(model: 'gpt-4o', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:get).with('/v1/models/gpt-4o').and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.retrieve(model: 'gpt-4o', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end

  describe '#delete' do
    let(:response_body) { { 'id' => 'ft:gpt-3.5-turbo:org:custom', 'deleted' => true } }

    it 'deletes a fine-tuned model' do
      allow(conn).to receive(:delete)
        .with('/v1/models/ft:gpt-3.5-turbo:org:custom')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.delete(model: 'ft:gpt-3.5-turbo:org:custom', api_key: api_key)
      expect(result[:result]['deleted']).to be(true)
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:delete)
        .with('/v1/models/ft:gpt-3.5-turbo:org:custom')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.delete(model: 'ft:gpt-3.5-turbo:org:custom', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:delete)
        .with('/v1/models/ft:gpt-3.5-turbo:org:custom')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.delete(model: 'ft:gpt-3.5-turbo:org:custom', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end
end
