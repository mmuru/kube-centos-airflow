#!/bin/bash
minikube start --vm-driver=xhyve --insecure-registry localhost:5000

# setup mount on minikube
minikube ssh -- sudo mkdir /opt/airflow
minikube ssh -- sudo mount 192.168.64.1:/opt/airflow /opt/airflow -o rw,async,noatime,rsize=32768,wsize=32768,proto=tcp

# set minikube docker vm
#eval $(minikube docker-env)
