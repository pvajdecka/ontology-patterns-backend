````markdown
# Ontology-Patterns Backend 🧩

FastAPI micro-service that **suggests OWL shortcut properties (“Pattern 1”) and subclass names (“Pattern 2”)** by routing prompts to several LLM providers:

* **OpenAI** (`gpt-4o`, `gpt-3.5-turbo`, …)
* **Ollama** (`llama-3.*-instruct`, …)
* **Text-Generation-Inference** (`llama-3.1-8b-instruct(fp16)`)

The whole project is managed with **Poetry** for clean dependency resolution and reproducible installs.

---

## Project layout

```text
backend/
├── __main__.py          # FastAPI application entry-point
└── utils/
    └── tgi.py           # TGI helper
prompts/                 # Prompt templates + JSON output schemas
pyproject.toml           # Poetry configuration
.env.example             # Sample env file
README.md
LICENSE
```


---

## Quick start (Poetry)

```bash
# 1. Clone & enter
git clone https://github.com/<you>/ontology-patterns-backend.git
cd ontology-patterns-backend

# 2. Install Poetry (if missing)
curl -sSL https://install.python-poetry.org | python3 -

# 3. Install dependencies (incl. optional dev tools)
poetry install --with dev

# 4. Activate the virtual environment
poetry shell            # or prefix commands with `poetry run`

# 5. Configure environment variables
cp .env.example .env    # then edit OPENAI_API_KEY, ALLOWED_ORIGINS, …

# 6. Run the API (auto-reload in dev)
uvicorn backend.__main__:app --reload --host 0.0.0.0 --port 8000
```

> Swagger / Redoc are served at **[http://localhost:8000/api/docs](http://localhost:8000/api/docs)**

---

## Environment variables

| Name              | Description                       | Example                 |
| ----------------- | --------------------------------- | ----------------------- |
| `HOST`            | Bind address                      | `0.0.0.0`               |
| `PORT`            | Exposed port                      | `8000`                  |
| `ALLOWED_ORIGINS` | CORS CSV whitelist                | `http://localhost:3000` |
| `OPENAI_API_KEY`  | Your OpenAI key (keep it secret!) | `sk-…`                  |

Copy **`.env.example`** → `.env`, then fill in your values.

---

## API reference

| Method | Path                           | Description                                          |
| ------ | ------------------------------ | ---------------------------------------------------- |
| POST   | `/api/generate_shortcut`       | Suggest a **property name** (Pattern 1)              |
| POST   | `/api/generate_subclass`       | Suggest a **class name** (Pattern 2)                 |
| POST   | `/api/shortcut_prompt`         | Return the raw prompt to be sent (Pattern 1)         |
| POST   | `/api/subclass_prompt`         | Same for Pattern 2                                   |
| GET    | `/api/model_provider_map`      | JSON map `model_name → provider`                     |
| POST   | `/api/_temp_localstorage_data` | Store temporary JSON payload (helper for front-ends) |
| GET    | `/api/_temp_localstorage_data` | Retrieve stored payload by `uuid`                    |

Detailed request/response schemas appear in Swagger.

---

## Development workflow

| Task                            | Command                                            |
| ------------------------------- | -------------------------------------------------- |
| Start dev server (reload)       | `poetry run uvicorn backend.__main__:app --reload` |
| Run tests                       | `poetry run pytest -q`                             |
| Format code (`black` + `isort`) | `poetry run black . && poetry run isort .`         |
| Lint (`flake8`)                 | `poetry run flake8`                                |
| Pre-commit hooks (optional)     | `poetry run pre-commit install`                    |

All tooling (black, isort, flake8, pytest, pre-commit) is declared under the `dev` dependency group in **pyproject.toml**.

---

## Model routing

`backend/__main__.py` contains `model_provider_map`, which lists model names and the provider each one uses.
Edit this map to expose or hide specific LLMs.

---

## Docker (optional)

```bash
docker build -t ontology-patterns-backend .
docker run --env-file .env -p 8000:8000 ontology-patterns-backend
```

The container runs the same Poetry environment internally.

---

## Contributing

1. Fork the repo & create a feature branch.
2. Run `poetry install --with dev`.
3. Use `poetry run black . && poetry run isort .` before committing.
4. Open a PR—thanks! 🚀

---

## License

MIT – see **LICENSE** for details.
