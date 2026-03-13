# lex-openai

OpenAI integration for [LegionIO](https://github.com/LegionIO/LegionIO). Provides runners for chat completions, image generation, audio processing, embeddings, file management, and content moderation via the OpenAI API.

## Installation

```bash
gem install lex-openai
```

## Functions

### Chat
- `create` - Create a chat completion

### Models
- `list` - List available models
- `retrieve` - Get model details
- `delete` - Delete a fine-tuned model

### Images
- `generate` - Generate images from text prompts
- `edit` - Edit images with text prompts and masks
- `variation` - Create variations of an image

### Audio
- `speech` - Generate speech from text (TTS)
- `transcribe` - Transcribe audio to text
- `translate` - Translate audio to English text

### Embeddings
- `create` - Generate vector embeddings

### Files
- `list` - List uploaded files
- `upload` - Upload a file
- `retrieve` - Get file metadata
- `delete` - Delete a file
- `content` - Download file content

### Moderations
- `create` - Classify content for policy compliance

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework
- OpenAI API key

## License

MIT
