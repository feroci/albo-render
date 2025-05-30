FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Installa le dipendenze fondamentali + Firefox + GeckoDriver + Xvfb
RUN apt-get update && apt-get install -y \
    wget curl gnupg unzip xvfb firefox-esr \
    libgtk-3-0 libdbus-glib-1-2 libxt6 libxrender1 libxcomposite1 libasound2 \
    libxdamage1 libxrandr2 libnss3 libxss1 libx11-xcb1 \
    && rm -rf /var/lib/apt/lists/*

# Installa GeckoDriver 0.36.0 (compatibile con Firefox 128+)
RUN wget -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.36.0/geckodriver-v0.36.0-linux64.tar.gz && \
    tar -xzf /tmp/geckodriver.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver && \
    rm /tmp/geckodriver.tar.gz



WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

CMD ["xvfb-run", "--auto-servernum", "--server-args='-screen 0 1024x768x24'", "python", "main.py"]
