# lex-openai: OpenAI Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-ai/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to OpenAI. Provides runners for chat completions, image generation, audio processing, embeddings, file management, and content moderation.

**GitHub**: https://github.com/LegionIO/lex-openai
**License**: MIT
**Version**: 0.1.1
**Specs**: 17 examples

## Architecture

```
Legion::Extensions::Openai
├── Runners/
│   ├── Chat               # create(model:, messages:, api_key:, ...)
│   ├── Models             # list(api_key:, ...), retrieve(api_key:, model_id:, ...), delete(api_key:, model_id:, ...)
│   ├── Images             # generate(prompt:, api_key:, model: 'dall-e-3', ...), edit(...), variation(...)
│   ├── Audio              # speech(input:, api_key:, model: 'tts-1', voice: 'alloy', ...), transcribe(...), translate(...)
│   ├── Embeddings         # create(input:, model: 'text-embedding-3-small', api_key:, ...)
│   ├── Files              # list, upload, retrieve, delete, content (download)
│   └── Moderations        # create(input:, api_key:, ...)
└── Helpers/
    └── Client             # OpenAI API client (module, Faraday factory, Bearer auth)
```

`Helpers::Client` is a **module** (not a class). It does not use `module_function` — instead, runner modules `extend` it so `client(...)` is available as a module-level method. `DEFAULT_BASE_URL` is `'https://api.openai.com'`.

## Key Design Decisions

- `faraday/multipart` is required unconditionally in `Helpers::Client` — the `:multipart` middleware is always loaded. This is a hard dependency (listed in gemspec), unlike lex-gemini where it is optional.
- Images (edit, variation) and Audio (transcribe, translate) runners use `Faraday::Multipart::FilePart` directly.
- `Images#generate` uses DALL-E 3 by default; `Images#edit` and `Images#variation` use DALL-E 2 by default.
- Audio defaults: `model: 'tts-1'`, `voice: 'alloy'`, `response_format: 'mp3'` for speech; `model: 'whisper-1'` for transcription/translation.
- Chat runner returns `{ result: response.body }` (no `:status` key) — differs slightly from claude/gemini runner return shapes.
- `include Legion::Extensions::Helpers::Lex` is guarded with `Legion::Extensions.const_defined?(:Helpers)` pattern.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` >= 2.0 | HTTP client |
| `faraday-multipart` >= 1.0 | Multipart file uploads (images, audio, files) |
| `multi_json` | JSON parser abstraction |

## Testing

```bash
bundle install
bundle exec rspec        # 17 examples
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
