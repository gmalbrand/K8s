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
