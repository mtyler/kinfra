#!/opt/homebrew/bin/python3
import os
import subprocess

##export AWS_HOST=$(kubectl -n default get cm ceph-bucket -o jsonpath='{.data.BUCKET_HOST}')
##export PORT=$(kubectl -n default get cm ceph-bucket -o jsonpath='{.data.BUCKET_PORT}')
##export BUCKET_NAME=$(kubectl -n default get cm ceph-bucket -o jsonpath='{.data.BUCKET_NAME}')
##export AWS_ACCESS_KEY_ID=$(kubectl -n default get secret ceph-bucket -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 --decode)
##export AWS_SECRET_ACCESS_KEY=$(kubectl -n default get secret ceph-bucket -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 --decode)


## get on the toolbox
## kubectl -n rook-ceph exec -it deployments/rook-ceph-tools-operator-image -- bash

USER_HOME_DIR = os.path.expanduser("~")
CWD = f"{os.path.dirname(os.path.abspath(__file__))}/"

def create_credential_file(key_id, secret_key, host, port, bucket_name):
    with open(f'{CWD}/../envs/s5cmd-credentials', 'w') as f:
        f.write(f'export AWS_ACCESS_KEY_ID={key_id}\n')
        f.write(f'export AWS_SECRET_ACCESS_KEY={secret_key}\n')
        f.write(f'export AWS_HOST={host}\n')
        f.write(f'export PORT={port}\n')
        f.write(f'export BUCKET_NAME={bucket_name}\n')

def get_aws_access_key_id():
    cmd = "kubectl -n rook-ceph get secret ceph-bucket -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 --decode"
    result = run_command(cmd)
    return result

def get_aws_secret_access_key():
    cmd = "kubectl -n rook-ceph get secret ceph-bucket -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 --decode"
    result = run_command(cmd)
    return result

def get_bucket_name():
    cmd = ['kubectl', '-n', 'rook-ceph', 'get', 'cm', 'ceph-bucket', '-o', "jsonpath='{.data.BUCKET_NAME}'"]
    result = run_command(cmd)
    print(f'bucket name: {result}')
    return result

def get_bucket_host():
    cmd = ['kubectl', '-n', 'rook-ceph', 'get', 'cm', 'ceph-bucket', '-o', "jsonpath='{.data.BUCKET_HOST}'"]
    result = run_command(cmd)
    return result

def get_bucket_port():
    cmd = ['kubectl', '-n', 'rook-ceph', 'get', 'cm', 'ceph-bucket', '-o', "jsonpath='{.data.BUCKET_PORT}'"]
    result = run_command(cmd)
    return result

def run_command(command):
        try:
            if isinstance(command, list):
                result = subprocess.run(command, capture_output=True)
            else:
                result = subprocess.run(command, shell=True, capture_output=True)
            if result.stderr:
                print(result.stderr.decode('utf-8'))
            return result.stdout.decode('utf-8').strip()
        except subprocess.CalledProcessError as e:
            print(f"An error occurred: {e}")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
        finally:
            pass

def main():
    key = get_aws_access_key_id()
    secret = get_aws_secret_access_key()
    host = get_bucket_host()
    port = get_bucket_port()
    bucket_name = get_bucket_name()
    create_credential_file(key, secret, host, port, bucket_name)
    print('Credentials file created successfully')

if __name__ == '__main__':
    main()

