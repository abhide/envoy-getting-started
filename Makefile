IMAGE=local-envoy
IMAGE_TAG=latest
NAMESPACE=ingress
CLUSTER=cluster01

build:
	docker build -t ${IMAGE}:${IMAGE_TAG} ./

kindly-push:
	kind load docker-image ${IMAGE}:${IMAGE_TAG} --name=${CLUSTER}

kindly-deploy:
	kubectl create namespace ${NAMESPACE} || true
	kubectl delete configmap envoy-config -n ${NAMESPACE}
	kubectl create configmap envoy-config --from-file=envoy.yaml=${CONFIG_FILEPATH} -n ${NAMESPACE}
	kubectl apply -f k8s/envoy-deployment.yaml -n ${NAMESPACE}

kindly-wasm-deploy:
	kubectl create namespace ${NAMESPACE} || true
	kubectl delete configmap envoy-config -n ${NAMESPACE}
	kubectl create configmap envoy-config --from-file=envoy.yaml=${CONFIG_FILEPATH} -n ${NAMESPACE}
	kubectl apply -f k8s/envoy-wasm-deployment.yaml -n ${NAMESPACE}

clean:
	kind delete cluster --name=${CLUSTER}

clean-ns:
	kubectl delete namespace ${NAMESPACE}

all: build kindly-push kindly-deploy
