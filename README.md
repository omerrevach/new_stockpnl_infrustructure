# StockPNL Infrastructure

## Overview

This repository contains the **Terraform code** to deploy and manage the **StockPNL infrastructure** on AWS. It provisions an **Amazon EKS cluster**, manages IAM roles, and installs necessary controllers such as **AWS Load Balancer Controller** and **Contour Ingress Controller** for efficient traffic management.

Additionally, this setup **integrates External Secrets Operator** with **AWS Secrets Manager**, allowing Kubernetes to securely manage secrets from AWS, ensuring sensitive configurations like database credentials and API keys are dynamically updated.

This setup follows **GitOps principles**, ensuring declarative infrastructure management and automation using Terraform and Helm.

---

## Deployment Steps

### 1️ Configure AWS CLI & Connect to Cluster
Ensure you are authenticated with AWS and set up the necessary access permissions:
```sh
terraform init
terraform apply -auto-approve
aws eks update-kubeconfig --region eu-north-1 --name stockpnl
```

## This deploys:
* Amazon EKS Cluster – Fully managed Kubernetes cluster.
* IAM roles & policies – Required permissions for Kubernetes components.
* AWS EBS CSI Driver – Persistent storage solution for EKS.
* AWS Load Balancer Controller – For provisioning and managing AWS ALB/NLB.
* Contour Ingress Controller – For handling ingress traffic efficiently.

## AWS Load Balancer Controller (ALB Controller)

The AWS Load Balancer Controller manages AWS Application Load Balancers (ALB) and Network Load Balancers (NLB) for Kubernetes applications. It automatically provisions ALBs when Kubernetes Ingress resources are deployed.

Why Use It?

* Automatically creates and manages ALB/NLB in AWS.
* Ensures secure routing and traffic control.
* Enables features like SSL termination, URL path-based routing, and WAF integration.


## Contour Ingress Controller

Contour is a high-performance ingress controller designed for managing traffic to Kubernetes workloads. It uses Envoy Proxy to provide dynamic traffic routing, TLS termination, and HTTP/2 support.

Why Use It?

* Provides advanced traffic management with high performance.
* Works well with AWS ALB for external ingress and internal routing.
* Supports multi-tenant applications with delegation capabilities.


## Future Improvements

* Implement ArgoCD for full GitOps-based deployment.
* Set up AWS Secrets Manager integration with External Secrets Operator.
* Add service mesh support using Istio or Linkerd.

## License

This repository is licensed under the MIT License. See LICENSE for details.


