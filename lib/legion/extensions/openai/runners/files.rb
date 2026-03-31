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
            {
              result: response.body,
              usage:  {
                input_tokens:       0,
                output_tokens:      0,
                cache_read_tokens:  0,
                cache_write_tokens: 0
              }
            }
          end

          def upload(file:, purpose:, api_key:, **)
            payload = {
              file:    Faraday::Multipart::FilePart.new(file, 'application/octet-stream'),
              purpose: purpose
            }

            response = client(api_key: api_key, **).post('/v1/files', payload)
            {
              result: response.body,
              usage:  {
                input_tokens:       0,
                output_tokens:      0,
                cache_read_tokens:  0,
                cache_write_tokens: 0
              }
            }
          end

          def retrieve(file_id:, api_key:, **)
            response = client(api_key: api_key, **).get("/v1/files/#{file_id}")
            {
              result: response.body,
              usage:  {
                input_tokens:       0,
                output_tokens:      0,
                cache_read_tokens:  0,
                cache_write_tokens: 0
              }
            }
          end

          def delete(file_id:, api_key:, **)
            response = client(api_key: api_key, **).delete("/v1/files/#{file_id}")
            {
              result: response.body,
              usage:  {
                input_tokens:       0,
                output_tokens:      0,
                cache_read_tokens:  0,
                cache_write_tokens: 0
              }
            }
          end

          def content(file_id:, api_key:, **)
            response = client(api_key: api_key, **).get("/v1/files/#{file_id}/content")
            {
              result: response.body,
              usage:  {
                input_tokens:       0,
                output_tokens:      0,
                cache_read_tokens:  0,
                cache_write_tokens: 0
              }
            }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
