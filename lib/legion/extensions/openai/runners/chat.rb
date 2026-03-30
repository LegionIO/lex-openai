# frozen_string_literal: true

require 'legion/extensions/openai/helpers/client'

module Legion
  module Extensions
    module Openai
      module Runners
        module Chat
          extend Legion::Extensions::Openai::Helpers::Client

          def create(model:, messages:, api_key:, temperature: nil, max_tokens: nil, top_p: nil,
                     frequency_penalty: nil, presence_penalty: nil, stop: nil, stream: false, **)
            body = { model: model, messages: messages, stream: stream }
            body[:temperature] = temperature if temperature
            body[:max_tokens] = max_tokens if max_tokens
            body[:top_p] = top_p if top_p
            body[:frequency_penalty] = frequency_penalty if frequency_penalty
            body[:presence_penalty] = presence_penalty if presence_penalty
            body[:stop] = stop if stop

            response = client(api_key: api_key, **).post('/v1/chat/completions', body)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
