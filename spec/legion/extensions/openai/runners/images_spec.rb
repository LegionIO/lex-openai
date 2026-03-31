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
    let(:response_body) { { 'data' => [{ 'url' => 'https://example.com/image.png' }] } }

    it 'generates an image from a prompt' do
      allow(conn).to receive(:post)
        .with('/v1/images/generations', hash_including(prompt: 'a cat'))
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.generate(prompt: 'a cat', api_key: api_key)
      expect(result[:result]['data'].first['url']).to include('image.png')
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:post)
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.generate(prompt: 'a cat', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:post)
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.generate(prompt: 'a cat', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end

  describe '#edit' do
    let(:response_body) { { 'data' => [{ 'url' => 'https://example.com/edited.png' }] } }

    before do
      allow(Faraday::Multipart::FilePart).to receive(:new).and_return('file-part')
    end

    it 'edits an image' do
      allow(conn).to receive(:post).and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.edit(image: '/tmp/img.png', prompt: 'add a hat', api_key: api_key)
      expect(result[:result]).to eq(response_body)
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:post).and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.edit(image: '/tmp/img.png', prompt: 'add a hat', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:post).and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.edit(image: '/tmp/img.png', prompt: 'add a hat', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end

  describe '#variation' do
    let(:response_body) { { 'data' => [{ 'url' => 'https://example.com/variation.png' }] } }

    before do
      allow(Faraday::Multipart::FilePart).to receive(:new).and_return('file-part')
    end

    it 'creates an image variation' do
      allow(conn).to receive(:post).and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.variation(image: '/tmp/img.png', api_key: api_key)
      expect(result[:result]).to eq(response_body)
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:post).and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.variation(image: '/tmp/img.png', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:post).and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.variation(image: '/tmp/img.png', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end
end
