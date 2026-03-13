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
    it 'moderates content' do
      body = { 'results' => [{ 'flagged' => false, 'categories' => {} }] }
      allow(conn).to receive(:post)
        .with('/v1/moderations', hash_including(input: 'Hello'))
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.create(input: 'Hello', api_key: api_key)
      expect(result[:result]['results'].first['flagged']).to be(false)
    end
  end
end
