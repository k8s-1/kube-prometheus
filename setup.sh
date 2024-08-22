#!/bin/bash
./build.sh main.jsonnet

kubectl create ns actions-runner-system
kubectl create namespace my-namespace
kubectl create namespace my-second-namespace

kubectl create namespace monitoring

sleep 3

kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition -n monitoring

kubectl apply -f manifests/

sleep 3

cd example-app || exit 1
kustomize build . | kubectl apply -f -

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=prometheus -n monitoring --timeout 300s
kubectl -n monitoring port-forward svc/prometheus-k8s 9090:9090 > /dev/null 2>&1 &

printf "\nMetrics are being monitored:"
url="http://localhost:9090/targets"
echo -e "\e[4m$url\e[0m"
