IMAGE=local-envoy
IMAGE_TAG=latest
NAMESPACE=ingress

build:
	docker build -t ${IMAGE}:${IMAGE_TAG} ./

kindly-push:
	kind load docker-image ${IMAGE}:${IMAGE_TAG} --name=${CLUSTER}

kindly-deploy:
	kubectl create namespace ${NAMESPACE} || true
	kubectl apply -f k8s/envoy-deployment.yaml -n ${NAMESPACE}

clean:
	kind delete cluster --name=${CLUSTER}

clean-ns:
	kubectl delete namespace ${NAMESPACE}

all: build kindly-push kindly-deploy
