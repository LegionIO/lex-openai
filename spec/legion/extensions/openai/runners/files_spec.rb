# frozen_string_literal: true

RSpec.describe Legion::Extensions::Openai::Runners::Files do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Openai::Helpers::Client
      extend Legion::Extensions::Openai::Runners::Files
    end
  end
  let(:api_key) { 'sk-test-key' }
  let(:conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#list' do
    let(:response_body) { { 'data' => [{ 'id' => 'file-abc123' }] } }

    it 'lists all files' do
      allow(conn).to receive(:get).with('/v1/files').and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.list(api_key: api_key)
      expect(result[:result]['data'].first['id']).to eq('file-abc123')
    end

    it 'filters by purpose' do
      body = { 'data' => [] }
      allow(conn).to receive(:get)
        .with('/v1/files?purpose=fine-tune')
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.list(api_key: api_key, purpose: 'fine-tune')
      expect(result[:result]['data']).to eq([])
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:get).with('/v1/files').and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.list(api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:get).with('/v1/files').and_return(instance_double(Faraday::Response, body: response_body))

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
    let(:response_body) { { 'id' => 'file-abc123', 'filename' => 'data.jsonl' } }

    it 'retrieves file metadata' do
      allow(conn).to receive(:get)
        .with('/v1/files/file-abc123')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.retrieve(file_id: 'file-abc123', api_key: api_key)
      expect(result[:result]['filename']).to eq('data.jsonl')
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:get)
        .with('/v1/files/file-abc123')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.retrieve(file_id: 'file-abc123', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:get)
        .with('/v1/files/file-abc123')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.retrieve(file_id: 'file-abc123', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end

  describe '#delete' do
    let(:response_body) { { 'id' => 'file-abc123', 'deleted' => true } }

    it 'deletes a file' do
      allow(conn).to receive(:delete)
        .with('/v1/files/file-abc123')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.delete(file_id: 'file-abc123', api_key: api_key)
      expect(result[:result]['deleted']).to be(true)
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:delete)
        .with('/v1/files/file-abc123')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.delete(file_id: 'file-abc123', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:delete)
        .with('/v1/files/file-abc123')
        .and_return(instance_double(Faraday::Response, body: response_body))

      result = test_class.delete(file_id: 'file-abc123', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end

  describe '#content' do
    it 'downloads file content' do
      body = 'file content here'
      allow(conn).to receive(:get)
        .with('/v1/files/file-abc123/content')
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.content(file_id: 'file-abc123', api_key: api_key)
      expect(result[:result]).to eq('file content here')
    end

    it 'includes a usage key in the response' do
      allow(conn).to receive(:get)
        .with('/v1/files/file-abc123/content')
        .and_return(instance_double(Faraday::Response, body: 'data'))

      result = test_class.content(file_id: 'file-abc123', api_key: api_key)
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage values' do
      allow(conn).to receive(:get)
        .with('/v1/files/file-abc123/content')
        .and_return(instance_double(Faraday::Response, body: 'data'))

      result = test_class.content(file_id: 'file-abc123', api_key: api_key)
      expect(result[:usage]).to eq(
        input_tokens:       0,
        output_tokens:      0,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end
  end
end
