# frozen_string_literal: true

require 'legion/extensions/openai/helpers/client'

module Legion
  module Extensions
    module Openai
      module Runners
        module Models
          extend Legion::Extensions::Openai::Helpers::Client

          def list(api_key:, **)
            response = client(api_key: api_key, **).get('/v1/models')
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

          def retrieve(model:, api_key:, **)
            response = client(api_key: api_key, **).get("/v1/models/#{model}")
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

          def delete(model:, api_key:, **)
            response = client(api_key: api_key, **).delete("/v1/models/#{model}")
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
