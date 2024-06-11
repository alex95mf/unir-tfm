#!/bin/bash

# Función para seleccionar la nube de despliegue
select_cloud() {
    echo "Selecciona la nube de despliegue:"
    select cloud in "Amazon Web Services (AWS)"; do
        case $cloud in
            "Amazon Web Services (AWS)")
                selected_cloud="AWS"
                break
                ;;
            *)
                echo "Selecciona una opción válida."
                ;;
        esac
    done
}

# Función para solicitar las credenciales de AWS
input_aws_credentials() {
    read -p "Introduce el Access Key ID: " aws_access_key
    read -sp "Introduce el Secret Access Key: " aws_secret_key
    echo
}

# Función para seleccionar las características de hardware
select_hardware() {
    echo "Selecciona las características de hardware para la infraestructura: (por defecto: t2.micro)"
    
    hardware_options=("t2.nano" "t2.micro" "t2.small" "t2.medium" "t2.large" "t2.xlarge" "t2.2xlarge"
                      "t3.nano" "t3.micro" "t3.small" "t3.medium" "t3.large" "t3.xlarge" "t3.2xlarge"
                      "t3a.nano" "t3a.micro" "t3a.small" "t3a.medium" "t3a.large" "t3a.xlarge" "t3a.2xlarge"
                      "m5.large" "m5.xlarge" "m5.2xlarge" "m5.4xlarge" "m5.12xlarge" "m5.24xlarge"
                      "m5a.large" "m5a.xlarge" "m5a.2xlarge" "m5a.4xlarge" "m5a.12xlarge" "m5a.24xlarge"
                      "m5n.large" "m5n.xlarge" "m5n.2xlarge" "m5n.4xlarge" "m5n.12xlarge" "m5n.24xlarge"
                      "c5.large" "c5.xlarge" "c5.2xlarge" "c5.4xlarge" "c5.9xlarge" "c5.18xlarge"
                      "c5a.large" "c5a.xlarge" "c5a.2xlarge" "c5a.4xlarge" "c5a.8xlarge" "c5a.12xlarge" "c5a.16xlarge" "c5a.24xlarge"
                      "r5.large" "r5.xlarge" "r5.2xlarge" "r5.4xlarge" "r5.12xlarge" "r5.24xlarge"
                      "r5a.large" "r5a.xlarge" "r5a.2xlarge" "r5a.4xlarge" "r5a.12xlarge" "r5a.24xlarge"
                      "r5n.large" "r5n.xlarge" "r5n.2xlarge" "r5n.4xlarge" "r5n.12xlarge" "r5n.24xlarge"
                      "p3.2xlarge" "p3.8xlarge" "p3.16xlarge"
                      "g4dn.xlarge" "g4dn.2xlarge" "g4dn.4xlarge" "g4dn.8xlarge" "g4dn.12xlarge" "g4dn.16xlarge"
                      "inf1.xlarge" "inf1.2xlarge" "inf1.6xlarge" "inf1.24xlarge")

    select hardware in "${hardware_options[@]}"; do
        selected_hardware="$hardware"
        break
    done

    # Valor por defecto
    selected_hardware=${selected_hardware:-"t2.micro"}
}

# Función para seleccionar la región de despliegue
select_region() {
    echo "Selecciona la región de AWS:"
    select region in "us-east-1" "us-east-2" "us-west-1" "us-west-2" "ca-central-1" "eu-west-1" "eu-west-2" "eu-west-3" "eu-central-1" "eu-north-1" "ap-east-1" "ap-south-1" "ap-southeast-1" "ap-southeast-2" "ap-northeast-1"; do
        aws_region="$region"
        break
    done

    # Valor por defecto
    aws_region=${aws_region:-"us-east-1"}
}

# Función para seleccionar el nombre de la instancia EC2
select_instance_name() {
    read -p "Introduce el nombre de la instancia EC2 (por defecto: web-server): " instance_name
    instance_name=${instance_name:-"web-server"}
}

# Función para seleccionar el número de instancias
select_instance_count() {
    while true; do
        read -p "Introduce el número mínimo de instancias (por defecto: 1): " min_instances
        min_instances=${min_instances:-1}
        
        if ! [[ "$min_instances" =~ ^[0-9]+$ ]]; then
            echo "Por favor, introduce un número válido para el mínimo de instancias."
            continue
        elif (( min_instances < 0 )); then
            echo "El número mínimo de instancias no puede ser negativo."
            continue
        fi
        break
    done

    while true; do
        read -p "Introduce el número deseado de instancias (por defecto: 2): " desired_instances
        desired_instances=${desired_instances:-2}
        
        if ! [[ "$desired_instances" =~ ^[0-9]+$ ]]; then
            echo "Por favor, introduce un número válido para el deseado de instancias."
            continue
        elif (( desired_instances < min_instances )); then
            echo "El número deseado de instancias no puede ser menor que el número mínimo de instancias."
            continue
        fi
        break
    done

    while true; do
        read -p "Introduce el número máximo de instancias (por defecto: 3): " max_instances
        max_instances=${max_instances:-3}
        
        if ! [[ "$max_instances" =~ ^[0-9]+$ ]]; then
            echo "Por favor, introduce un número válido para el máximo de instancias."
            continue
        elif (( max_instances < min_instances )); then
            echo "El número máximo de instancias no puede ser menor que el número mínimo de instancias."
            continue
        elif (( max_instances < desired_instances )); then
            echo "El número máximo de instancias no puede ser menor que el número deseado de instancias."
            continue
        fi
        break
    done
}

# Función para seleccionar el nombre del bucket S3
select_s3_bucket() {
    read -p "Introduce el nombre del bucket S3 (por defecto: unir-tesis-s3): " s3_bucket
    s3_bucket=${s3_bucket:-"unir-tesis-s3"}
}

# Ejecutar las funciones para que el usuario seleccione las opciones
select_cloud

if [[ "$1" == "-c" ]]; then
    input_aws_credentials
fi

select_hardware
select_region
select_instance_name
select_instance_count
select_s3_bucket

# Mostrar las opciones seleccionadas por el usuario
echo "Nube seleccionada: $selected_cloud"
echo "Hardware seleccionado: $selected_hardware"
echo "Región seleccionada: $aws_region"
echo "Nombre de instancia EC2: $instance_name"
echo "Número mínimo de instancias: $min_instances"
echo "Número deseado de instancias: $desired_instances"
echo "Número máximo de instancias: $max_instances"
echo "Nombre del bucket S3: $s3_bucket"

# Almacenar las opciones seleccionadas en un archivo (por ejemplo, config.txt)
cat <<EOL > config.txt
cloud: $selected_cloud
hardware: $selected_hardware
region: $aws_region
instance_name: $instance_name
min_instances: $min_instances
desired_instances: $desired_instances
max_instances: $max_instances
bucket_name: $s3_bucket
EOL

if [[ "$1" == "-c" ]]; then
    cat <<EOL > credentials.tfvars
access_key = "$aws_access_key"
secret_key = "$aws_secret_key"
EOL
    echo "Credenciales almacenadas en credentials.tfvars"
fi

echo "Opciones almacenadas en config.txt"

# Ejecutar el script de inicialización de Terraform
bash inicializar.sh
