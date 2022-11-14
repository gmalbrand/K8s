
# K8s Cheat Sheet

## Useful Commands

* Activate completion
```
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
```

* Create config map from file
```
kubectl create configmap  --dry-run=client <config map name> --from-file=<file or directory path> -o yaml
```

* Launch debian container
```
kubectl run -i --tty --rm debug --image=debian:latest --restart=Never  -- bash
```

## Metrics
### Metric server

Details on [GitRepo](https://github.com/kubernetes-sigs/metrics-server)
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
Can generate error with TLS verification. Add `--kubelet-insecure-tls` to container arguments.

Installation with [Helm](https://artifacthub.io/packages/helm/metrics-server/metrics-server)

```
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server --namespace kube-system --set "args={--kubelet-insecure-tls}"
```

Check deployment

```
kubectl get deploy,svc -n kube-system | grep metrics-server
```
```
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes | jq"
```

### Node exporter

See manifest in `./node_exporter` might need update

### State metrics

Basic deployment

```
git clone https://github.com/kubernetes/kube-state-metrics.git
cd kube-state-metrics
kubectl apply -f examples/standard
```

### Prometheus

See manifests in `./prometheus` might need update

## GKE
### Create cluster
Using default machine type
```
gcloud container clusters create <cluster-name> --project <project-name> --zone=<compute-zone> --num-nodes=<number of nodes>
```

* Get default project: `$(gcloud get config project)`
* Get default compute zone: `$(gcloud get config compute/zone)`

> Autopilot does not authorize daemon set

### Get Cluster credentials

Avoid connection warnings with `export USE_GKE_GCLOUD_AUTH_PLUGIN=True`

For default project and compute zone :
```
gcloud container clusters get-credentials <cluster-name>
```
Otherwise:
```
gcloud container clusters get-credentials <cluster-name> --project <project-name> --zone=<compute-zone> --num-nodes=<number of nodes>
```

### Clean up cluster
Don't forget to delete firewall rules
```
gcloud container clusters delete <cluster-name>
```
