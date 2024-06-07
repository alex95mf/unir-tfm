#!/bin/bash

# Funci�n para seleccionar la nube de despliegue
select_cloud() {
    echo "Selecciona la nube de despliegue:"
    select cloud in "Amazon Web Services (AWS)"; do
        case $cloud in
            "Amazon Web Services (AWS)")
                selected_cloud="AWS"
                break
                ;;
            *)
                echo "Selecciona una opci�n v�lida."
                ;;
        esac
    done
}

# Funci�n para solicitar las credenciales de AWS
input_aws_credentials() {
    read -p "Introduce el Access Key ID: " aws_access_key
    read -sp "Introduce el Secret Access Key: " aws_secret_key
    echo
}

# Funci�n para seleccionar las caracter�sticas de hardware
select_hardware() {
    echo "Selecciona las caracter�sticas de hardware para la infraestructura: (por defecto: t2.micro)"
    
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

# Funci�n para seleccionar la regi�n de despliegue
select_region() {
    read -p "Introduce la regi�n de AWS (por defecto: us-east-1): " aws_region
    aws_region=${aws_region:-"us-east-1"}
}

# Funci�n para seleccionar el nombre de la instancia EC2
select_instance_name() {
    read -p "Introduce el nombre de la instancia EC2 (por defecto: web-server): " instance_name
    instance_name=${instance_name:-"web-server"}
}

# Funci�n para seleccionar el n�mero de instancias
select_instance_count() {
    while true; do
        read -p "Introduce el n�mero m�nimo de instancias (por defecto: 1): " min_instances
        min_instances=${min_instances:-1}
        
        if ! [[ "$min_instances" =~ ^[0-9]+$ ]]; then
            echo "Por favor, introduce un n�mero v�lido para el m�nimo de instancias."
            continue
        elif (( min_instances < 0 )); then
            echo "El n�mero m�nimo de instancias no puede ser negativo."
            continue
        fi
        break
    done

    while true; do
        read -p "Introduce el n�mero deseado de instancias (por defecto: 2): " desired_instances
        desired_instances=${desired_instances:-2}
        
        if ! [[ "$desired_instances" =~ ^[0-9]+$ ]]; then
            echo "Por favor, introduce un n�mero v�lido para el deseado de instancias."
            continue
        elif (( desired_instances < min_instances )); then
            echo "El n�mero deseado de instancias no puede ser menor que el n�mero m�nimo de instancias."
            continue
        fi
        break
    done

    while true; do
        read -p "Introduce el n�mero m�ximo de instancias (por defecto: 3): " max_instances
        max_instances=${max_instances:-3}
        
        if ! [[ "$max_instances" =~ ^[0-9]+$ ]]; then
            echo "Por favor, introduce un n�mero v�lido para el m�ximo de instancias."
            continue
        elif (( max_instances < min_instances )); then
            echo "El n�mero m�ximo de instancias no puede ser menor que el n�mero m�nimo de instancias."
            continue
        elif (( max_instances < desired_instances )); then
            echo "El n�mero m�ximo de instancias no puede ser menor que el n�mero deseado de instancias."
            continue
        fi
        break
    done
}

# Funci�n para seleccionar el nombre del bucket S3
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
echo "Regi�n seleccionada: $aws_region"
echo "Nombre de instancia EC2: $instance_name"
echo "N�mero m�nimo de instancias: $min_instances"
echo "N�mero deseado de instancias: $desired_instances"
echo "N�mero m�ximo de instancias: $max_instances"
echo "Nombre del bucket S3: $s3_bucket"

# Almacenar las opciones seleccionadas en un archivo (por ejemplo, config.txt)
cat <<EOL > config.txt
Nube: $selected_cloud
Hardware: $selected_hardware
Regi�n: $aws_region
Nombre de instancia EC2: $instance_name
N�mero m�nimo de instancias: $min_instances
N�mero deseado de instancias: $desired_instances
N�mero m�ximo de instancias: $max_instances
Nombre del bucket S3: $s3_bucket
EOL

if [[ "$1" == "-c" ]]; then
    cat <<EOL > credentials.tfvars
access_key = "$aws_access_key"
secret_key = "$aws_secret_key"
EOL
    echo "Credenciales almacenadas en credentials.tfvars"
fi

echo "Opciones almacenadas en config.txt"

# Ejecutar el script de inicializaci�n de Terraform
bash inicializacion_terraform.sh
