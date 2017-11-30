## kube-centos-airflow 
It lets developer to run and test [Apache Airflow](http://http://airflow.apache.org/) workflows in a local Kubernetes cluster such as minikube.
Add your workflows into dags and plugins folders.

### Requirements:
* MacOS
* minikube
* [Docker for Mac](https://download.docker.com/mac/stable/Docker.dmg)
* Brew

## Install prerequisite packages
```brew install xhyve```

```brew install docker-machine-driver-xhyve```
```
sudo chown root:wheel /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
```
```
sudo chmod u+s /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
```
```brew install kubectl```
### Install minikube:
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```
## Clone kube-centos-airflow
```git clone https://github.com/mmuru/kube-centos-airflow.git```

```cd $HOME/kube-centos-airflow or change to checkout dir and perform the following steps```

## Init airflow workflows and logs volume
```sudo sh script/init_logs_vol.sh```

```sh script/setup_airflow_workflows-dirs.sh```

## Start minikube cluster
``` sh script/start-minikube-cluster```

## Set minikube docker vm
```eval $(minikube docker-env)```

## Build Apache airflow Image
```sh script/build-airflow-image.sh```

## Start airflow k8s cluster
```sh script/start-airflow-k8s-cluster.sh```

## Stop airflow k8s cluster
```sh script/stop-airflow-k8s-cluster.sh```

## Stop minikube cluster
```sh script/stop-minikube-cluster.sh```

## View minikubw dashboard
```minikube dashboard```

## View airflow dashboard
```open $(minikube service web --url)```
