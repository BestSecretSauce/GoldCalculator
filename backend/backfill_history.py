import json
import os
from datetime import datetime

import requests
from bs4 import BeautifulSoup

KARAT_TAB_IDS = {
    '24k': 'عيار24',
    '22k': 'عيار22',
    '21k': 'عيار21',
    '18k': 'عيار18',
}
OUNCE_TAB_ID = 'ounce'
OUNCE_KEY = 'الأونصة'
HISTORY_URL = 'https://ae-gold.com/gold-prices-history/'


def fetch_history_page():
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
    response = requests.get(HISTORY_URL, headers=headers, timeout=15)
    response.raise_for_status()
    response.encoding = 'utf-8'
    return response.text


def parse_tab_table(soup, tab_id):
    tab = soup.find('div', id=tab_id)
    if tab is None or tab.find('table') is None:
        return {}
    rows = tab.find('table').find('tbody').find_all('tr')
    prices = {}
    for row in rows:
        cells = row.find_all('td')
        if len(cells) < 2:
            continue
        date_str = cells[0].get_text(strip=True)
        price_str = cells[1].get_text(strip=True).replace(',', '')
        try:
            prices[date_str] = float(price_str)
        except ValueError:
            continue
    return prices


def build_backfill_records():
    soup = BeautifulSoup(fetch_history_page(), 'html.parser')

    karat_prices_by_date = {}
    for tab_id, karat_key in KARAT_TAB_IDS.items():
        for date_str, price in parse_tab_table(soup, tab_id).items():
            karat_prices_by_date.setdefault(date_str, {})[karat_key] = price

    ounce_prices = parse_tab_table(soup, OUNCE_TAB_ID)

    records = []
    for date_str, karat_prices in sorted(karat_prices_by_date.items()):
        karats = {
            key: {'buy': price, 'sell': price}
            for key, price in karat_prices.items()
        }
        record = {
            # The archive only publishes one price per day, not a time of
            # day; noon is an arbitrary but consistent placeholder.
            'timestamp': f'{date_str}T12:00:00',
            'last_updated': date_str,
            'karats': karats,
        }
        if date_str in ounce_prices:
            record['ounce'] = {
                OUNCE_KEY: {
                    'buy': ounce_prices[date_str],
                    'sell': ounce_prices[date_str],
                }
            }
        records.append(record)
    return records


def merge_into_history(records, history_path):
    if os.path.exists(history_path):
        with open(history_path, 'r', encoding='utf-8') as f:
            existing = json.load(f)
    else:
        existing = []

    existing_dates = {
        datetime.fromisoformat(r['timestamp']).date().isoformat()
        for r in existing
        if r.get('timestamp')
    }

    added = 0
    for record in records:
        record_date = record['timestamp'][:10]
        if record_date in existing_dates:
            continue
        existing.append(record)
        added += 1

    existing.sort(key=lambda r: r.get('timestamp', ''))

    with open(history_path, 'w', encoding='utf-8') as f:
        json.dump(existing, f, ensure_ascii=False, indent=2)

    return added


if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))
    history_path = os.path.join(script_dir, 'gold_prices_history.json')
    backfilled = build_backfill_records()
    added_count = merge_into_history(backfilled, history_path)
    print(f'Backfilled {added_count} historical record(s) into {history_path}')
