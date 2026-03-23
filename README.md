# lex-openai

OpenAI integration for LegionIO. Provides runners for chat completions, image generation, audio processing, embeddings, file management, and content moderation via the OpenAI API.

## Purpose

Wraps the OpenAI REST API as named runners consumable by any LegionIO task chain. Includes resource-specific operations (image generation/editing, audio transcription/synthesis, file management, moderation) not available through the `legion-llm` unified interface. Use this extension when you need direct access to the full OpenAI API surface within the LEX runner/actor lifecycle.

## Installation

```bash
gem install lex-openai
```

Or add to your Gemfile:

```ruby
gem 'lex-openai'
```

## Functions

### Chat
- `create` - Create a chat completion

### Models
- `list` - List available models
- `retrieve` - Get model details
- `delete` - Delete a fine-tuned model

### Images
- `generate` - Generate images from text prompts (DALL-E 3 default)
- `edit` - Edit images with text prompts and masks (DALL-E 2)
- `variation` - Create variations of an image (DALL-E 2)

### Audio
- `speech` - Generate speech from text (TTS, default model: tts-1)
- `transcribe` - Transcribe audio to text (Whisper)
- `translate` - Translate audio to English text (Whisper)

### Embeddings
- `create` - Generate vector embeddings (default model: text-embedding-3-small)

### Files
- `list` - List uploaded files
- `upload` - Upload a file
- `retrieve` - Get file metadata
- `delete` - Delete a file
- `content` - Download file content

### Moderations
- `create` - Classify content for policy compliance

## Configuration

Set your API key in your LegionIO settings:

```json
{
  "openai": {
    "api_key": "sk-..."
  }
}
```

## Standalone Usage

Runner modules can be extended directly onto any module or object. Each runner method requires `api_key:` as a keyword argument.

```ruby
require 'legion/extensions/openai/runners/chat'
require 'legion/extensions/openai/runners/images'

# Chat completion
module ChatClient
  extend Legion::Extensions::Openai::Runners::Chat
end

result = ChatClient.create(
  model: 'gpt-4o',
  messages: [{ role: 'user', content: 'Hello!' }],
  api_key: ENV['OPENAI_API_KEY']
)
puts result[:result]['choices'].first['message']['content']

# Image generation
module ImageClient
  extend Legion::Extensions::Openai::Runners::Images
end

image = ImageClient.generate(
  prompt: 'A futuristic city at sunset',
  model: 'dall-e-3',
  api_key: ENV['OPENAI_API_KEY']
)
puts image[:result]['data'].first['url']
```

## Dependencies

- `faraday` >= 2.0 - HTTP client
- `faraday-multipart` >= 1.0 - Multipart file uploads (images, audio, files)
- `multi_json` - JSON parser abstraction

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework (optional for standalone runner usage)
- OpenAI API key

## Related

- `lex-xai` — xAI Grok API (same structural pattern as lex-openai)
- `legion-llm` — High-level LLM interface including OpenAI via ruby_llm
- `extensions-ai/CLAUDE.md` — Architecture patterns shared across all AI extensions

## License

MIT
