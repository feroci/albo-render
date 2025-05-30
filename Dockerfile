FROM python:3.11-slim

# Installa dipendenze base
RUN apt-get update && apt-get install -y \
    wget curl gnupg2 ca-certificates \
    firefox-esr \
    libgtk-3-0 libdbus-glib-1-2 libxt6 libxss1 libasound2 \
    xauth xvfb unzip && \
    rm -rf /var/lib/apt/lists/*

# Installa GeckoDriver 0.36.0
RUN wget -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.36.0/geckodriver-v0.36.0-linux64.tar.gz && \
    tar -xzf /tmp/geckodriver.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver && \
    rm /tmp/geckodriver.tar.gz

# Imposta variabili d'ambiente per headless
ENV MOZ_HEADLESS=1
ENV DISPLAY=:99

# Installa dipendenze Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia il codice
COPY . /app
WORKDIR /app

CMD ["python", "main.py"]
