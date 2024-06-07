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
  echo "Ejecutando delete_terraform.sh..."
  ./delete_terraform.sh
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
  echo "Subiendo archivos de build a S3..."
  aws s3 cp . s3://unir-tesis-bucket-unico/ --recursive || error_exit "Error al subir archivos a S3."
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

  echo "Cambiando al directorio de build..."
  cd "$target_dir" || error_exit "No se pudo acceder al directorio de build."
}

# Función para verificar si Terraform ya ha sido inicializado y limpiar si es necesario
check_and_cleanup_terraform() {
  if [ -f "./terraform_configuration/terraform.tfstate" ] || [ -f "./terraform_configuration/terraform.tfstate.backup" ]; then
    echo "Terraform ya ha sido inicializado. Ejecutando delete_terraform.sh..."
    ./delete_terraform.sh || error_exit "Error al ejecutar delete_terraform.sh"
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
