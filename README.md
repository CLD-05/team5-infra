# PetCareLog (team5-infra)

## 프로젝트 소개

`team5-infra`는 PetCareLog 서비스의 AWS 클라우드 인프라를 Terraform 기반 IaC(Infrastructure as Code) 방식으로 관리하기 위한 레포지토리입니다.

본 프로젝트는 AWS 환경에서 EKS 기반의 컨테이너 플랫폼을 구축하고, GitHub Actions 기반 CI/CD와 모듈화된 Terraform 구조를 적용하여 협업 중심의 클라우드 인프라 환경을 구성하는 것을 목표로 합니다.

주요 목표는 다음과 같습니다.

- Terraform 기반 인프라 자동화
- AWS EKS 기반 Kubernetes 환경 구축
- GitHub Actions 기반 CI/CD 구성
- dev / prod 환경 분리
- Terraform Module 기반 구조화
- 팀 단위 협업을 위한 Git 브랜치 전략 적용

---

# 시스템 아키텍처

## Overview

`team5-infra`는 PetCareLog 프로젝트의 AWS 클라우드 인프라를 Terraform 기반 IaC(Infrastructure as Code) 방식으로 관리하기 위한 레포지토리입니다.

이 프로젝트는 AWS 환경에서 다음과 같은 목표를 기반으로 설계되었습니다.

- Terraform 기반 인프라 자동화
- EKS 기반 컨테이너 오케스트레이션
- GitHub Actions 기반 CI/CD 구성
- 환경(dev/prod) 분리
- 모듈화된 Terraform 구조 적용
- 협업 중심 Git 브랜치 전략 사용

---

# Project Architecture

## Infrastructure Stack

- AWS VPC
- Public / Private Subnet
- NAT Gateway
- ECR
- GitHub OIDC
- EKS Cluster
- EKS Managed Node Group
- IAM Role / Policy
- Security Group
- RDS
- Bastion Host (dev only)
- SSM Session Manager (prod)

---

# Repository Structure

```text
team5-infra
├── envs
│   ├── dev
│   └── prod
│
├── modules
│   ├── ecr
│   ├── eks
│   ├── eks-addons
│   ├── github-oidc-role
│   ├── iam
│   ├── network
│   └── security-group
│
└── .gitignore
```

---

# Environment Configuration

## dev

- Purpose: Development / Test
- NAT Gateway: 1
- Bastion Host: Enabled
- EKS Node Group
  - desired: 2
  - min: 1
  - max: 3
  - instance type: t3.medium

## prod

- Purpose: Production
- NAT Gateway: 2
- Bastion Host: Disabled
- SSM Session Manager 사용
- EKS Node Group
  - desired: 2
  - min: 2
  - max: 4
  - instance type: t3.medium

---

# Naming Convention

모든 AWS 리소스는 아래 규칙을 사용합니다.

```text
team5-${project_name}-${environment}-${resource_type}
```

Example:

```text
team5-petcarelog-dev-vpc
team5-petcarelog-dev-eks
team5-petcarelog-dev-rds
```

---

# Terraform Common Locals

```hcl
locals {
  name_prefix = "team5-${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Team        = "team5"
  }
}
```

---

# Network Configuration

## VPC CIDR

```text
10.0.0.0/16
```

## dev subnet

```text
public:
- 10.0.1.0/24
- 10.0.2.0/24

private app:
- 10.0.11.0/24
- 10.0.12.0/24

private db:
- 10.0.21.0/24
- 10.0.22.0/24
```

## prod subnet

```text
public:
- 10.0.100.0/24
- 10.0.101.0/24

private app:
- 10.0.110.0/24
- 10.0.111.0/24

private db:
- 10.0.130.0/24
- 10.0.131.0/24
```

---

# Stack

| Category      | Technology           |
| ------------- | -------------------- |
| IaC           | Terraform            |
| Cloud         | AWS                  |
| Container     | Docker               |
| Orchestration | Kubernetes / EKS     |
| CI/CD         | GitHub Actions       |
| Registry      | Amazon ECR           |
| Monitoring    | Prometheus / Grafana |

---



