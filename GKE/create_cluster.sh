# Name of the cluster followed by date timestamp
if [ "x$CLUSTER_NAME" != "x" ]; then
  export CLUSTER_NAME="${CLUSTER_NAME}_$(date +%Y-%m-%d)"
else
  export CLUSTER_NAME="gke-std-$(date +%Y-%m-%d)"
fi

# Number of nodes in the cluster
export NUM_NODES=4
gcloud container clusters create $CLUSTER_NAME --project="$(gcloud config get project)" --zone="$(gcloud config get compute/zone)" --num-nodes=4

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials "$CLUSTER_NAME" --project="$(gcloud config get project)" --zone="$(gcloud config get compute/zone)"


kubectl create namespace scalyr
kubectl create secret generic scalyr-api-key --namespace=scalyr --from-literal=scalyr-api-key="0vxrcQGLmk57G9dQamhVqlp4/HjI2/aLh63rTLXSGNVU-"

curl -s https://raw.githubusercontent.com/scalyr/scalyr-agent-2/release/k8s/scalyr-agent-2-configmap.yaml | \
  sed "s/<your_cluster_name>/$CLUSTER_NAME/" | \
  kubectl create -f -

kubectl apply -f https://raw.githubusercontent.com/scalyr/scalyr-agent-2/release/k8s/no-kustomize/scalyr-service-account.yaml
kubectl apply -f https://raw.githubusercontent.com/scalyr/scalyr-agent-2/release/k8s/no-kustomize/scalyr-agent-2.yaml
