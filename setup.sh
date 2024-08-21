#!/bin/bash
# ./build.sh main.jsonnet
./build.sh namespace.jsonnet

# kubectl create ns actions-runner-system
kubectl create ns ns1
kubectl create ns ns2

sleep 1

kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition -n monitoring

kubectl apply -f manifests/

sleep 5

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=prometheus -n monitoring --timeout 300s
kubectl -n monitoring port-forward svc/prometheus-k8s 9090:9090 > /dev/null 2>&1 &

printf "\nMetrics are being monitored:"
url="http://localhost:9090/targets"
echo -e "\e[4m$url\e[0m"
