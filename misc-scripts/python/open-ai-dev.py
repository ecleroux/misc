import requests

question = '''Question....
'''

# Azure API Management Endpoint
url = "https://aoamanagement.azure-api.net/deployments/gpt-35-turbo/chat/completions?api-version=2023-08-01-preview"

# Subscription key from API Management
subscription_key = "xxxx"

headers = {
    'Ocp-Apim-Subscription-Key': subscription_key,
    'Content-Type': 'application/json'
}

data = {
    "model": "gpt-35-turbo",
    "messages": [
        {
            "role": "user",
            "content": question
        }
    ],
}

response = requests.post(url, headers=headers, json=data)
print(response.json()['choices'][0]['message']['content'])
