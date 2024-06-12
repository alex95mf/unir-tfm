#!/bin/bash

# Cambiar al directorio de configuraci�n de Terraform
cd ./terraform_configuration || { echo "Error: No se pudo acceder al directorio de configuraci�n de Terraform."; exit 1; }

# Destruir la infraestructura utilizando Terraform
terraform destroy --auto-approve -var-file=credentials.tfvars

# Volver a directorio base
cd ..

# Comprobar si la destrucci�n fue exitosa
echo "Infraestructura destruida exitosamente."
