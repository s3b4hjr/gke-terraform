## https://www.thorsten-hans.com/encrypt-your-kubernetes-secrets-with-mozilla-sops/

2.1   Test with the dev PGP key
If you want to test sops without having to do a bunch of setup, you can use the example files and pgp key provided with the repository:

$ git clone https://github.com/mozilla/sops.git
$ cd sops
$ gpg --import pgp/sops_functional_tests_key.asc
$ sops example.yaml
This last step will decrypt example.yaml using the test private key.


2.3   Encrypting using GCP KMS

https://cloud.google.com/kms/docs/getting-resource-ids#gcloud_1

GCP KMS uses Application Default Credentials. If you already logged in using

$ gcloud auth login
you can enable application default credentials using the sdk:

$ gcloud auth application-default login
Encrypting/decrypting with GCP KMS requires a KMS ResourceID. You can use the cloud console the get the ResourceID or you can create one using the gcloud sdk:

$ gcloud kms keyrings create sops --location us-central1
$ gcloud kms keys create sops --location us-central1 --keyring sops --purpose encryption
$ gcloud kms keyrings list --location us-central1
$ gcloud kms keys list --keyring sops --location us-central1

# you should see
NAME                                                                   PURPOSE          PRIMARY_STATE
projects/my-project/locations/global/keyRings/sops/cryptoKeys/sops-key ENCRYPT_DECRYPT  ENABLED
Now you can encrypt a file using:

$ sops --encrypt --gcp-kms projects/essential-graph-366214/locations/us-central1/keyRings/sops/cryptoKeys/sops secrets.yaml > secrets.enc.yaml
And decrypt it using:

$ sops --decrypt test.enc.yaml


**********

helm upgrade --install bootcamp helm --wait --create-namespace --namespace bootcamp --values helm/environments/development/values.yaml --values helm/environments/development/secrets.yaml

kubectl -n bootcamp port-forward services/bootcamp 5000:5000

curl http://localhost:5000


