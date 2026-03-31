# frozen_string_literal: true

RSpec.describe Legion::Extensions::Openai::Runners::Moderations do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Openai::Helpers::Client
      extend Legion::Extensions::Openai::Runners::Moderations
    end
  end
  let(:api_key) { 'sk-test-key' }
  let(:conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#create' do
    let(:response_body) { { 'results' => [{ 'flagged' => false, 'categories' => {} }] } }

    it 'moderates content' do
      allow(conn).to receive(:post)
        .with('/v1/moderations', hash_including(input: 'Hello'))
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.create(input: 'Hello', api_key: api_key)
      expect(result[:result]['results'].first['flagged']).to be(false)
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:post)
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.create(input: 'Hello', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:post)
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.create(input: 'Hello', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end
end
