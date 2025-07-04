FROM python:3.11-slim as builder

WORKDIR /api

# System deps needed for building some Python packages
RUN apt-get update && apt-get install -y curl build-essential && rm -rf /var/lib/apt/lists/*

# Install Poetry
ENV POETRY_VERSION=1.6.1
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Copy pyproject and poetry.lock first to leverage caching
COPY pyproject.toml poetry.lock ./

# Configure Poetry to create virtualenv inside project
RUN poetry config virtualenvs.in-project true
RUN poetry install --no-interaction --no-ansi --no-root --no-dev

# Now copy the rest of the backend code
COPY . .

RUN eval "$(poetry env activate)"

# Final image
FROM python:3.11-slim
WORKDIR /api
ENV PATH="/api/.venv/bin:$PATH"

# Copy virtualenv and code from builder
COPY --from=builder /api /api

# Install any runtime deps if needed (e.g. libpq-dev, if required)
RUN apt-get update && apt-get install -y --no-install-recommends libpq-dev && rm -rf /var/lib/apt/lists/*

# Use gunicorn with uvicorn workers for production
CMD ["./run"]
