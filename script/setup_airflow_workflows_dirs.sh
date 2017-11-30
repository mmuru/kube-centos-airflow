#!/bin/bash
AIRFLOW_HOME=/opt/airflow
user=$(id -u -n)
#
SDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ldir=$(dirname $SDIR)
#
sudo mkdir -p ${AIRFLOW_HOME}/logs
sudo chmod -R 777 ${AIRFLOW_HOME}/logs
sudo rm -f ${AIRFLOW_HOME}/dags
sudo rm -f ${AIRFLOW_HOME}/plugins
sudo ln -fs $ldir/dags ${AIRFLOW_HOME}/dags
sudo ln -fs $ldir/plugins ${AIRFLOW_HOME}/plugins
sudo chown -R $user ${AIRFLOW_HOME}
sudo chown -h $user ${AIRFLOW_HOME}/dags
sudo chown -h $user ${AIRFLOW_HOME}/plugins
