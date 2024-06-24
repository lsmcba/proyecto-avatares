#!/bin/bash

kubectl apply -f namespace.yaml
kubectl apply -f backend-deploy.yaml
kubectl apply -f frontend-deploy.yaml
kubectl apply -f ingress.yaml
