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

# kubectl -n access-config get pod
# kubectl -n access-config cp vclusters/cluster-group-1.zip access-config-access-app-5f555db6d6-5khck:/usr/share/nginx/html/files/
# kubectl -n access-config cp vclusters/cluster-group-2.zip access-config-access-app-5f555db6d6-5khck:/usr/share/nginx/html/files/
# kubectl -n access-config cp vclusters/cluster-group-3.zip access-config-access-app-5f555db6d6-5khck:/usr/share/nginx/html/files/
# kubectl -n access-config cp vclusters/cluster-group-4.zip access-config-access-app-5f555db6d6-5khck:/usr/share/nginx/html/files/
# kubectl -n access-config cp vclusters/cluster-group-5.zip access-config-access-app-5f555db6d6-5khck:/usr/share/nginx/html/files/
# kubectl -n access-config cp vclusters/cluster-group-6.zip access-config-access-app-5f555db6d6-5khck:/usr/share/nginx/html/files/
# kubectl -n access-config cp vclusters/cluster-group-7.zip access-config-access-app-5f555db6d6-5khck:/usr/share/nginx/html/files/
# kubectl -n access-config cp vclusters/cluster-group-8.zip access-config-access-app-5f555db6d6-5khck:/usr/share/nginx/html/files/
