from selenium import webdriver
from selenium.webdriver.firefox.options import Options

options = Options()
options.add_argument("--headless")  # anche se c'è Xvfb, meglio tenerlo

driver = webdriver.Firefox(options=options)
driver.get("https://example.com")
print(driver.title)
driver.quit()
