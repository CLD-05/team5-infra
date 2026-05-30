# PetCareLog Infra

> PetCareLog 서비스를 운영하기 위한 **AWS 인프라를 Terraform으로 관리하는 IaC 저장소**입니다.  
> VPC, EKS, RDS, ElastiCache, S3, ECR, IAM, GitHub OIDC, IRSA, Bastion 등 dev/prod/management 환경의 핵심 인프라를 코드로 구성합니다.  
> 애플리케이션 진입점인 Application Load Balancer는 Kubernetes Ingress를 기반으로 AWS Load Balancer Controller가 동적으로 생성합니다.

<br>

## 📌 프로젝트 개요

`team5-infra`는 PetCareLog 프로젝트의 AWS 인프라를 선언적으로 관리하기 위한 Terraform 저장소입니다.

PetCareLog 프로젝트는 애플리케이션, 인프라, Kubernetes 배포 설정을 각각 분리하여 관리합니다.

| 저장소 | 역할 |
|---|---|
| [`team5-app`](https://github.com/CLD-05/team5-app) | Spring Boot 애플리케이션, Dockerfile, GitHub Actions |
| [`team5-infra`](https://github.com/CLD-05/team5-infra) | Terraform 기반 AWS 인프라 관리 |
| [`team5-config`](https://github.com/CLD-05/team5-config) | Kubernetes Manifest, Argo CD GitOps 배포 설정 |


<br>

<a id="toc"></a>

## 목차

- [프로젝트 개요](#-프로젝트-개요)
- [인프라 화면](#-인프라-화면)
- [전체 아키텍처](#-전체-아키텍처)
- [환경 분리 전략](#-환경-분리-전략)
- [주요 AWS 리소스](#-주요-aws-리소스)
- [Terraform 생성 리소스와 동적 생성 리소스](#-terraform-생성-리소스와-동적-생성-리소스)
- [기술 스택](#-기술-스택)
- [디렉토리 구조](#-디렉토리-구조)
- [사전 요구 사항](#-사전-요구-사항)
- [환경별 설정 파일](#-환경별-설정-파일)
- [설치 및 실행 방법](#-설치-및-실행-방법)
- [사용법](#-사용법)
- [Terraform 명령어](#-terraform-명령어)
- [네트워크 구조](#-네트워크-구조)
- [보안 구성](#-보안-구성)
- [CI/CD 연동](#cicd-연동)
- [운영 시 주의 사항](#-운영-시-주의-사항)
- [저자 및 기여자](#-저자-및-기여자)

<br>

## 🏗 전체 아키텍처

```text
Developer
   │
   │  git push
   ▼
GitHub Actions
   │
   │  OIDC Assume Role
   ▼
AWS IAM Role
   │
   │  Docker Image Push
   ▼
Amazon ECR
   │
   │  Image Pull
   ▼
Amazon EKS
   │
   ├── dev EKS
   │     └── PetCareLog Dev Application
   │
   ├── prod EKS
   │     └── PetCareLog Prod Application
   │
   └── management EKS
         └── Argo CD
```

<br>

### AWS 리소스 흐름

```text
Internet
   │
   ▼
Route 53 / Domain
   │
   ▼
Application Load Balancer
   │
   │  생성 주체: AWS Load Balancer Controller
   ▼
Kubernetes Ingress
   │
   ▼
Kubernetes Service
   │
   ▼
PetCareLog Pod
   │
   ├── RDS MySQL
   ├── ElastiCache Redis
   └── S3 Image Bucket
```

> Application Load Balancer는 Terraform이 직접 생성하지 않고, `team5-config`의 Kubernetes Ingress 리소스를 기반으로 AWS Load Balancer Controller가 동적으로 생성합니다.

<br>

## 🌱 환경 분리 전략

이 저장소는 `management`, `dev`, `prod` 3개의 환경으로 분리되어 있습니다.

| 환경 | 목적 | 주요 특징 |
|---|---|---|
| `management` | 운영 관리용 환경 | Argo CD 운영, dev/prod 배포 관리 |
| `dev` | 개발 및 테스트 환경 | 기능 테스트, HPA 테스트, Bastion 사용 |
| `prod` | 운영 환경 | Multi-AZ 기반 안정성, 운영용 RDS/Redis/S3 사용 |

<br>

### ▶ management 환경

`management` 환경은 GitOps 운영을 위한 관리 클러스터입니다.

주요 역할:

- Argo CD 설치 및 운영
- dev/prod 애플리케이션 배포 관리
- ApplicationSet 기반 GitOps 구성
- 운영 도구 배포 관리

<br>

### ▶ dev 환경

`dev` 환경은 개발 및 검증을 위한 환경입니다.

주요 역할:

- dev 브랜치 기반 애플리케이션 배포
- 기능 테스트
- Kubernetes 배포 검증
- HPA 부하 테스트
- Bastion을 통한 RDS 접근 테스트

<br>

### ▶ prod 환경

`prod` 환경은 실제 운영 환경입니다.

주요 역할:

- main 브랜치 기반 운영 배포
- 운영용 RDS, Redis, S3 사용
- Route 53 기반 도메인 연결
- 운영 모니터링 및 안정성 검증

<br>

## ☁️ 주요 AWS 리소스

| 구분 | 리소스 | 생성 주체 | 설명 |
|---|---|---|---|
| Network | VPC | Terraform | 환경별 독립 네트워크 |
| Network | Public Subnet | Terraform | NAT Gateway와 ALB가 배치되는 서브넷 |
| Network | Private App Subnet | Terraform | EKS Worker Node가 배치되는 서브넷 |
| Network | Private DB Subnet | Terraform | RDS, ElastiCache가 배치되는 서브넷 |
| Network | Internet Gateway | Terraform | Public Subnet의 외부 인터넷 연결 |
| Network | NAT Gateway | Terraform | Private Subnet의 외부 통신 |
| Network | Elastic IP | Terraform | NAT Gateway에 연결되는 고정 Public IP |
| Load Balancing | Application Load Balancer | AWS Load Balancer Controller | Kubernetes Ingress를 기반으로 동적 생성 |
| Compute | Amazon EKS | Terraform | Kubernetes 클러스터 |
| Compute | EKS Managed Node Group | Terraform | 애플리케이션 Pod 실행 노드 |
| Database | Amazon RDS MySQL | Terraform | 애플리케이션 데이터 저장 |
| Cache | Amazon ElastiCache Redis | Terraform | 세션 저장소 |
| Storage | Amazon S3 | Terraform | 반려동물 이미지 저장 |
| Registry | Amazon ECR | Terraform | Docker 이미지 저장소 |
| Security | IAM Role / Policy | Terraform | AWS 리소스 권한 관리 |
| Security | GitHub OIDC | Terraform | GitHub Actions의 AWS 인증 |
| Security | IRSA | Terraform | Kubernetes ServiceAccount 기반 AWS 권한 부여 |
| Security | Security Group | Terraform | 리소스 간 네트워크 접근 제어 |
| Access | Bastion Host | Terraform | dev 환경 DB 접근용 EC2 |

<br>

## 🔄 Terraform 생성 리소스와 동적 생성 리소스

이 저장소의 Terraform 코드는 VPC, Subnet, NAT Gateway, Security Group, RDS, ElastiCache, S3, ECR, EKS 등 핵심 AWS 인프라를 생성합니다.

반면 애플리케이션 외부 진입점인 Application Load Balancer는 Terraform이 직접 생성하지 않습니다.  
`team5-config` 저장소의 Kubernetes Ingress 리소스가 EKS에 적용되면, AWS Load Balancer Controller가 Ingress 설정을 읽고 ALB를 동적으로 생성합니다.

```text
Terraform
  ├── VPC / Subnet / Route Table / Internet Gateway
  ├── NAT Gateway / Elastic IP
  ├── Security Group
  ├── EKS Cluster / Node Group
  ├── RDS MySQL
  ├── ElastiCache Redis
  ├── S3 Bucket
  └── ECR Repository

Kubernetes + AWS Load Balancer Controller
  └── Ingress 기반 Application Load Balancer 동적 생성
```

> NAT Gateway에 연결되는 Elastic IP는 Terraform으로 생성 및 관리합니다.  
> Application Load Balancer는 AWS Load Balancer Controller가 동적으로 생성하며, 일반적인 ALB는 고정 Elastic IP를 직접 할당해 관리하지 않습니다.

<br>

## 🛠 기술 스택

| 구분 | 기술 |
|---|---|
| IaC | Terraform |
| Cloud Provider | AWS |
| Container Orchestration | Amazon EKS, Kubernetes |
| Container Registry | Amazon ECR |
| Database | Amazon RDS for MySQL |
| Cache | Amazon ElastiCache for Redis |
| Storage | Amazon S3 |
| Authentication | GitHub OIDC |
| Access Control | IAM, IRSA, Security Group |
| State Backend | S3 Backend, DynamoDB Lock |
| GitOps | Argo CD |
| Monitoring | Prometheus, Grafana |

<br>

## 📁 디렉토리 구조

```text
team5-infra
├── envs
│   ├── management
│   │   ├── backend.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars.example
│   │   ├── variables.tf
│   │   └── versions.tf
│   │
│   ├── dev
│   │   ├── backend.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars.example
│   │   ├── variables.tf
│   │   └── versions.tf
│   │
│   └── prod
│       ├── backend.tf
│       ├── locals.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
│       ├── terraform.tfvars.example
│       ├── variables.tf
│       └── versions.tf
│
└── modules
    ├── bastion
    ├── ecr
    ├── eks
    ├── eks-addons
    ├── elasticache
    ├── github-oidc-provider
    ├── github-oidc-role
    ├── iam
    ├── irsa-alb-controller
    ├── irsa-app-s3
    ├── network
    ├── rds
    ├── s3
    └── security-group
```

<br>

### ▶ envs 디렉토리

`envs`는 실제 환경별 Terraform 실행 단위입니다.

| 디렉토리 | 설명 |
|---|---|
| `envs/management` | Argo CD 운영용 관리 클러스터 인프라 |
| `envs/dev` | 개발 및 테스트용 인프라 |
| `envs/prod` | 운영용 인프라 |

<br>

### ▶ modules 디렉토리

`modules`는 재사용 가능한 Terraform 모듈을 관리합니다.

| 모듈 | 설명 |
|---|---|
| `network` | VPC, Subnet, Route Table, IGW, NAT Gateway |
| `security-group` | ALB, EKS, RDS, Redis, Bastion 보안 그룹 |
| `iam` | EKS Cluster Role, Node Role |
| `eks` | EKS Cluster, Managed Node Group |
| `eks-addons` | VPC CNI, CoreDNS, kube-proxy, Pod Identity Agent |
| `ecr` | ECR Repository |
| `rds` | RDS MySQL |
| `elasticache` | ElastiCache Redis |
| `s3` | 이미지 저장용 S3 Bucket |
| `bastion` | dev 환경 Bastion Host |
| `github-oidc-provider` | GitHub OIDC Provider |
| `github-oidc-role` | GitHub Actions용 IAM Role |
| `irsa-alb-controller` | AWS Load Balancer Controller용 IRSA |
| `irsa-app-s3` | 애플리케이션 S3 접근용 IRSA |

<br>

## ✅ 사전 요구 사항

Terraform을 실행하기 전에 다음 도구와 설정이 필요합니다.

| 항목 | 권장 버전 / 조건 | 설명 |
|---|---|---|
| Terraform | 1.x | AWS 인프라 생성 |
| AWS CLI | v2 | AWS 인증 및 리소스 확인 |
| kubectl | EKS 버전과 호환 | EKS 클러스터 접근 |
| Helm | 3.x | AWS Load Balancer Controller, 모니터링 설치 시 사용 |
| Git | 최신 버전 | 저장소 관리 |
| AWS 계정 | 관리자 또는 필요한 IAM 권한 | Terraform 리소스 생성 |
| S3 Backend Bucket | 사전 생성 필요 | Terraform state 저장 |
| DynamoDB Lock Table | 사전 생성 필요 | Terraform state lock 관리 |

<br>

### AWS CLI 프로필 설정

팀 프로젝트에서는 Terraform provider에 AWS CLI profile을 하드코딩하지 않고, 실행하는 사람이 로컬에서 자신의 프로필을 지정하는 방식을 권장합니다.

```bash
aws configure --profile 프로파일명
```

Terraform 실행 시에는 다음과 같이 프로필을 지정합니다.

```bash
AWS_PROFILE=프로파일명 terraform plan
AWS_PROFILE=프로파일명 terraform apply
```

Windows PowerShell에서는 다음과 같이 사용할 수 있습니다.

```powershell
$env:AWS_PROFILE="프로파일명"
terraform plan
terraform apply
```

<br>

## ⚙️ 환경별 설정 파일

각 환경은 `terraform.tfvars.example`을 복사하여 `terraform.tfvars`를 만든 뒤, 실제 값에 맞게 수정합니다.

```bash
cp terraform.tfvars.example terraform.tfvars
```

Windows PowerShell:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

<br>

### ▶ 공통 설정

| 변수 | 설명 | 예시 |
|---|---|---|
| `aws_region` | AWS 리전 | `ap-northeast-2` |
| `project_name` | 프로젝트 이름 | `petcarelog` |
| `environment` | 환경 이름 | `dev`, `prod`, `management` |
| `availability_zones` | 사용할 AZ 목록 | `ap-northeast-2a`, `ap-northeast-2c` |

<br>

### ▶ GitHub / CI 설정

| 변수 | 설명 | 예시 |
|---|---|---|
| `github_owner` | GitHub Owner 또는 Organization | `CLD-05` |
| `github_repo` | 애플리케이션 저장소 이름 | `team5-app` |
| `github_branch` | 배포 대상 브랜치 | `dev`, `main` |

<br>

### ▶ 네트워크 설정

| 변수 | 설명 |
|---|---|
| `vpc_cidr` | VPC CIDR |
| `public_subnet_cidrs` | Public Subnet CIDR 목록 |
| `private_app_subnet_cidrs` | EKS Node용 Private Subnet CIDR 목록 |
| `private_db_subnet_cidrs` | RDS/Redis용 Private DB Subnet CIDR 목록 |
| `enable_nat_gateway` | NAT Gateway 생성 여부 |
| `single_nat_gateway` | NAT Gateway 1개만 사용할지 여부 |

<br>

### ▶ RDS 설정

| 변수 | 설명 |
|---|---|
| `db_engine` | DB 엔진 |
| `db_engine_version` | DB 엔진 버전 |
| `db_instance_class` | RDS 인스턴스 타입 |
| `db_allocated_storage` | 스토리지 크기 |
| `db_name` | 데이터베이스 이름 |
| `db_username` | DB 사용자명 |
| `db_password` | DB 비밀번호 |
| `db_multi_az` | Multi-AZ 사용 여부 |
| `db_publicly_accessible` | Public Access 여부 |
| `db_deletion_protection` | 삭제 방지 여부 |

<br>

### ▶ EKS 설정

| 변수 | 설명 |
|---|---|
| `eks_cluster_version` | EKS 버전 |
| `eks_endpoint_public_access` | Public Endpoint 사용 여부 |
| `eks_endpoint_private_access` | Private Endpoint 사용 여부 |
| `node_group_instance_types` | Worker Node 인스턴스 타입 |
| `node_group_desired_size` | 기본 Node 수 |
| `node_group_min_size` | 최소 Node 수 |
| `node_group_max_size` | 최대 Node 수 |
| `node_group_disk_size` | Node 디스크 크기 |

<br>

### ▶ ElastiCache 설정

| 변수 | 설명 |
|---|---|
| `redis_node_type` | Redis 노드 타입 |
| `redis_engine_version` | Redis 엔진 버전 |
| `redis_port` | Redis 포트 |
| `redis_num_cache_clusters` | Redis 노드 수 |
| `redis_multi_az_enabled` | Multi-AZ 사용 여부 |
| `redis_automatic_failover_enabled` | 자동 장애 조치 사용 여부 |
| `redis_at_rest_encryption_enabled` | 저장 데이터 암호화 여부 |
| `redis_transit_encryption_enabled` | 전송 구간 암호화 여부 |

<br>

## 🚀 설치 및 실행 방법

### 1. 저장소 클론

```bash
git clone https://github.com/CLD-05/team5-infra.git
cd team5-infra
```

<br>

### 2. 환경 디렉토리로 이동

dev 환경:

```bash
cd envs/dev
```

prod 환경:

```bash
cd envs/prod
```

management 환경:

```bash
cd envs/management
```

<br>

### 3. terraform.tfvars 생성

```bash
cp terraform.tfvars.example terraform.tfvars
```

생성한 `terraform.tfvars`에서 DB 비밀번호, Bastion 접속 허용 IP, Key Pair 이름 등 환경별 값을 수정합니다.

<br>

### 4. Terraform 초기화

```bash
AWS_PROFILE=프로파일명 terraform init
```

<br>

### 5. 코드 포맷 및 검증

```bash
terraform fmt -recursive
terraform validate
```

<br>

### 6. 실행 계획 확인

```bash
AWS_PROFILE=프로파일명 terraform plan
```

<br>

### 7. 인프라 생성

```bash
AWS_PROFILE=프로파일명 terraform apply
```

<br>

## 🧭 사용법

### dev 환경 생성

```bash
cd envs/dev
AWS_PROFILE=프로파일명 terraform init
AWS_PROFILE=프로파일명 terraform plan
AWS_PROFILE=프로파일명 terraform apply
```

<br>

### prod 환경 생성

```bash
cd envs/prod
AWS_PROFILE=프로파일명 terraform init
AWS_PROFILE=프로파일명 terraform plan
AWS_PROFILE=프로파일명 terraform apply
```

<br>

### management 환경 생성

```bash
cd envs/management
AWS_PROFILE=프로파일명 terraform init
AWS_PROFILE=프로파일명 terraform plan
AWS_PROFILE=프로파일명 terraform apply
```

<br>

### EKS kubeconfig 설정

Terraform으로 EKS 생성 후, AWS CLI를 통해 kubeconfig를 업데이트합니다.

dev:

```bash
aws eks update-kubeconfig \
  --region ap-northeast-2 \
  --name team5-petcarelog-dev-eks \
  --profile 프로파일명
```

prod:

```bash
aws eks update-kubeconfig \
  --region ap-northeast-2 \
  --name team5-petcarelog-prod-eks \
  --profile 프로파일명
```

management:

```bash
aws eks update-kubeconfig \
  --region ap-northeast-2 \
  --name team5-petcarelog-management-eks \
  --profile 프로파일명
```

<br>

### 현재 Kubernetes Context 확인

```bash
kubectl config get-contexts
kubectl config current-context
```

<br>

## 🧾 Terraform 명령어

| 명령어 | 설명 |
|---|---|
| `terraform init` | Terraform Backend 및 Provider 초기화 |
| `terraform fmt -recursive` | Terraform 코드 포맷 정리 |
| `terraform validate` | Terraform 코드 문법 검증 |
| `terraform plan` | 생성/수정/삭제될 리소스 미리 확인 |
| `terraform apply` | 인프라 생성 또는 변경 적용 |
| `terraform output` | Terraform Output 확인 |
| `terraform destroy` | 인프라 삭제 |

<br>

### Output 확인 예시

```bash
terraform output
terraform output rds_endpoint
terraform output redis_primary_endpoint_address
terraform output bucket_name
```

<br>

### 특정 리소스만 적용해야 하는 경우

일반적으로 `-target` 사용은 권장하지 않습니다.  
다만 문제 해결이 필요한 경우에만 제한적으로 사용합니다.

```bash
terraform apply -target=module.eks
```

<br>

## 🌐 네트워크 구조

각 환경은 별도의 VPC를 사용합니다.

| 환경 | VPC CIDR | NAT Gateway 전략 |
|---|---|---|
| `dev` | `10.0.0.0/16` | 비용 절감을 위해 Single NAT Gateway |
| `prod` | `10.1.0.0/16` | 가용성을 위해 AZ별 NAT Gateway |
| `management` | `10.2.0.0/16` | 비용 절감을 위해 Single NAT Gateway |

<br>

### ▶ Subnet 구성

```text
VPC
├── Public Subnet
│   ├── NAT Gateway
│   └── Application Load Balancer
│       └── AWS Load Balancer Controller가 Ingress 기반으로 동적 생성
│
├── Private App Subnet
│   ├── EKS Worker Node
│   └── PetCareLog Pod
│
└── Private DB Subnet
    ├── RDS MySQL
    └── ElastiCache Redis
```

<br>

### ▶ 네트워크 흐름

### 요청 흐름

```text
사용자
  ↓
Route 53
  ↓
Application Load Balancer
  ↓
Kubernetes Ingress
  ↓
Kubernetes Service
  ↓
PetCareLog Pod
  ↓
RDS MySQL / ElastiCache Redis / S3 Image Bucket
```

* 사용자는 Route 53에 연결된 도메인을 통해 서비스에 접근합니다.
* Application Load Balancer는 Terraform이 직접 생성하지 않고, Kubernetes Ingress를 기반으로 AWS Load Balancer Controller가 동적으로 생성합니다.
* Kubernetes Ingress는 외부 요청을 내부 Service로 라우팅합니다.
* Kubernetes Service는 실제 PetCareLog Pod로 트래픽을 전달합니다.
* PetCareLog Pod는 RDS MySQL, ElastiCache Redis, S3 Image Bucket과 통신합니다.
* NAT Gateway에 연결되는 Elastic IP는 Terraform이 생성하지만, Application Load Balancer는 일반적으로 고정 Elastic IP를 직접 할당해 관리하지 않습니다.

<br>

## 🔐 보안 구성

### ▶ Security Group

| Security Group | 주요 역할 |
|---|---|
| ALB SG | 외부 HTTP/HTTPS 요청 수신 |
| EKS Cluster SG | Kubernetes Control Plane 통신 |
| EKS Node SG | Node 및 Pod 통신 |
| RDS SG | EKS Node에서 MySQL 접근 허용 |
| ElastiCache SG | EKS Node에서 Redis 접근 허용 |
| Bastion SG | 허용된 관리자 IP에서 SSH 접근 허용 |

<br>

### ▶ IAM / IRSA

| 구성 | 설명 |
|---|---|
| EKS Cluster Role | EKS Control Plane 권한 |
| EKS Node Role | Worker Node 권한 |
| GitHub OIDC Role | GitHub Actions에서 AWS Role Assume |
| ALB Controller IRSA | AWS Load Balancer Controller 권한 |
| App S3 IRSA | 애플리케이션 Pod의 S3 접근 권한 |

<br>

### ▶ GitHub OIDC

GitHub Actions는 AWS Access Key를 직접 저장하지 않고, OIDC를 통해 AWS IAM Role을 Assume합니다.

```text
GitHub Actions
   ↓ OIDC Token
AWS IAM Role
   ↓
Amazon ECR Push
```

<br>

## 🔁 CI/CD 연동

이 저장소는 `team5-app`, `team5-config`와 함께 CI/CD 흐름을 구성합니다.

```text
1. 개발자가 team5-app에 push
2. GitHub Actions 실행
3. GitHub OIDC로 AWS IAM Role Assume
4. Docker 이미지 빌드
5. Amazon ECR에 이미지 Push
6. team5-config의 Kubernetes Manifest 이미지 태그 업데이트
7. Argo CD가 변경사항 감지
8. EKS에 애플리케이션 배포
```

<br>

### GitHub Actions에서 사용하는 Terraform 리소스

| 리소스 | 설명 |
|---|---|
| ECR Repository | Docker 이미지 저장 |
| GitHub OIDC Role | GitHub Actions AWS 인증 |
| IAM Policy | ECR Push 권한 부여 |

<br>

## ⚠️ 운영 시 주의 사항

### 1. 민감 정보 관리

`terraform.tfvars`에는 DB 비밀번호 등 민감 정보가 들어갈 수 있으므로 GitHub에 커밋하지 않습니다.

```text
terraform.tfvars
*.tfstate
*.tfstate.backup
.terraform/
```

위 파일과 디렉토리는 `.gitignore`에 포함하여 관리합니다.

<br>

### 2. Terraform State 관리

Terraform state는 S3 Backend에 저장하고, DynamoDB로 Lock을 관리합니다.

```text
S3 Bucket      : tfstate 저장
DynamoDB Table : 동시에 apply 되는 문제 방지
```

State 파일에는 리소스 정보와 민감 값이 포함될 수 있으므로 직접 공유하지 않습니다.

<br>

### 3. prod 환경 삭제 주의

prod 환경은 운영 안정성을 위해 다음 설정을 사용합니다.

| 항목 | prod 설정 |
|---|---|
| RDS Multi-AZ | 사용 |
| RDS Deletion Protection | 사용 |
| RDS Final Snapshot | 사용 |
| NAT Gateway | AZ별 생성 |

따라서 `terraform destroy` 실행 시 비용과 데이터 유실 가능성을 반드시 확인해야 합니다.

<br>

### 4. NAT Gateway 비용 주의

NAT Gateway는 생성되어 있는 동안 비용이 발생합니다.  
dev와 management 환경에서는 비용 절감을 위해 Single NAT Gateway 전략을 사용합니다.

<br>

### 5. ALB 동적 생성 주의

Application Load Balancer는 Terraform 코드에 직접 정의되어 있지 않습니다.  
`team5-config`의 Ingress 리소스가 EKS에 적용되면 AWS Load Balancer Controller가 ALB를 생성합니다.

따라서 ALB를 확인하거나 삭제할 때는 다음 두 가지를 함께 확인해야 합니다.

```bash
kubectl get ingress -A
kubectl describe ingress <ingress-name> -n <namespace>
```

AWS 콘솔에서는 EC2의 Load Balancers 메뉴에서 동적으로 생성된 ALB를 확인할 수 있습니다.

<br>

### 6. 리소스 생성 순서

권장 생성 순서는 다음과 같습니다.

```text
1. management
2. dev
3. prod
```

이후 `team5-config` 저장소에서 Argo CD와 Kubernetes Manifest를 적용합니다.

<br>

## 👥 저자 및 기여자

| 이름 | 역할 |
|---|---|
| 김유현 | 팀장 |
| 고윤성 | 팀원 |
| 이재윤 | 팀원 |
| 유관호 | 팀원 |
| 신솔미 | 팀원 |
| 김광호 | 팀원 |


<br>

## ✅ 참고 사항

- 이 저장소는 애플리케이션 소스 코드 저장소가 아니라 **인프라 코드 저장소**입니다.
- 애플리케이션 배포 manifest는 `team5-config`에서 관리합니다.
- 애플리케이션 코드는 `team5-app`에서 관리합니다.
- Terraform 실행 전 항상 `terraform plan`을 확인합니다.
- 팀 프로젝트에서는 AWS Profile을 provider에 하드코딩하지 않고, 각자 로컬에서 `AWS_PROFILE`을 지정하여 실행합니다.

