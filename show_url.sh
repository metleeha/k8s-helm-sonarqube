#!/bin/bash 
export NODE_PORT=$(kubectl get --namespace ${1} -o jsonpath="{.spec.ports[0].nodePort}" services ${1}-sonarqube-sonarqube)
export NODE_IP=$(kubectl get nodes --namespace ${1} -o jsonpath="{.items[0].status.addresses[1].address}")
echo Sonarqube url is http://$NODE_IP:$NODE_PORT
echo ID is admin
echo admin passwd is admin

