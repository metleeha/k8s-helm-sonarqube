#!/bin/bash 

export PASSWD=$(kubectl get secret --namespace ${1} ${1}-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode)
export NODE_PORT=$(kubectl get --namespace ${1} -o jsonpath="{.spec.ports[0].nodePort}" services ${1}-postgre-postgresql)
export NODE_IP=$(kubectl get nodes --namespace ${1} -o jsonpath="{.items[0].status.addresses[1].address}")
echo Jenkins url is http://$NODE_IP:$NODE_PORT/login
echo ID is admin
echo admin passwd is $PASSWD



    export NODE_IP=$(kubectl get nodes --namespace lab99 -o jsonpath="{.items[0].status.addresses[0].address}")
    export NODE_PORT=$(kubectl get --namespace lab99 -o jsonpath="{.spec.ports[0].nodePort}" services lab99-postgre-postgresql)
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host $NODE_IP --port $NODE_PORT -U postgres -d postgres
    