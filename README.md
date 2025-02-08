# 📌 StockPNL Infrastructure

### 📖 Overview

This repository contains the Terraform code to deploy and manage the StockPNL infrastructure on AWS. It provisions an EKS cluster, manages IAM roles, and installs AWS EBS CSI Driver for persistent storage. It follows GitOps principles, ensuring declarative infrastructure management.

## 🚀 Deployment Steps

1️⃣ Configure AWS CLI & Connect to Cluster

##### Ensure you are authenticated with AWS and set up the necessary access permissions:
```
aws eks update-kubeconfig --region eu-north-1 --name stockpnl
```

2️⃣ Initialize & Apply Terraform
```
terraform init
terraform apply -auto-approve
```

### This deploys:

- AWS EKS Cluster
- IAM roles for EKS & EBS CSI
- AWS EBS CSI Driver via Helm

### 🔍 Verifying Components
Check EKS Cluster:
```
kubectl get nodes
```

Verify EBS CSI Driver
```
kubectl get pods -n kube-system | grep ebs
```
Check Installed Helm Releases
```
helm list -A
```

🛠️ Structure of the Repository
```
.
├── tf/                          # Root Terraform module
│   ├── main.tf                  # Calls all sub-modules
│   ├── outputs.tf               # Outputs for the entire stack
│   ├── vars.tf                  # Variables used in the root module
│   └── README.md                 # This file
│
├── modules/
│   ├── eks/                     # EKS Cluster Terraform module
│   │   ├── main.tf
│   │   ├── vars.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   ├── nodegroup/               # Node group module
│   │   ├── main.tf
│   │   ├── vars.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   ├── ebs_csi_driver/          # EBS CSI Driver Terraform module
│   │   ├── main.tf
│   │   ├── vars.tf
│   │   ├── outputs.tf
│   │   └── README.md
│
├── .github/workflows/           # CI/CD pipelines for automation
│   ├── tf-tests.yaml
│
└── README.md                    # Project documentation
```

## 🔥 Troubleshooting

>IAM Role Already Exists Error

If you see EntityAlreadyExists: Role with name EBSCSIControllerRole already exists, delete the role manually:
```
aws iam list-attached-role-policies --role-name EBSCSIControllerRole
aws iam detach-role-policy --role-name EBSCSIControllerRole --policy-arn <policy-arn>
aws iam delete-role --role-name EBSCSIControllerRole
```

Then re-run Terraform:
```
terraform apply -auto-approve
```

>Cannot Delete EKS Cluster

Ensure that all node groups and dependencies are deleted first:
```
aws eks delete-cluster --name stockpnl
```

## 🎯 Future Improvements
- Implement ArgoCD for full GitOps-based deployment.
- Set up AWS Secrets Manager integration with External Secrets Operator.

## 📜 License

This repository is licensed under the MIT License. See LICENSE for details.

aws eks update-kubeconfig --region eu-north-1 --name stockpnl