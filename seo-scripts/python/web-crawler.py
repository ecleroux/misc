# pip install bs4
import requests
from bs4 import BeautifulSoup

urls = ['https://www.abc.com/asd', 'https://www.abc.com/efd']

for url in urls:
    response = requests.get(url)
    soup = BeautifulSoup(response.content, "html.parser")

    canonical = soup.find("link", {"rel": "canonical"})

    if canonical:
        print(canonical.get("href"))
    else:
        print("Missing")
