#!/bin/bash
./build.sh main.jsonnet

kubectl create ns actions-runner-system

kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition -n monitoring

kubectl apply -f manifests/

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=prometheus -n monitoring
kubectl -n monitoring port-forward svc/prometheus-k8s 9090:9090 > /dev/null 2>&1 &
