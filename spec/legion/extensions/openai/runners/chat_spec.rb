# frozen_string_literal: true

RSpec.describe Legion::Extensions::Openai::Runners::Chat do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Openai::Helpers::Client
      extend Legion::Extensions::Openai::Runners::Chat
    end
  end
  let(:api_key) { 'sk-test-key' }
  let(:conn) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, body: response_body) }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#create' do
    let(:response_body) do
      { 'id' => 'chatcmpl-123', 'choices' => [{ 'message' => { 'content' => 'Hello!' } }] }
    end

    it 'creates a chat completion' do
      messages = [{ role: 'user', content: 'Hi' }]
      allow(conn).to receive(:post)
        .with('/v1/chat/completions', hash_including(model: 'gpt-4o', messages: messages))
        .and_return(response)

      result = test_class.create(model: 'gpt-4o', messages: messages, api_key: api_key)
      expect(result[:result]).to eq(response_body)
    end

    it 'includes optional parameters when provided' do
      allow(conn).to receive(:post)
        .with('/v1/chat/completions', hash_including(temperature: 0.7, max_tokens: 100))
        .and_return(response)

      result = test_class.create(model: 'gpt-4o', messages: [], api_key: api_key, temperature: 0.7, max_tokens: 100)
      expect(result[:result]).to eq(response_body)
    end
  end
end
