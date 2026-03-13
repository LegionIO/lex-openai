# frozen_string_literal: true

require 'legion/extensions/openai/helpers/client'

module Legion
  module Extensions
    module Openai
      module Runners
        module Embeddings
          extend Legion::Extensions::Openai::Helpers::Client

          def create(input:, api_key:, model: 'text-embedding-3-small', encoding_format: nil, dimensions: nil, **)
            body = { input: input, model: model }
            body[:encoding_format] = encoding_format if encoding_format
            body[:dimensions] = dimensions if dimensions

            response = client(api_key: api_key, **).post('/v1/embeddings', body)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
