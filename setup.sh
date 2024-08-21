#!/bin/bash
./build.sh setup.jsonnet
kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition -n monitoring
kubectl apply -f manifests/
