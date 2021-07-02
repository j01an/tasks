#!/bin/bash

echo "Favor de activar su Service Account antes de prodecer con el script..."
echo ""
echo "Ejemplo de activar su Service Account"
echo ""
echo "--------gcloud auth activate-service-account [CuentaActiveAccount] --key-file=[RutaDeAccesoJSON] --project=[IDdelProyecto]-------"
echo ""
echo "En caso no este activado favor de presionar CTRL + C para cancelarla operacion y registrar su cuenta"
echo ""
sleep 7


echo "Se procederá con la creación de la maquina virtual (centos): "
echo ""
gcloud compute instances create jenkins-instance --image-family=rhel-7 --image-project=rhel-cloud --zone=us-central1-c
echo ""
echo "Sleep 5"
sleep 5

export IP_PUBLICA_INST=$(gcloud compute instances describe jenkins-instance --zone=us-central1-c  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "IP publica de la instancia creada es: $IP_PUBLICA_INST" 
echo $IP_PUBLICA_INST >> hosts

ansible-playbook -i hosts jenkins.yaml

echo "Ingresar a la siguiente URL e ingresar el codigo impreso.."

echo "http://$IP_PUBLICA_INST:8080"

unset IP_PUBLICA_INST

echo "[jenkins]" > hosts 

exit 0
