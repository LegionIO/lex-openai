# frozen_string_literal: true

require 'legion/extensions/openai/helpers/client'

module Legion
  module Extensions
    module Openai
      module Runners
        module Images
          extend Legion::Extensions::Openai::Helpers::Client

          def generate(prompt:, api_key:, model: 'dall-e-3', n: 1, size: '1024x1024',
                       quality: nil, style: nil, response_format: nil, **)
            body = { prompt: prompt, model: model, n: n, size: size }
            body[:quality] = quality if quality
            body[:style] = style if style
            body[:response_format] = response_format if response_format

            response = client(api_key: api_key, **).post('/v1/images/generations', body)
            { result: response.body }
          end

          def edit(image:, prompt:, api_key:, model: 'dall-e-2', mask: nil, n: 1, size: '1024x1024', **)
            payload = {
              image:  Faraday::Multipart::FilePart.new(image, 'image/png'),
              prompt: prompt,
              model:  model,
              n:      n.to_s,
              size:   size
            }
            payload[:mask] = Faraday::Multipart::FilePart.new(mask, 'image/png') if mask

            response = client(api_key: api_key, **).post('/v1/images/edits', payload)
            { result: response.body }
          end

          def variation(image:, api_key:, model: 'dall-e-2', n: 1, size: '1024x1024', **)
            payload = {
              image: Faraday::Multipart::FilePart.new(image, 'image/png'),
              model: model,
              n:     n.to_s,
              size:  size
            }

            response = client(api_key: api_key, **).post('/v1/images/variations', payload)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
