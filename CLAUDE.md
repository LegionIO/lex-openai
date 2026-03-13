# lex-openai: OpenAI Integration for LegionIO

**Repository Level 3 Documentation**
- **Category**: `/Users/miverso2/rubymine/legion/extensions-ai/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to OpenAI. Provides runners for chat completions, image generation, audio processing, embeddings, file management, and content moderation.

**GitHub**: https://github.com/LegionIO/lex-openai
**License**: MIT

## Architecture

```
Legion::Extensions::Openai
├── Runners/
│   ├── Chat               # Chat completions (create)
│   ├── Models             # List, retrieve, delete models
│   ├── Images             # Generate (DALL-E 3), edit, variation (DALL-E 2)
│   ├── Audio              # Speech/TTS (speech), transcription (transcribe), translation (translate)
│   ├── Embeddings         # Vector embeddings (create)
│   ├── Files              # list, upload, retrieve, delete, content (download)
│   └── Moderations        # Content classification (create)
└── Helpers/
    └── Client             # OpenAI API client (module, Faraday factory, Bearer auth)
```

`Helpers::Client` is a **module** with a `client(api_key:, ...)` factory method. All runner modules `extend` it, making `client(...)` available as a module-level method. Multipart middleware (`:multipart`) is always loaded, enabling `Faraday::Multipart::FilePart` usage in Images, Audio, and Files runners.

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
