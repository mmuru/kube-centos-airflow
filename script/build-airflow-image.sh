#!/bin/bash
AIRFLOW_VERSION=1.8.2
KUBECTL_VERSION=1.8.4
KUBE_AIRFLOW_VERSION=1.0
REPOSITORY=kube-centos-airflow
TAG=${AIRFLOW_VERSION}-${KUBECTL_VERSION}-${KUBE_AIRFLOW_VERSION}
IMAGE=${REPOSITORY}:${TAG}
ALIAS=${REPOSITORY}

rm -rf build

mkdir -p build/${TAG}
mkdir -p build/${TAG}/config
mkdir -p build/${TAG}/script

sed -e 's/#KUBECTL_VERSION#/'"${KUBECTL_VERSION}"'/g;' -e 's/#AIRFLOW_VERSION#/'"${AIRFLOW_VERSION}"'/g;' Dockerfile > build/${TAG}/Dockerfile

cp config/airflow.cfg build/${TAG}/config/airflow.cfg
cp script/entrypoint.sh build/${TAG}/script/entrypoint.sh

#kick-off build
cd build/${TAG}
docker build --rm -t ${IMAGE} .
docker tag ${IMAGE} ${ALIAS}
