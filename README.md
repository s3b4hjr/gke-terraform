### Implantação Terraform
Instalar CLI do google.
https://cloud.google.com/sdk/docs/install

Após criar projeto no GCP alterar no terraform.tfvars o project_id com o ID do projeto criado.

Autenticar no GCP:

GCP usa Application Default Credentials.
```
gcloud auth login
```

Hablilite application default credentials:
```
gcloud auth application-default login
```

### Criar service account com permissão proprietario, somente para ambiente de estudos.
```
gcloud iam service-accounts create terraform \
    --description="terraform sa" \
    --display-name="terraform sa"
```

Mudar PROJECT_ID para o ID do projeto
```
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:terraform@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/owner"
```

Gerar token na raiz do projeto. 
```
gcloud iam service-accounts keys create token.json \
    --iam-account=terraform@PROJECT_ID.iam.gserviceaccount.com
```

### Plan & Apply terraform

```
terraform init
```

```
terraform apply
```


### Criptografando secrets com Sops

Instalar binario Sops https://github.com/mozilla/sops

Criptografando com GCP KMS
```
gcloud kms keyrings create sops --location us-central1
```
```
gcloud kms keys create sops --location us-central1 --keyring sops --purpose encryption
```
```
gcloud kms keys list --keyring sops --location us-central1

Saida do comando:

NAME                                                                                PURPOSE          PRIMARY_STATE
projects/PROJECT_ID/locations/us-central1/keyRings/sops-teste/cryptoKeys/sops-teste ENCRYPT_DECRYPT  ENABLED
```

Criptografar usando sops encrypt:
```
sops --encrypt --gcp-kms projects/PROJECT_ID/locations/us-central1/keyRings/sops/cryptoKeys/sops helm/environments/prod/secrets-example.yaml > helm/environments/prod/secrets.yaml
```

Descriptografar:
```
sops --decrypt helm/environments/prod/secrets.yaml
```

### Usando helm para implantar chart com secret criptografada

Editar o arquivo helm/environments/prod/.sops.yaml e colocar o PROJECT_ID do GPC.
```
creation_rules:
  - path_regex: .yaml$
    gcp_kms: projects/PROJECT_ID/locations/us-central1/keyRings/sops/cryptoKeys/sops
```

Conectar no cluster GKE

```
gcloud container clusters get-credentials gke-cluster --zone us-central1-a --project PROJECT_ID
```

helm secrets upgrade --install bootcamp helm --wait --create-namespace --namespace bootcamp --values helm/environments/prod/values.yaml --values helm/environments/prod/secrets.yaml

kubectl -n bootcamp port-forward services/bootcamp 5000:5000

curl http://localhost:5000
