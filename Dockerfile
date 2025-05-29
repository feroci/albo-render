FROM python:3.11-slim

# Installa Chrome e ChromeDriver
RUN apt-get update && \
    apt-get install -y wget gnupg unzip curl && \
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE") && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Configura PATH e ambiente
ENV PATH="/usr/local/bin:$PATH"

# Crea directory app
WORKDIR /app
COPY . .

# Installa librerie Python
RUN pip install --no-cache-dir -r requirements.txt

# Comando di avvio
CMD ["python", "main.py"]
