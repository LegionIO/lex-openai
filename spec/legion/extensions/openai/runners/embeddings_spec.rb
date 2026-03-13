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
    it 'creates embeddings for input text' do
      body = { 'data' => [{ 'embedding' => [0.1, 0.2, 0.3] }] }
      allow(conn).to receive(:post)
        .with('/v1/embeddings', hash_including(input: 'Hello'))
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.create(input: 'Hello', api_key: api_key)
      expect(result[:result]['data'].first['embedding']).to eq([0.1, 0.2, 0.3])
    end
  end
end
