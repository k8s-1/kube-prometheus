#!/bin/bash
./build.sh main.jsonnet

# kubectl create ns actions-runner-system
kubectl create namespace myns1
kubectl create namespace myns2

sleep 3

kubectl apply -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition -n monitoring

kubectl apply -f manifests/

sleep 3

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=prometheus -n monitoring --timeout 300s
kubectl -n monitoring port-forward svc/prometheus-k8s 9090:9090 > /dev/null 2>&1 &

printf "\nMetrics are being monitored:"
url="http://localhost:9090/targets"
echo -e "\e[4m$url\e[0m"
