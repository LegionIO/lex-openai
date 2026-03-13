# frozen_string_literal: true

RSpec.describe Legion::Extensions::Openai::Runners::Audio do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Openai::Helpers::Client
      extend Legion::Extensions::Openai::Runners::Audio
    end
  end
  let(:api_key) { 'sk-test-key' }
  let(:conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#speech' do
    it 'generates speech from text' do
      body = 'binary-audio-data'
      allow(conn).to receive(:post)
        .with('/v1/audio/speech', hash_including(input: 'Hello world'))
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.speech(input: 'Hello world', api_key: api_key)
      expect(result[:result]).to eq('binary-audio-data')
    end
  end

  describe '#transcribe' do
    it 'transcribes audio to text' do
      body = { 'text' => 'Hello world' }
      allow(conn).to receive(:post).and_return(instance_double(Faraday::Response, body: body))
      allow(Faraday::Multipart::FilePart).to receive(:new).and_return('file-part')

      result = test_class.transcribe(file: '/tmp/audio.mp3', api_key: api_key)
      expect(result[:result]['text']).to eq('Hello world')
    end
  end

  describe '#translate' do
    it 'translates audio to English' do
      body = { 'text' => 'Translated text' }
      allow(conn).to receive(:post).and_return(instance_double(Faraday::Response, body: body))
      allow(Faraday::Multipart::FilePart).to receive(:new).and_return('file-part')

      result = test_class.translate(file: '/tmp/audio.mp3', api_key: api_key)
      expect(result[:result]['text']).to eq('Translated text')
    end
  end
end
