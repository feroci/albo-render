FROM python:3.11-slim

# Installazione pacchetti di sistema e Firefox ESR
RUN apt-get update && apt-get install -y \
    firefox-esr \
    wget curl unzip xvfb \
    libgtk-3-0 libdbus-glib-1-2 libxt6 libxss1 libasound2 libxcomposite1 \
    && rm -rf /var/lib/apt/lists/*

# GeckoDriver 0.36.0 (compatibile con Firefox 128 ESR)
RUN wget -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.36.0/geckodriver-v0.36.0-linux64.tar.gz && \
    tar -xzf /tmp/geckodriver.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver && \
    rm /tmp/geckodriver.tar.gz

# Installa dipendenze Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia il codice
COPY . /app
WORKDIR /app

# Comando di avvio con Xvfb
CMD xvfb-run -a python main.py
