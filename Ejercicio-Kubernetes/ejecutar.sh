#!/bin/bash

kubectl apply -f namespace.yaml
kubectl apply -f backend-deploy.yaml
kubectl apply -f frontend-deploy.yaml
#kubectl apply -f grafana-deploy.yaml
#kubectl apply -f prometheus-deploy.yaml
#kubectl apply -f pyg-config.yaml
#kubectl apply -f pyg-pvc.yaml
