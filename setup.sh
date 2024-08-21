#!/bin/bash
./build.sh setup.jsonnet

kubectl create ns actions-runner-system

kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition -n monitoring

kubectl apply -f manifests/

kubectl wait --for=condition=ready pod/prometheus-k8s -n monitoring
kubectl -n monitoring port-forward svc/prometheus-k8s 9090:9090 &
