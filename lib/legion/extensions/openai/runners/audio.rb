# frozen_string_literal: true

require 'legion/extensions/openai/helpers/client'

module Legion
  module Extensions
    module Openai
      module Runners
        module Audio
          extend Legion::Extensions::Openai::Helpers::Client

          def speech(input:, api_key:, model: 'tts-1', voice: 'alloy', response_format: 'mp3', speed: nil, **)
            body = { model: model, input: input, voice: voice, response_format: response_format }
            body[:speed] = speed if speed

            response = client(api_key: api_key, **).post('/v1/audio/speech', body)
            { result: response.body }
          end

          def transcribe(file:, api_key:, model: 'whisper-1', language: nil, prompt: nil, response_format: nil, **)
            payload = {
              file:  Faraday::Multipart::FilePart.new(file, 'audio/mpeg'),
              model: model
            }
            payload[:language] = language if language
            payload[:prompt] = prompt if prompt
            payload[:response_format] = response_format if response_format

            response = client(api_key: api_key, **).post('/v1/audio/transcriptions', payload)
            { result: response.body }
          end

          def translate(file:, api_key:, model: 'whisper-1', prompt: nil, response_format: nil, **)
            payload = {
              file:  Faraday::Multipart::FilePart.new(file, 'audio/mpeg'),
              model: model
            }
            payload[:prompt] = prompt if prompt
            payload[:response_format] = response_format if response_format

            response = client(api_key: api_key, **).post('/v1/audio/translations', payload)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
