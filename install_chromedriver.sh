#!/bin/bash
set -e

echo "📦 Chrome installato:"
google-chrome-stable --version

CHROME_VERSION=$(google-chrome-stable --version | cut -d " " -f 3 | cut -d "." -f 1)
echo "🔢 Chrome major version: $CHROME_VERSION"

echo "🌍 Verifico versione driver per Chrome major $CHROME_VERSION"
curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION || echo "❌ Nessuna versione trovata"


wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip
unzip /tmp/chromedriver.zip -d /usr/local/bin
chmod +x /usr/local/bin/chromedriver
rm /tmp/chromedriver.zip

echo "✅ ChromeDriver installato!"
