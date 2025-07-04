# Ontology-Patterns Backend 🧩

FastAPI micro-service that **suggests OWL shortcut properties (Pattern 1) and subclass names (Pattern 2)** by routing prompts to several Large Language Model providers (OpenAI, Ollama, and Text-Generation-Inference).

---

## Project layout

```text
backend/
├── __main__.py          # FastAPI application
└── utils/
    └── tgi.py           # helper for Text-Generation-Inference
prompts/                 # prompt templates + JSON output schemas
```

---

## Quick start

```bash
# clone & enter
git clone <repo-url>
cd <repo-dir>

# Python env
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# configure secrets / settings
cp .env.example .env        # then edit OPENAI_API_KEY, ALLOWED_ORIGINS, …

# run the API
uvicorn backend.__main__:app --reload --host 0.0.0.0 --port 8000
```

Swagger UI: **[http://localhost:8000/api/docs](http://localhost:8000/api/docs)**

---

## Environment variables

| Variable          | Purpose            | Example                 |
| ----------------- | ------------------ | ----------------------- |
| `HOST`            | Bind address       | `0.0.0.0`               |
| `PORT`            | Exposed port       | `8000`                  |
| `ALLOWED_ORIGINS` | CORS CSV whitelist | `http://localhost:3000` |
| `OPENAI_API_KEY`  | Your OpenAI key    | `sk-…`                  |

Create a `.env` file from `.env.example` and fill in your values.

---

## API reference

| Method | Path                           | Description                                           |
| ------ | ------------------------------ | ----------------------------------------------------- |
| POST   | `/api/generate_shortcut`       | Suggest a **property name** (Pattern 1)               |
| POST   | `/api/generate_subclass`       | Suggest a **class name** (Pattern 2)                  |
| POST   | `/api/shortcut_prompt`         | Return the exact prompt that will be sent (Pattern 1) |
| POST   | `/api/subclass_prompt`         | Same for Pattern 2                                    |
| GET    | `/api/model_provider_map`      | JSON map of `model_name → provider`                   |
| POST   | `/api/_temp_localstorage_data` | Store temporary JSON payload                          |
| GET    | `/api/_temp_localstorage_data` | Retrieve stored payload (`uuid` query param)          |

---

## Model routing

`backend/__main__.py` contains `model_provider_map`, which lists available model names and the provider each one uses.
Edit this map to customise which LLMs are exposed.

---

## License

MIT – see `LICENSE`.
