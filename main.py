from selenium import webdriver
from selenium.webdriver.firefox.options import Options

options = Options()
options.add_argument('--headless')
options.add_argument('--no-sandbox')

driver = webdriver.Firefox(options=options)

# ... il tuo codice ...
