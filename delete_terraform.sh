#!/bin/bash

# Detener la ejecución del script si ocurre algún error
set -e

# Leer las opciones seleccionadas por el usuario desde config.txt
selected_cloud=$(grep "Nube:" config.txt | cut -d " " -f 2)
selected_hardware=$(grep "Hardware:" config.txt | cut -d " " -f 2)

# Definir la ruta del proyecto
default_project=$(grep "Ruta Proyecto:" config.txt | cut -d " " -f 3-)

# Cambiar al directorio de configuración de Terraform
cd ./terraform_configuration || { echo "Error: No se pudo acceder al directorio de configuración de Terraform."; exit 1; }

# Verificar si el bucket S3 existe antes de intentar eliminar objetos
if aws s3 ls "s3://unir-tesis-bucket-unico" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "El bucket S3 no existe. No se pueden eliminar objetos."
else
  echo "Eliminando todos los objetos del bucket S3..."
  aws s3 rm s3://unir-tesis-bucket-unico --recursive
fi

# Destruir la infraestructura utilizando Terraform
terraform destroy --auto-approve -var-file=credentials.tfvars \
  -var="selected_hardware=$selected_hardware" 

# Volver a directorio base
cd ..

# Comprobar si la destrucción fue exitosa
echo "Infraestructura destruida exitosamente."
