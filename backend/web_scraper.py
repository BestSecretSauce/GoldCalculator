from urllib.request import urlopen
import requests
from bs4 import BeautifulSoup
import re
import json
import os
from datetime import datetime
import sys

def scrape_gold_prices():
    sys.stdout.reconfigure(encoding='utf-8') # To handle Arabic characters in the output

    # Get the absolute path of the current script
    script_path = os.path.dirname(os.path.abspath(__file__))

    # Construct full path to the JSON file
    json_file_path = os.path.join(script_path, "gold_prices_history.json")
    print("First time scraping data.....")

    # Step 1: Fetch the web page
    # URL of the website to scrape
    url = 'https://ae-gold.com/'

    # Send a GET request to the website
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        }
    response = requests.get(url, headers=headers)
    response.encoding = 'utf-8'  # To ensure Arabic characters are displayed correctly


    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        print("Request was successful")
    else:
        print(f"Request failed with status code: {response.status_code}")


    # Parse the HTML content using BeautifulSoup
    soup = BeautifulSoup(response.content, 'html.parser')


    # Step 2: Extract the data from the web page

    # Extract the content of the paragraph tag to get latest update
    update_paragraph = soup.find("p", string=lambda text: text and "آخر تحديث" in text)
    last_updated = update_paragraph.get_text(strip=True).replace("آخر تحديث: ", "") if update_paragraph else "unknown"



    # Find the meta description tag that contains the gold prices
    meta_tags = soup.find('meta', attrs={'name': 'description'}) # checked it manually from the web page
    content = meta_tags.get('content', '')



    seen_karats = set()  # To keep track of seen karats (issue of duplicates 24k but one is سبيكة)

    # Step 3: Extract the content of the meta description tag (Karat and prices)
    karats = {}
    ounce = {}

    if meta_tags: # check if the meta tag was found
        print("Meta tags found")
        lines = content.split("عيار")
        for line in lines[1:]: # Skip the first part before the first "عيار"
            line = "عيار" + line  # Add "عيار" back to the beginning of the line

            parts = line.split()
            try:
                karat = parts[0] + parts[1]  # e.g., "عيار 24"
                if karat in seen_karats:
                    continue  # Skip if already seen

                # Add the karat to the seen_karats set
                seen_karats.add(karat)


                selling_price = float(parts[2].replace(',', ''))
                buying_price = float(parts[5].replace(',', ''))
                karats[karat] = {
                "sell": selling_price,
                "buy": buying_price
                }
            except (IndexError, ValueError):
                print(f"Error processing line: {line}")
            continue  # Skip lines that don't follow expected format

        for line in lines[1:]: # Skip the first part before the first "عيار"
            if "الأونصة" in line: # Find ounce price
                ounce_part = line.split("الأونصة")[1].strip()
                ounce_numbers = re.findall(r"\d{1,3}(?:,\d{3})*(?:\.\d+)?", ounce_part) # Special format based on the website
                if len(ounce_numbers) >= 2: 
                    ounce["الأونصة"] = {
                        "sell": float(ounce_numbers[0].replace(",", "")), # First number is selling price for ounces
                        "buy": float(ounce_numbers[1].replace(",", "")) # Second number is buying price for ounces
                    }
        

        # Remaining prices in the array are dismissed as they belong to kg gold price
    else:
        print("Meta tags not found.")






    # Build the full record of the data

    timestamp = datetime.now().isoformat() # Get the current timestamp
    record = {
        "timestamp": timestamp,
        "last_updated": last_updated,
        "karats": karats,
        "ounce": ounce
    }



    # Check if the file exists and load existing data
    if os.path.exists(json_file_path):
        with open(json_file_path, "r", encoding="utf-8") as file:
            try:
                data = json.load(file)
            except json.JSONDecodeError:
                data = []
    else:
        data = []

    # Apeend the new record to the existing data
    data.append(record)


    # Save updated history to the file
    with open(json_file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=2)

    print(f"✅ Saved {len(karats)} karats - last updated: {last_updated}")