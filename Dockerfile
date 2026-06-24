# ---------- Etapa 1: build ----------
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# ---------- Etapa 2: runtime ----------
FROM python:3.12-slim

# Usuario no root
RUN useradd --create-home --shell /bin/bash appuser

WORKDIR /app

# Copiamos los paquetes instalados desde la etapa builder
COPY --from=builder /root/.local /home/appuser/.local
COPY ./app ./app

RUN chown -R appuser:appuser /app
USER appuser

ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

EXPOSE 8004

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8004"]