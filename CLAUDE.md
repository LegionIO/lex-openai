# lex-openai: OpenAI Integration for LegionIO

**Repository Level 3 Documentation**
- **Category**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to OpenAI. Provides runners for chat completions, image generation, audio processing, embeddings, file management, and content moderation.

**GitHub**: https://github.com/LegionIO/lex-openai
**License**: MIT

## Architecture

```
Legion::Extensions::Openai
├── Runners/
│   ├── Chat               # Chat completions (GPT models)
│   ├── Models             # List, retrieve, delete models
│   ├── Images             # Generate, edit, create variations (DALL-E)
│   ├── Audio              # Speech synthesis, transcription, translation (Whisper/TTS)
│   ├── Embeddings         # Vector embeddings
│   ├── Files              # File upload, list, retrieve, delete, download
│   └── Moderations        # Content moderation/classification
└── Helpers/
    └── Client             # OpenAI API client (Faraday-based, Bearer auth)
```

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` | HTTP client |
| `faraday-multipart` | Multipart file uploads (images, audio, files) |
| `multi_json` | JSON parser abstraction |

## Testing

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
