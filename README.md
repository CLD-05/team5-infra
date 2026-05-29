# PetCareLog Infrastructure

> Terraform 기반 AWS Infrastructure as Code Repository

PetCareLog는 애플리케이션 코드, 인프라 코드, Kubernetes 배포 설정을 각각 분리하여 관리합니다.

- `team5-app`
  - Spring Boot 애플리케이션 및 CI Workflow 관리
- `team5-infra`
  - Terraform 기반 AWS 인프라 관리
- `team5-config`
  - Kubernetes Manifest 및 Argo CD GitOps 설정 관리

`team5-infra`는 PetCareLog 서비스 운영을 위한 AWS 클라우드 인프라를 Terraform 기반 IaC(Infrastructure as Code) 방식으로 관리하는 레포지토리입니다.

------

# 1. Infrastructure Overview

PetCareLog Infrastructure는 다음 목표를 기반으로 설계되었습니다.

- Terraform 기반 Infrastructure as Code
- Multi Environment 구조 (management / dev / prod)
- EKS 기반 Kubernetes 플랫폼 구성
- GitHub Actions + Argo CD 기반 GitOps 운영 구조
- Prometheus + Grafana 기반 모니터링 환경 구성
- HPA 기반 Auto Scaling 환경 구성
- Terraform Module 기반 재사용 가능한 구조 설계

------

# 2. Architecture

```text
GitHub Actions
        ↓
      Amazon ECR
        ↓
   Argo CD (management EKS)
        ↓
 ┌───────────────┬───────────────┐
 │               │               │
dev EKS       prod EKS      Monitoring
 │               │
PetCareLog    PetCareLog
Application   Application
```

------

# 3. 환경 구성

PetCareLog Infrastructure는 `management`, `dev`, `prod`
3개의 환경으로 분리되어 있습니다.

## 3.1 management

management 환경은 GitOps 운영을 위한 관리 클러스터입니다.

주요 역할:

- Argo CD 운영
- dev/prod EKS 클러스터 관리
- ApplicationSet 기반 GitOps 배포
- Monitoring Stack 배포 관리

------

## 3.2 dev

dev 환경은 개발 및 테스트 환경입니다.

주요 역할:

- 개발 브랜치 기반 애플리케이션 배포
- 기능 테스트
- 모니터링 검증
- HPA 부하 테스트
- Kubernetes 운영 테스트

------

## 3.3 prod

prod 환경은 실제 운영 환경입니다.

주요 역할:

- main 브랜치 기반 운영 배포
- 운영용 RDS / Redis / S3 사용
- 운영 모니터링
- Route53 / ACM 기반 도메인 연결

------

# 4. AWS Infrastructure Components

`team5-infra`는 다음 AWS 리소스를 Terraform으로 관리합니다.

## Networking

- VPC
- Public Subnet
- Private App Subnet
- Private DB Subnet
- Internet Gateway
- NAT Gateway
- Route Table

## Kubernetes

- Amazon EKS
- EKS Managed Node Group
- EKS Add-ons
- AWS Load Balancer Controller

## Database & Storage

- Amazon RDS MySQL
- Amazon ElastiCache Redis
- Amazon S3

## Security & IAM

- IAM Role / Policy
- GitHub OIDC Provider
- GitHub OIDC Role
- IRSA (IAM Roles for Service Accounts)
- Security Group
- SSM Parameter Store

## Monitoring

- Prometheus
- Grafana
- kube-state-metrics
- node-exporter

------

# 5. 네트워크 구조

각 환경은 별도의 VPC를 사용합니다.

```text
Internet
    ↓
Application Load Balancer
    ↓
EKS Worker Node / Pod
    ↓
RDS / Redis / S3
```

## Public Subnet

- ALB
- NAT Gateway

## Private App Subnet

- EKS Worker Node
- Application Pod
- Monitoring Pod

## Private DB Subnet

- RDS
- ElastiCache Redis

Private App Subnet의 리소스는 NAT Gateway를 통해 외부 통신을 수행합니다.

예시:

- ECR Image Pull
- AWS API 호출
- 외부 패키지 다운로드

------

# 6. Terraform 구조

```text
team5-infra
├── envs
│   ├── management
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   │
│   ├── dev
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   │
│   └── prod
│       ├── main.tf
│       ├── provider.tf
│       ├── backend.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
│
└── modules
    ├── network
    ├── security-group
    ├── iam
    ├── eks
    ├── eks-addons
    ├── ecr
    ├── rds
    ├── elasticache
    ├── s3
    ├── github-oidc-provider
    ├── github-oidc-role
    ├── irsa
    └── ssm-parameter
```

Terraform Module 구조를 사용하여 네트워크, EKS, IAM, RDS 등의 리소스를 재사용 가능하도록 구성했습니다.

------

# 7. Monitoring & Observability

PetCareLog는 Prometheus + Grafana 기반 모니터링 환경을 사용합니다.

구성 요소: 

- kube-prometheus-stack
- Prometheus
- Grafana
- Alertmanager
- kube-state-metrics
- node-exporter

모니터링 대상:

- EKS Node CPU / Memory
- Pod Resource Usage
- JVM Metrics
- HTTP Request Metrics
- HPA Scaling 상태



------

# 10. Infrastructure Provisioning

각 환경은 Terraform state를 분리하여 관리합니다.

## Terraform 실행 순서

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

------

## AWS Profile 설정

```bash
export AWS_PROFILE=project2
```

Windows PowerShell:

```powershell
$env:AWS_PROFILE="project2"
```

현재 AWS 계정 확인:

```bash
aws sts get-caller-identity
```

------

# 11. EKS Access

## kubeconfig 설정

### management

```bash
aws eks update-kubeconfig \
  --region ap-northeast-2 \
  --name team5-petcarelog-management-eks \
  --profile project2
```

### dev

```bash
aws eks update-kubeconfig \
  --region ap-northeast-2 \
  --name team5-petcarelog-dev-eks \
  --profile project2
```

### prod

```bash
aws eks update-kubeconfig \
  --region ap-northeast-2 \
  --name team5-petcarelog-prod-eks \
  --profile project2
```

연결 확인:

```bash
kubectl get nodes
```

------

## 12. Argo CD 연동 흐름

각 환경의 EKS 구축이 완료된 뒤, management EKS에 설치된 Argo CD에서 dev/prod 클러스터를 등록합니다.

```bash
argocd cluster add arn:aws:eks:ap-northeast-2:<ACCOUNT_ID>:cluster/team5-petcarelog-dev-eks
```

```bash
argocd cluster add arn:aws:eks:ap-northeast-2:<ACCOUNT_ID>:cluster/team5-petcarelog-prod-eks
```

등록 확인:

```bash
argocd cluster list
```

이후 `team5-config` 레포의 AppProject와 ApplicationSet을 management EKS에 적용하여 dev/prod 애플리케이션과 모니터링 스택을 GitOps 방식으로 배포합니다.

```bash
kubectl apply -f argocd/projects/
kubectl apply -f argocd/applicationsets/
```

Argo CD Application 확인:

```bash
kubectl get applications -n argocd
```

정상 상태 예시:

```text
petcarelog-dev          Synced    Healthy
petcarelog-prod         Synced    Healthy
monitoring-crds-dev     Synced    Healthy
monitoring-crds-prod    Synced    Healthy
monitoring-dev          Synced    Healthy
monitoring-prod         Synced    Healthy
```

------



# 13. 보안 주의사항

GitHub에 업로드하지 않는 파일:

- `terraform.tfvars`
- `.terraform/`
- `*.tfstate`
- AWS Access Key
- AWS Secret Access Key
- kubeconfig
- PEM Key
- Secret 파일

예시 파일만 GitHub에 포함합니다.

```text
terraform.tfvars.example
secret.example.yaml
```

------

## 11. 관련 레포지토리

| 레포지토리   | 역할                                                         |
| ------------ | ------------------------------------------------------------ |
| team5-app    | Spring Boot 애플리케이션 코드 및 CI Workflow                 |
| team5-infra  | Terraform 기반 AWS 인프라 코드                               |
| team5-config | Kubernetes 매니페스트, Argo CD ApplicationSet, 모니터링 설정 |
