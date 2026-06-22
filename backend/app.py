from flask import Flask, jsonify, request
import subprocess
import os
import json
from flask_cors import CORS
import web_scraper
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes


script_path = os.path.dirname(os.path.abspath(__file__))
json_file_path = os.path.join(script_path, 'gold_prices_history.json')


@app.route('/api/run_scraper', methods=['POST'])
def run_scraper():
    try:
        # Run the web scraper script
        web_scraper.scrape_gold_prices()  # Call the function directly
        return jsonify({'message': 'Scraper executed successfully!'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    



@app.route('/')
def home():
    return "Welcome to the Gold Prices API!"

@app.route('/api/gold_prices', methods=['GET'])
def get_gold_prices():
    # Check if the JSON file exists
    if os.path.exists(json_file_path):
        print("Gold Data", )
        with open(json_file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return jsonify(data)
    else:
        return jsonify({'error': 'Data not found'}), 404

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)
