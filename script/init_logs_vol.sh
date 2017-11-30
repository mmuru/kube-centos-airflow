#!/bin/bash
# NFS mount airflow logs, dags, lib, plugins, etc...
mkdir -p /opt/airflow
echo "/opt/airflow -network 192.168.64.0 -mask 255.255.255.0 -alldirs -maproot=root:wheel" > /etc/exports
nfsd restart
