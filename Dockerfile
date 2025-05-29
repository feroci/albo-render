FROM python:3.11-slim

# Installa dipendenze
RUN apt-get update && apt-get install -y \
    wget curl unzip gnupg \
    fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 libdbus-1-3 \
    libgdk-pixbuf2.0-0 libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxrandr2 xdg-utils

# Installa Google Chrome
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable

# Debug: stampa versione di Chrome
RUN google-chrome-stable --version

# Installa il ChromeDriver corrispondente alla versione installata di Chrome
RUN bash -c '\
  CHROME_VERSION=$(google-chrome-stable --version | cut -d " " -f 3 | cut -d "." -f 1) && \
  echo "Chrome major version: $CHROME_VERSION" && \
  DRIVER_VERSION=$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) && \
  echo "ChromeDriver version to install: $DRIVER_VERSION" && \
  wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip -d /usr/local/bin && \
  chmod +x /usr/local/bin/chromedriver && \
  rm /tmp/chromedriver.zip \
'

ENV PATH="/usr/local/bin:$PATH"

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "main.py"]
