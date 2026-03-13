# frozen_string_literal: true

require 'faraday'
require 'faraday/multipart'
require 'multi_json'

module Legion
  module Extensions
    module Openai
      module Helpers
        module Client
          DEFAULT_BASE_URL = 'https://api.openai.com'

          def client(api_key:, base_url: DEFAULT_BASE_URL, **)
            Faraday.new(url: base_url) do |conn|
              conn.request :json
              conn.request :multipart
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{api_key}"
            end
          end
        end
      end
    end
  end
end
