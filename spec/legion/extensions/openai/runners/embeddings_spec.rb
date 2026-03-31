# frozen_string_literal: true

RSpec.describe Legion::Extensions::Openai::Runners::Embeddings do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Openai::Helpers::Client
      extend Legion::Extensions::Openai::Runners::Embeddings
    end
  end
  let(:api_key) { 'sk-test-key' }
  let(:conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#create' do
    let(:response_body) { { 'data' => [{ 'embedding' => [0.1, 0.2, 0.3] }] } }

    it 'creates embeddings for input text' do
      allow(conn).to receive(:post)
        .with('/v1/embeddings', hash_including(input: 'Hello'))
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.create(input: 'Hello', api_key: api_key)
      expect(result[:result]['data'].first['embedding']).to eq([0.1, 0.2, 0.3])
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:post)
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.create(input: 'Hello', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage when response has no usage data' do
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

    context 'when response includes usage data' do
      let(:response_body) do
        {
          'data'  => [{ 'embedding' => [0.1, 0.2, 0.3] }],
          'usage' => { 'prompt_tokens' => 8, 'completion_tokens' => 0 }
        }
      end

      it 'maps prompt_tokens to input_tokens' do
        allow(conn).to receive(:post)
          .and_return(instance_double(Faraday::Response, body: response_body))

        result = test_class.create(input: 'Hello', api_key: api_key)
        expect(result[:usage][:input_tokens]).to eq(8)
      end
    end
  end
end
