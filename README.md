# envoy-getting-started
Example envoy configuration files to experiment with different features

# Pre-Requisites:
- Docker
- [kind-cluster](https://github.com/abhide/kind-clusters)

# Envoy Deployment with ALS
You will need to deploy [Envoy ALS server](https://github.com/abhide/envoy-access-log-server).
```bash
➜  envoy-getting-started git:(master) ✗ make CONFIG_FILEPATH=k8s/als.yaml all
docker build -t local-envoy:latest ./
Sending build context to Docker daemon  82.94kB
Step 1/2 : FROM envoyproxy/envoy:v1.17.0
v1.17.0: Pulling from envoyproxy/envoy
f22ccc0b8772: Pull complete 
3cf8fb62ba5f: Pull complete 
e80c964ece6a: Pull complete 
fc8dbfbeecec: Pull complete 
ef7dff1e326b: Pull complete 
26224340b818: Pull complete 
922974cb7922: Pull complete 
118df14fd666: Pull complete 
6699f6865169: Pull complete 
102e36a06f76: Pull complete 
Digest: sha256:7515b7eebc5185259ca92137c44e6fd60e19e3a6540bc002cf2cf9e98ff74fc4
Status: Downloaded newer image for envoyproxy/envoy:v1.17.0
 ---> b8afe75bd5dc
Step 2/2 : ENV loglevel=info
 ---> Running in 49fa49817185
Removing intermediate container 49fa49817185
 ---> 23888efaefac
Successfully built 23888efaefac
Successfully tagged local-envoy:latest
kind load docker-image local-envoy:latest --name=cluster01
Image: "local-envoy:latest" with ID "sha256:23888efaefac011b0248bcf2f966056c8cc64cad97a438e7dddec7cdc1ed52c6" not yet present on node "cluster01-control-plane", loading...
kubectl create namespace ingress || true
namespace/ingress created
kubectl create configmap envoy-config --from-file=envoy.yaml=k8s/als.yaml -n ingress
configmap/envoy-config created
kubectl apply -f k8s/envoy-deployment.yaml -n ingress
deployment.apps/envoy created
service/envoy-ingress-svc created

➜  envoy-getting-started git:(master) ✗ kubectl get pods -n ingress
NAME                    READY   STATUS    RESTARTS   AGE
envoy-9b7fbdb87-9mglq   1/1     Running   0          5m3s

➜  envoy-getting-started git:(master) ✗ kubectl get svc -n ingress
NAME                TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
envoy-ingress-svc   NodePort   10.96.178.120   <none>        8080:30000/TCP   5m8s
```

# Delete deployment
```bash
➜  envoy-getting-started git:(master) ✗ make clean-ns 
kubectl delete namespace ingress
namespace "ingress" deleted
```