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
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
