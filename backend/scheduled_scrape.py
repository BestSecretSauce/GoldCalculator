import logging
import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
os.chdir(SCRIPT_DIR)
sys.path.insert(0, SCRIPT_DIR)

from web_scraper import scrape_gold_prices

logging.basicConfig(
    filename=os.path.join(SCRIPT_DIR, 'scrape_log.txt'),
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(message)s',
)

if __name__ == '__main__':
    try:
        scrape_gold_prices()
        logging.info('Scheduled scrape completed successfully.')
    except Exception:
        logging.exception('Scheduled scrape failed.')
        raise
