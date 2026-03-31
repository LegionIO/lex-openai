# frozen_string_literal: true

require 'legion/extensions/openai/helpers/client'

module Legion
  module Extensions
    module Openai
      module Runners
        module Moderations
          extend Legion::Extensions::Openai::Helpers::Client

          def create(input:, api_key:, model: nil, **)
            body = { input: input }
            body[:model] = model if model

            response = client(api_key: api_key, **).post('/v1/moderations', body)
            resp_body = response.body
            {
              result: resp_body,
              usage:  {
                input_tokens:       resp_body.dig('usage', 'prompt_tokens') || 0,
                output_tokens:      resp_body.dig('usage', 'completion_tokens') || 0,
                cache_read_tokens:  resp_body.dig('usage', 'prompt_tokens_details', 'cached_tokens') || 0,
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
