#!/bin/bash

# Cambiar al directorio de configuración de Terraform
cd ./terraform_configuration || { echo "Error: No se pudo acceder al directorio de configuración de Terraform."; exit 1; }

# Destruir la infraestructura utilizando Terraform
terraform destroy --auto-approve -var-file=credentials.tfvars

# Volver a directorio base
cd ..

# Comprobar si la destrucción fue exitosa
echo "Infraestructura destruida exitosamente."
