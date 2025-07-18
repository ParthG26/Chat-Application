# Chatapp-Deployment-Using-Jenkins-Kubenetes-ArgoCD
ChatApp Deployment using Kubernetes, CI using Jenkins, CD using ArgoCD
ChatApp is deployed through Jenkins who will pull code from Github repository and use the Dockerfile to build and image which will then be pushed into ECR.
The image url will be changed in the github repository manifest through pipeline.
This chnage will be seen by ArgoCD who will deploy the application in the K8s cluster
