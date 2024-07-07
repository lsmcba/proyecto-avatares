#!/bin/bash

kubectl apply -f namespace.yaml
kubectl apply -f backend-deploy.yaml
kubectl apply -f frontend-deploy.yaml
kubectl apply -f grafana-deploy.yaml
kubectl apply -f prometheus-deploy.yaml
kubectl apply -f kube-metric-deploy2.yaml
kubectl apply -f cluster-role.yaml
kubectl apply -f cluster-role-binding.yaml
kubectl apply -f service-account.yaml


