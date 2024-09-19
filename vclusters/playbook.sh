#!/bin/bash

CLUSTER_IDS=${CLUSTER_IDS:-"demo"}
ZIP_PASSWORD=${ZIP_PASSWORD:-"password"}

for cluster in ${CLUSTER_IDS}; do
    echo "connecting to cluster-${cluster}..."
    vcluster connect cluster-${cluster} -n cluster-${cluster} --server=https://${cluster}.cluster.classroom.bswe.fh-burgenland.muehlbachler.xyz --service-account admin --cluster-role cluster-admin --insecure --print > vclusters/configs/cluster-${cluster}.conf
    KUBECONFIG="vclusters/configs/cluster-${cluster}.conf" kubectl get pod -A

    echo "zipping configuration for cluster-${cluster}..."
    zip -ejq vclusters/configs/cluster-${cluster}.zip vclusters/configs/cluster-${cluster}.conf -P ${ZIP_PASSWORD}
done

echo "copying configuration to the cluster-access pod..."
kubectl -n fh-burgenland-bswe-cluster-access get pod -l  "app.kubernetes.io/name=cluster-access" -o jsonpath="{.items[0].metadata.name}" | xargs -I {} kubectl -n fh-bswe-cluster-access cp vclusters/configs/cluster-*.zip {}:/usr/share/nginx/html/files/
