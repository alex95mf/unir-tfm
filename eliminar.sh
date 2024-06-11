#!/bin/bash

# Detener la ejecución del script si ocurre algún error
set -e

# Leer las opciones seleccionadas por el usuario desde config.txt
selected_cloud=$(grep "Nube:" config.txt | cut -d " " -f 2)
selected_hardware=$(grep "Hardware:" config.txt | cut -d " " -f 2)

# Obtener el nombre del bucket S3 de las variables de entorno
s3_bucket=$TF_VAR_s3_bucket

# Cambiar al directorio de configuración de Terraform
cd ./terraform_configuration || { echo "Error: No se pudo acceder al directorio de configuración de Terraform."; exit 1; }

# Verificar si el bucket S3 existe antes de intentar eliminar objetos
if aws s3 ls "s3://$s3_bucket" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "El bucket S3 no existe. No se pueden eliminar objetos."
else
  echo "Eliminando todos los objetos del bucket S3..."
  aws s3 rm "s3://$s3_bucket" --recursive
fi

# Destruir la infraestructura utilizando Terraform
terraform destroy --auto-approve -var-file=credentials.tfvars

# Volver a directorio base
cd ..

# Comprobar si la destrucción fue exitosa
echo "Infraestructura destruida exitosamente."
