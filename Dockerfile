# Base image con Python
FROM python:3.11-slim

# Evita domande durante apt install
ENV DEBIAN_FRONTEND=noninteractive

# Installa dipendenze e Firefox + GeckoDriver
RUN apt-get update && apt-get install -y \
    wget curl gnupg unzip \
    firefox-esr \
    libgtk-3-0 libdbus-glib-1-2 libxt6 libxrender1 libxcomposite1 libasound2 libxdamage1 libxrandr2 libnss3 libxss1 libx11-xcb1 \
    && rm -rf /var/lib/apt/lists/*

# Installa GeckoDriver (versione compatibile)
RUN GECKODRIVER_VERSION=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest | grep '"tag_name":' | cut -d'"' -f4) && \
    wget -O /tmp/geckodriver.tar.gz "https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VERSION}/geckodriver-${GECKODRIVER_VERSION}-linux64.tar.gz" && \
    tar -xzf /tmp/geckodriver.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver && \
    rm /tmp/geckodriver.tar.gz

# Copia i file del progetto
WORKDIR /app
COPY . /app

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Comando di avvio
CMD ["python", "main.py"]
