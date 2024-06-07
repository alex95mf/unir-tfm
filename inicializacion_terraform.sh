#!/bin/bash

# Leer los datos del archivo config.txt
while IFS= read -r line; do
    if [[ $line == "Nube:"* ]]; then
        selected_cloud=$(echo "$line" | cut -d " " -f 2)
    elif [[ $line == "Hardware:"* ]]; then
        selected_hardware=$(echo "$line" | cut -d " " -f 2)
    elif [[ $line == "Ruta Proyecto:"* ]]; then
        project_path=$(echo "$line" | cut -d " " -f 3-)
    fi
done < config.txt

# Exportar la variable de hardware como una variable de entorno
export TF_VAR_selected_hardware="$selected_hardware"

# Configurar Terraform para la nube seleccionada (AWS)
if [ "$selected_cloud" == "AWS" ]; then
    echo "Configurando Terraform para AWS..."
    cp Terraform_configuration/aws.tf.template Terraform_configuration/aws.tf 

    # Reemplazar el tipo de instancia en aws.tf con el valor seleccionado
    sed -i "s/{{instance_type}}/$selected_hardware/" Terraform_configuration/aws.tf
else
    echo "Nube seleccionada no válida."
    exit 1
fi

echo "Configuración de Terraform completada."

# Ejecutar el script de arranque de Terraform
bash arranque_terraform.sh
