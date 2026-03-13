# frozen_string_literal: true

RSpec.describe Legion::Extensions::Openai::Runners::Images do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Openai::Helpers::Client
      extend Legion::Extensions::Openai::Runners::Images
    end
  end
  let(:api_key) { 'sk-test-key' }
  let(:conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#generate' do
    it 'generates an image from a prompt' do
      body = { 'data' => [{ 'url' => 'https://example.com/image.png' }] }
      allow(conn).to receive(:post)
        .with('/v1/images/generations', hash_including(prompt: 'a cat'))
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.generate(prompt: 'a cat', api_key: api_key)
      expect(result[:result]['data'].first['url']).to include('image.png')
    end
  end
end
