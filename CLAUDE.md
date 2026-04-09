# lex-openai: OpenAI Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-ai/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to OpenAI. Provides runners for chat completions, image generation, audio processing, embeddings, file management, and content moderation.

**GitHub**: https://github.com/LegionIO/lex-openai
**License**: MIT
**Version**: 0.1.5
**Specs**: 66 examples (8 spec files)

## Architecture

```
Legion::Extensions::Openai
├── Runners/
│   ├── Chat               # create(model:, messages:, api_key:, ...)
│   ├── Models             # list(api_key:, ...), retrieve(model:, api_key:, ...), delete(model:, api_key:, ...)
│   ├── Images             # generate(prompt:, api_key:, model: 'dall-e-3', ...), edit(...), variation(...)
│   ├── Audio              # speech(input:, api_key:, model: 'tts-1', voice: 'alloy', ...), transcribe(...), translate(...)
│   ├── Embeddings         # create(input:, model: 'text-embedding-3-small', api_key:, ...)
│   ├── Files              # list, upload, retrieve, delete, content (download)
│   └── Moderations        # create(input:, api_key:, ...)
└── Helpers/
    └── Client             # OpenAI API client (module, Faraday factory, Bearer auth)
```

There is no standalone `Client` class in lex-openai. Runner modules are used directly via `extend` or by including them in a consuming class. This differs from lex-azure-ai, lex-bedrock, lex-claude, lex-foundry, and lex-xai which all ship a `Client` class.

`Helpers::Client` is a **module** (not a class). Runner modules `extend` it so `client(...)` is available as a module-level method. `DEFAULT_BASE_URL = 'https://api.openai.com'`.

## Key Design Decisions

- `faraday/multipart` is required unconditionally in `Helpers::Client` — the `:multipart` middleware is always loaded. This is a hard dependency (listed in gemspec), unlike lex-gemini where it is optional.
- `Images#edit` and `Images#variation` use `Faraday::Multipart::FilePart` directly.
- `Images#generate` uses DALL-E 3 by default; `Images#edit` and `Images#variation` use DALL-E 2 by default.
- Audio defaults: `model: 'tts-1'`, `voice: 'alloy'`, `response_format: 'mp3'` for speech; `model: 'whisper-1'` for transcription/translation.
- All runners return `{ result: response.body }` (no `:status` key).
- `multi_json` is NOT a declared dependency of lex-openai (unlike lex-azure-ai, lex-claude, lex-foundry, lex-xai). JSON parsing uses Faraday's built-in response middleware.
- `include Legion::Extensions::Helpers::Lex` is guarded with `Legion::Extensions.const_defined?(:Helpers)` pattern.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` >= 2.0 | HTTP client |
| `faraday-multipart` >= 1.0 | Multipart file uploads (images, audio, files) |
| `legion-cache`, `legion-crypt`, `legion-data`, `legion-json`, `legion-logging`, `legion-settings`, `legion-transport` | LegionIO core |

Note: `multi_json` is NOT a declared dependency (differs from all other extensions in this category).

## Testing

```bash
bundle install
bundle exec rspec        # 66 examples
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
**Last Updated**: 2026-04-06
