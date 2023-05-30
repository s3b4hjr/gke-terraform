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

