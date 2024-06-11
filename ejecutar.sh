#!/bin/bash

# Función para imprimir mensajes de error y salir
error_exit() {
  echo "Error: $1" >&2

  # Verificar si estamos en el directorio correcto
  while [ "$(basename "$(pwd)")" != "Proyecto" ]; do
    echo "Cambiando al directorio 'Proyecto'..."
    cd .. || exit 1
  done

  # Ejecutar delete_terraform.sh
  echo "Ejecutando eliminar.sh..."
  ./eliminar.sh
  exit 1
}

# Función para inicializar Terraform
initialize_terraform() {
  echo "Inicializando Terraform..."
  terraform init || error_exit "Error al inicializar Terraform."
}

# Función para aplicar cambios con Terraform
apply_terraform_changes() {
  echo "Aplicando cambios con Terraform..."
  terraform apply --auto-approve -var-file=credentials.tfvars || error_exit "Error al aplicar los cambios con Terraform."
}

# Función para subir archivos de build a S3
upload_build_to_s3() {
  # Obtener el nombre del bucket S3 de la variable de entorno
  local s3_bucket_name="$TF_VAR_s3_bucket"  
  
  # Verificar si el nombre del bucket está definido
  if [ -z "$s3_bucket_name" ]; then
    error_exit "El nombre del bucket S3 no está definido en la variable de entorno TF_VAR_s3_bucket."
  fi

  echo "Subiendo archivos de build al bucket S3: $s3_bucket_name..."
  # Usar el nombre del bucket S3 para subir archivos
  aws s3 cp . "s3://$s3_bucket_name/" --recursive || error_exit "Error al subir archivos a S3."
}

# Cambiar al directorio del proyecto
change_to_project_directory() {
  local target_dir="./terraform_configuration"

  echo "Cambiando al directorio del proyecto..."
  cd "$target_dir" || error_exit "No se pudo acceder al directorio del proyecto."
}

# Cambiar al directorio de build
change_to_build_directory() {
  local target_dir="../build"
  echo
  echo "**************************************************************************"
  echo "Cambiando al directorio de build..."
  cd "$target_dir" || error_exit "No se pudo acceder al directorio de build."
}

# Función para verificar si Terraform ya ha sido inicializado y limpiar si es necesario
check_and_cleanup_terraform() {
  if [ -f "./terraform_configuration/terraform.tfstate" ] || [ -f "./terraform_configuration/terraform.tfstate.backup" ]; then
    echo "Terraform ya ha sido inicializado. Ejecutando delete_terraform.sh..."
    ./eliminar.sh || error_exit "Error al ejecutar eliminar.sh"
  fi
}


# Función principal
main() {  
  change_to_project_directory
  check_and_cleanup_terraform
  initialize_terraform
  apply_terraform_changes
  change_to_build_directory
  upload_build_to_s3
}

# Ejecutar la función principal
main
