import json
import argparse
import base64
import os

SECRETS_FILEPATH = '/Users/edwin.leroux/OneDrive - Standard Bank/phnee'

def write_secrets_file(encryption_key, secrets):
    secrets_bytes = json.dumps(secrets).encode('utf-8')
    encrypted_secrets = base64.b64encode(secrets_bytes)
    encrypted_secrets = bytes([c ^ int(encryption_key) for c in encrypted_secrets])
    with open(SECRETS_FILEPATH, 'wb') as f:
        f.write(encrypted_secrets)

def read_secrets_file(encryption_key):
    if os.path.isfile(SECRETS_FILEPATH):
        with open(SECRETS_FILEPATH, 'rb') as f:
            secrets_raw = f.read()
        decrypted_secrets = bytes([c ^ int(encryption_key) for c in secrets_raw])
        secrets_bytes = base64.b64decode(decrypted_secrets)
        return json.loads(secrets_bytes.decode('utf-8'))
    else:
        return {} # Returns empty json object if file doesn't exist.

def list_secret(encryption_key):
    secrets = read_secrets_file(encryption_key)
    for key in sorted(secrets.keys(), key=lambda x: str(x)):
        print(key)

def get_secret(encryption_key, key):
    secrets = read_secrets_file(encryption_key)
    if secrets.get(key) is None:
        print_suggested_keys(secrets, key)
    else:
        print(secrets[key])

def add_secret(encryption_key, key, value):
    secrets = read_secrets_file(encryption_key)
    if secrets.get(key):
        print_suggested_keys(secrets, key)
    else:
        secrets[key] = value
        write_secrets_file(encryption_key, secrets)
        print("Secret added.")

def update_secret(encryption_key, key, value):
    secrets = read_secrets_file(encryption_key)
    if secrets.get(key) is None:
        print_suggested_keys(secrets, key)
    else:
        secrets[key] = value
        write_secrets_file(encryption_key, secrets)
        print("Secret updated.")

def delete_secret(encryption_key, key):
    secrets = read_secrets_file(encryption_key)
    if secrets.get(key) is None:
        print_suggested_keys(secrets, key)
    else:
        secrets.pop(key)
        write_secrets_file(encryption_key, secrets)
        print("Secret deleted.")

def rename_secret_key(encryption_key, old_key, new_key):
    secrets = read_secrets_file(encryption_key)
    if secrets.get(old_key) is None:
        print_suggested_keys(secrets, old_key)
    else:
        secrets[new_key] = secrets.pop(old_key)
        write_secrets_file(encryption_key, secrets)
        print("Secret key updated.")

def print_suggested_keys(secrets, key):
    suggested_keys = [x for x in secrets.keys() if key in x]
    if len(suggested_keys) == 0:
        print("No key suggestions!")
    else:    
        print('Suggested Keys:')
        print('\n'.join(suggested_keys))

def run():
    """Run"""

    parser = argparse.ArgumentParser()

    parser.add_argument('-l', nargs=1, help='List of secret keys')
    parser.add_argument('-g', nargs=2, help='Get my secret')
    parser.add_argument('-a', nargs=3, help='Add secrets')
    parser.add_argument('-u', nargs=3, help='Update my secret value')
    parser.add_argument('-d', nargs=2, help='Delete my secret')
    parser.add_argument('-r', nargs=3, help='Rename my secret key')

    args = parser.parse_args()

    if args.l:
        list_secret(args.l[0])
    elif args.g:
        get_secret(args.g[0], args.g[1])
    elif args.a:
        add_secret(args.a[0], args.a[1], args.a[2])
    elif args.u:
        update_secret(args.u[0], args.u[1], args.u[2])
    elif args.d:
        delete_secret(args.d[0], args.d[1])
    elif args.r:
        rename_secret_key(args.r[0], args.r[1], args.r[2])

if __name__ == "__main__":
    run()