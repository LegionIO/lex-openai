# frozen_string_literal: true

require 'legion/extensions/openai/helpers/client'

module Legion
  module Extensions
    module Openai
      module Runners
        module Files
          extend Legion::Extensions::Openai::Helpers::Client

          def list(api_key:, purpose: nil, **)
            path = '/v1/files'
            path += "?purpose=#{purpose}" if purpose

            response = client(api_key: api_key, **).get(path)
            { result: response.body }
          end

          def upload(file:, purpose:, api_key:, **)
            payload = {
              file:    Faraday::Multipart::FilePart.new(file, 'application/octet-stream'),
              purpose: purpose
            }

            response = client(api_key: api_key, **).post('/v1/files', payload)
            { result: response.body }
          end

          def retrieve(file_id:, api_key:, **)
            response = client(api_key: api_key, **).get("/v1/files/#{file_id}")
            { result: response.body }
          end

          def delete(file_id:, api_key:, **)
            response = client(api_key: api_key, **).delete("/v1/files/#{file_id}")
            { result: response.body }
          end

          def content(file_id:, api_key:, **)
            response = client(api_key: api_key, **).get("/v1/files/#{file_id}/content")
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
