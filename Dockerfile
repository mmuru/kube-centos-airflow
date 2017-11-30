# VERSION 0.1.0
# AUTHOR: muru

FROM centos:7

## Core OS and dependencies install & configure
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install \
        wget \
        nmap-ncat \
        python-pip \
        python-devel \
        krb5-devel \
        cyrus-sasl \
        cyrus-sasl-devel \
        cyrus-sasl-gs2 \
        cyrus-sasl-gssapi \
        cyrus-sasl-lib \
        cyrus-sasl-md5 \
        cyrus-sasl-plain \
        openssl-devel \
        libffi-devel \
        krb5-workstation \
        which \
        cronie-noanacron \
        sudo &&\
    yum -y groupinstall "Development Tools" && \
    pip install --upgrade pip

RUN  localedef --quiet -c -i en_US -f UTF-8 en_US.UTF-8

## Airflow install
ENV AIRFLOW_VERSION #AIRFLOW_VERSION#
ENV KUBECTL_VERSION #KUBECTL_VERSION#
ENV AIRFLOW_HOME /opt/airflow

#
RUN useradd --shell /bin/bash --create-home --home $AIRFLOW_HOME airflow \
    && mkdir $AIRFLOW_HOME/logs \
    && mkdir $AIRFLOW_HOME/dags \
    && mkdir $AIRFLOW_HOME/plugins \
    && chown -R airflow: $AIRFLOW_HOME \
    && pip install pytz==2015.7 cryptography pyOpenSSL ndg-httpsclient \ 
    && pip install pyasn1 psycopg2 celery==3.1.17 \
    && pip install --upgrade backports.ssl-match-hostname \
    && pip install configparser

RUN pip install "apache-airflow[celery, rabbitmq, postgres, async, password, crypto, kerberos, jdbc, docker]"

RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && chmod +x /usr/local/bin/kubectl

# Entrypoint
ADD script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
RUN chmod +x $AIRFLOW_HOME/entrypoint.sh

# Configuration
ADD config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN sed -i "s:#AIRFLOW_HOME#:$AIRFLOW_HOME:" $AIRFLOW_HOME/airflow.cfg

RUN FERNET_KEY=$(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print FERNET_KEY") \
    && sed -i "s/#FERNET_KEY#/$FERNET_KEY/" $AIRFLOW_HOME/airflow.cfg

EXPOSE 8080 5555 8793

USER root
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]
