# Ontology-Patterns Backend 🧩

FastAPI micro-service that **suggests OWL shortcut properties (“Pattern 1”) and subclass names (“Pattern 2”)** by routing prompts to several LLM providers:

* **OpenAI**  (`gpt-4o`, `gpt-3.5-turbo`, …)
* **Ollama**  (`llama-3.*-instruct`, …)
* **Text-Generation-Inference**  (`llama-3.1-8b-instruct(fp16)`)

The entire project is managed with **Poetry** for clean dependency resolution and reproducible installs.

---

## Project layout

```
backend/
├── __main__.py          # FastAPI application entry-point
└── utils/
    └── tgi.py           # TGI helper
prompts/                 # Prompt templates + JSON output schemas
pyproject.toml           # Poetry configuration
.env.example             # Sample environment file
README.md
LICENSE
```

---

## Quick start (Poetry)

```bash
# 1  Clone & enter
git clone https://github.com/<you>/ontology-patterns-backend.git
cd ontology-patterns-backend

# 2  Install Poetry (if missing)
curl -sSL https://install.python-poetry.org | python3 -

# 3  Install dependencies (+dev extras)
poetry install --with dev

# 4  Activate the virtual environment
poetry shell                     # or prefix each command with `poetry run`

# 5  Configure environment variables
cp .env.example .env             # edit OPENAI_API_KEY, ALLOWED_ORIGINS, …

# 6  Run the API (live-reload)
uvicorn backend.__main__:app --reload --host 0.0.0.0 --port 8000
```

Swagger / Redoc: **[http://localhost:8000/api/docs](http://localhost:8000/api/docs)**

---

## Environment variables

| Variable          | Purpose           | Example                 |
| ----------------- | ----------------- | ----------------------- |
| `HOST`            | Bind address      | `0.0.0.0`               |
| `PORT`            | Exposed port      | `8000`                  |
| `ALLOWED_ORIGINS` | CSV list for CORS | `http://localhost:3000` |
| `OPENAI_API_KEY`  | Your OpenAI key   | `sk-…`                  |

Copy `.env.example` → `.env`, then fill in your own values.

---

## API reference

| Method | Path                           | Description                                          |
| ------ | ------------------------------ | ---------------------------------------------------- |
| POST   | `/api/generate_shortcut`       | Suggest a **property name** (Pattern 1)              |
| POST   | `/api/generate_subclass`       | Suggest a **class name** (Pattern 2)                 |
| POST   | `/api/shortcut_prompt`         | Return the raw prompt for Pattern 1                  |
| POST   | `/api/subclass_prompt`         | Return the raw prompt for Pattern 2                  |
| GET    | `/api/model_provider_map`      | JSON map `model_name → provider`                     |
| POST   | `/api/_temp_localstorage_data` | Store temporary JSON payload (helper for front-ends) |
| GET    | `/api/_temp_localstorage_data` | Retrieve stored payload (`uuid` query parameter)     |

Detailed request/response schemas are available in Swagger.

---

## Development workflow

| Task                        | Command                                            |
| --------------------------- | -------------------------------------------------- |
| Start dev server (reload)   | `poetry run uvicorn backend.__main__:app --reload` |
| Run tests                   | `poetry run pytest -q`                             |
| Format code (black + isort) | `poetry run black . && poetry run isort .`         |
| Lint (flake8)               | `poetry run flake8`                                |
| Install pre-commit hooks    | `poetry run pre-commit install`                    |

All dev tools live in the **`dev`** dependency group inside `pyproject.toml`.

---

## Model routing

`backend/__main__.py` defines `model_provider_map`, listing each LLM and the provider it should call.
Edit this mapping to expose or hide particular models.

---

## Docker (optional)

```bash
docker build -t ontology-patterns-backend .
docker run --env-file .env -p 8000:8000 ontology-patterns-backend
```

The container uses the same Poetry environment internally.

---

## Contributing

1. Fork the repo & create a feature branch.
2. Run `poetry install --with dev`.
3. Format & lint:
   `poetry run black . && poetry run isort . && poetry run flake8`
4. Open a PR — thank you! 🚀

---

## License

MIT — see **LICENSE**.
