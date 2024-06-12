#!/bin/bash

# Leer los datos del archivo config.txt
while IFS= read -r line; do
    if [[ $line == "cloud:"* ]]; then
        selected_cloud=$(echo "$line" | cut -d " " -f 2)
    elif [[ $line == "hardware:"* ]]; then
        selected_hardware=$(echo "$line" | cut -d " " -f 2)
    elif [[ $line == "region:"* ]]; then
        aws_region=$(echo "$line" | cut -d " " -f 2)
    elif [[ $line == "instance_name:"* ]]; then
        instance_name=$(echo "$line" | cut -d " " -f 2-)
    elif [[ $line == "min_instances:"* ]]; then
        min_instances=$(echo "$line" | cut -d " " -f 2)
    elif [[ $line == "desired_instances:"* ]]; then
        desired_instances=$(echo "$line" | cut -d " " -f 2)
    elif [[ $line == "max_instances:"* ]]; then
        max_instances=$(echo "$line" | cut -d " " -f 2)
    elif [[ $line == "bucket_name:"* ]]; then
        s3_bucket=$(echo "$line" | cut -d ":" -f 2 | tr -d '[:space:]')
    fi
done < config.txt

# Convertir las variables a números
min_instances=$(printf "%d" "$min_instances")
desired_instances=$(printf "%d" "$desired_instances")
max_instances=$(printf "%d" "$max_instances")

# Exportar las variables como variables de entorno
export TF_VAR_selected_hardware="$selected_hardware"
export TF_VAR_aws_region="$aws_region"
export TF_VAR_instance_name="$instance_name"
export TF_VAR_min_instances="$min_instances"
export TF_VAR_desired_instances="$desired_instances"
export TF_VAR_max_instances="$max_instances"
export TF_VAR_s3_bucket="$s3_bucket"

echo
echo "**************************************************************************"
echo "TF_VAR_aws_region: $TF_VAR_aws_region"
echo "TF_VAR_selected_hardware: $TF_VAR_selected_hardware"
echo "TF_VAR_s3_bucket: $TF_VAR_s3_bucket"
echo "TF_VAR_instance_name: $TF_VAR_instance_name"
echo "TF_VAR_min_instances: $TF_VAR_min_instances"
echo "TF_VAR_desired_instances: $TF_VAR_desired_instances"
echo "TF_VAR_max_instances: $TF_VAR_max_instances"
echo "**************************************************************************"
echo
