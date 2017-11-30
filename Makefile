AIRFLOW_VERSION ?= 1.8.2
KUBECTL_VERSION ?= 1.8.4
KUBE_AIRFLOW_VERSION ?= 1.0.0

REPOSITORY ?= kube-centos-airflow
TAG ?= $(AIRFLOW_VERSION)-$(KUBECTL_VERSION)-$(KUBE_AIRFLOW_VERSION)
IMAGE ?= $(REPOSITORY):$(TAG)
ALIAS ?= $(REPOSITORY)

BUILD_ROOT ?= build/$(TAG)
DOCKERFILE ?= $(BUILD_ROOT)/Dockerfile
AIRFLOW_CONF ?= $(BUILD_ROOT)/config/airflow.cfg
ENTRYPOINT_SH ?= $(BUILD_ROOT)/script/entrypoint.sh

.PHONY: build clean 

clean:
	rm -Rf build

build: $(DOCKERFILE) $(AIRFLOW_CONF) $(ENTRYPOINT_SH)
	@echo $(BUILD_ROOT)
	cd $(BUILD_ROOT) && docker build --rm -t $(IMAGE) . && docker tag $(IMAGE) $(ALIAS)

$(DOCKERFILE): $(BUILD_ROOT)
	sed -e 's/#KUBECTL_VERSION#/'"$(KUBECTL_VERSION)"'/g;' -e 's/#AIRFLOW_VERSION#/'"$(AIRFLOW_VERSION)"'/g;' Dockerfile > $(DOCKERFILE)

$(AIRFLOW_CONF): $(BUILD_ROOT)
	mkdir -p $(shell dirname $(AIRFLOW_CONF))
	cp config/airflow.cfg $(AIRFLOW_CONF)

$(ENTRYPOINT_SH): $(BUILD_ROOT)
	mkdir -p $(shell dirname $(ENTRYPOINT_SH))
	cp script/entrypoint.sh $(ENTRYPOINT_SH)

$(BUILD_ROOT):
	mkdir -p $(BUILD_ROOT)
