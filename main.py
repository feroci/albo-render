import os
import time
import requests
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Configura Chrome in modalità headless
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--window-size=1920,1080")

driver = webdriver.Chrome(options=chrome_options)
wait = WebDriverWait(driver, 15)

# URL della pagina dell'Albo Pretorio
URL = "https://servizionline.hspromilaprod.hypersicapp.net/cmsscandriglia/portale/albopretorio/albopretorioconsultazione.aspx?P=8600"

print("🌐 Apro la pagina dell'Albo Pretorio...")
driver.get(URL)

try:
    print("🔍 Cerco il pulsante 'Ricerca'...")
    ricerca_btn = wait.until(EC.element_to_be_clickable((By.ID, "ctl00_cphBody_btnRicerca")))
    ricerca_btn.click()
    print("✅ Cliccato su Ricerca.")
except Exception as e:
    print(f"❌ Errore nel clic su Ricerca: {e}")
    driver.quit()
    exit()

# Aspetta la tabella dei risultati
try:
    table = wait.until(EC.presence_of_element_located((By.ID, "ctl00_cphBody_gridRisultati")))
    print("📋 Tabella trovata.")
except Exception:
    print("❌ Tabella non trovata.")
    driver.quit()
    exit()

# Crea cartella per PDF
os.makedirs("pdf_scaricati", exist_ok=True)

# Trova tutti i link nella tabella
rows = table.find_elements(By.TAG_NAME, "tr")[1:]  # salta l'intestazione
for i, row in enumerate(rows):
    try:
        link = row.find_element(By.TAG_NAME, "a")
        pdf_url = link.get_attribute("href")
        nome_file = f"pdf_scaricati/documento_{i+1}.pdf"

        print(f"⬇️ Scarico: {pdf_url}")
        response = requests.get(pdf_url)
        with open(nome_file, "wb") as f:
            f.write(response.content)
        print(f"✅ Salvato come: {nome_file}")
    except Exception as e:
        print(f"⚠️ Errore nel processare la riga {i+1}: {e}")

driver.quit()
print("🏁 Fine. Tutti i PDF disponibili sono stati scaricati.")
