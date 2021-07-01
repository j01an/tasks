#!/bin/bash

############### Validacion de accesos y permisos al Account service ############

echo "Ya registro su e-mail Account Service? "
echo "Escriba yes o no :"
read confir

if [ "$confir" = "no" ]; then

    echo "Si es primera vez favor de colocar su E-mail de Service Account con permisos"
    read email
    sleep 1

    echo "Favor escriba la ruta donde se encuentra el private key en formato y el nombre [service-account.json] : "
    read llave
    
    gcloud auth activate-service-account $email --key-file=$llave
    

fi





DESC="[Creando Kubernetes]"
NAME="OK"



case "$1" in
    CREATE)

        ##################### Creación de cluster con un nodo en Kubernetes ################################# 
        echo "Desea aplicar? : "
        echo "si o no"
        read apl
        
        if [ "$apl" = "si" ]; then
        echo -n "Starting ${DESC}: "
        terraform init
        terraform apply -auto-approve > /dev/null 2>&1
        echo "$NAME."

        fi

        sleep 2


        echo "Realizo la conexión al cluster medienta [gcloud container clusters] ? "
        echo "si o no"
        read acp

        if [ "$acp" = "no" ]; then

            echo "Si es primera vez favor escriba la linea de comando que le proporciona la coneccion al cluster: "
            read accs
            sleep 1

            $accs

            sleep 2

            ################################### Instalado ingress Controller NGINX ##############################

            echo "Verificando que tenga instalado el service ingress......."
            ingnginx=$( helm list | grep nginx-ingress)

            #echo $?
            #echo $?
            stat="$?"
            #echo $stat
            if [ $stat != "0" ];then
                yum install epel-release -y
                yum install jq -y
                curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
                chmod 700 get_helm.sh
                sh get_helm.sh
                helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
                helm repo update
                sleep 2
                helm install nginx-ingress ingress-nginx/ingress-nginx

            fi

            echo "Desea subir a su proyecto la imagen API : "
            echo "si o no"
            read img
            
            if [ "$img" = "si" ]; then
            echo -n "Comenzando: "
            cd images
            docker build -t apitask -f Dockerfile .

            echo "Escriba porfavor su ID del proyecto: "
            
            read idPro


            docker tag apitask gcr.io/$idPro/apitask:v1

            gcloud docker -- push gcr.io/$idPro/apitask:v1
            
            echo "OK."

            fi

            

        fi

        


        ;;
    DESTROY)
        echo -n "Destruyendo $DESC: "
        terraform destroy -auto-approve > /dev/null 2>&1
        echo "$NAME."
        
        ;;
    
    OUTPUT)
        echo -n "Prueba output"
        ;;
    *)
        N=$0
        echo "USA: $0 {CREATE|DESTROY|OUTPUT}" >&2
        exit 1
        ;;
esac

exit 0
