#!/usr/bin/env python

import sys
import requests
import webbrowser
from urllib.parse import urlencode, parse_qs

def usage():
    print(f"""
Usage:
  $ python {sys.argv[0]} <consumer_key>
""")

# Get consumer_key from command-line arguments
if len(sys.argv) < 2:
    usage()
    sys.exit(1)

consumer_key = sys.argv[1]

# Step 1: Obtain a request token
request_token_url = 'https://getpocket.com/v3/oauth/request'
redirect_uri = 'http://example.com/'

params = {
    'consumer_key': consumer_key,
    'redirect_uri': redirect_uri,
}

response = requests.post(request_token_url, data=params)
if response.status_code != 200:
    print(response.text)
    sys.exit(1)

query = parse_qs(response.text)
code = query.get('code', [None])[0]

if not code:
    print("Failed to retrieve request token")
    sys.exit(1)

# Step 2: Redirect the user for authentication
auth_url = f"https://getpocket.com/auth/authorize?request_token={code}&redirect_uri={redirect_uri}"
webbrowser.open(auth_url)

input("Press Enter after you have authenticated: ")

# Step 3: Convert request token to access token
access_token_url = 'https://getpocket.com/v3/oauth/authorize'
params = {
    'consumer_key': consumer_key,
    'code': code,
}

response = requests.post(access_token_url, data=params)
if response.status_code != 200:
    print(response.text)
    sys.exit(1)

auth_result = parse_qs(response.text)
print({key: value[0] for key, value in auth_result.items()})
