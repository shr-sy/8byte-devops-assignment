# 8Byte DevOps Assignment

This repository contains a complete DevOps assignment solution for provisioning, deploying, monitoring, and documenting a cloud-native application stack on AWS.

## Architecture overview

- VPC with public and private subnets
- Application EC2 instance behind an Application Load Balancer
- PostgreSQL RDS in private subnets
- Security groups with least privilege rules
- CI/CD pipeline with tests, image build/push, and deployment promotion
- Monitoring stack using Prometheus and Grafana
- Centralized logging with Loki/Promtail

## Repository structure

```text
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── app/
│   ├── Dockerfile
│   ├── app.py
│   ├── requirements.txt
│   └── tests/
│       └── test_app.py
├── infra/
│   └── terraform/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── terraform.tfvars.example
├── monitoring/
│   ├── docker-compose.yml
│   ├── prometheus.yml
│   ├── loki-config.yml
│   ├── promtail-config.yml
│   └── grafana/
│       ├── provisioning/
│       └── dashboards/
├── .gitignore
├── docker-compose.yml
├── LICENSE
└── README.md
```

## Prerequisites

- Docker
- Docker Compose
- Terraform >= 1.5
- AWS CLI configured with access to an AWS account
- GitHub repository for CI/CD

## 1) Infrastructure provisioning with Terraform

### HCP Terraform setup

If you are using HCP Terraform for remote state and workspace execution, update the values in `infra/terraform/versions.tf`:

```hcl
cloud {
  organization = "your-hcp-org"
  workspaces {
    name = "8byte-dev"
  }
}
```

Then authenticate and initialize:

```bash
cd infra/terraform
terraform login
terraform init
```

If you are not using HCP Terraform remote execution, you can still keep the local workflow:

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

### Important notes

- The database password is sensitive and should be managed via AWS Secrets Manager in production.
- The example configuration is suitable for a dev/staging environment and demonstrates architecture and automation best practices.

## 2) Local application run

```bash
cd app
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

The app exposes:

- `/` - landing page
- `/health` - health check endpoint

## 3) Docker image build

```bash
docker build -t 8byte-app ./app
docker run -p 8000:8000 8byte-app
```

## 4) CI/CD pipeline

The workflow in `.github/workflows/ci-cd.yml` runs when:

- a pull request is created or updated
- code is pushed to `main`

It performs:

- Python dependency install
- unit/integration tests
- vulnerability scan with Trivy
- Docker image build/push
- deployment to staging
- manual approval gate for production

## 5) Monitoring and logging

To spin up the observability stack:

```bash
docker compose -f monitoring/docker-compose.yml up -d
```

This includes:

- Prometheus for metrics scraping
- Grafana for dashboards
- Loki + Promtail for log aggregation

### Included dashboards

- Application overview dashboard
- Infrastructure overview dashboard

## 6) Security and cost considerations

- Keep public access limited to the ALB and SSH only from the required office/admin CIDR
- Restrict database access to the application security group only
- Use Secrets Manager or SSM Parameter Store for secrets
- Prefer smaller instance sizes for dev and scale horizontally for production
- Use lifecycle rules, backups, and autoscaling where needed

## 7) Deliverables status

This repository includes the core artifact set required by the assignment:

- Terraform infrastructure code
- CI/CD pipeline
- Dockerized application
- Monitoring setup
- Documentation and approach notes

## Challenges and resolutions

1. Keeping infrastructure secure without overexposing services
   - Resolved by placing the database in private subnets and limiting ingress through security groups.

2. Balancing cost and scalability
   - Resolved by using a small dev-appropriate instance profile and clear scaling patterns for production.

3. Keeping the assignment practical without overcomplicating the app layer
   - Resolved by creating a minimal application with health checks and test coverage instead of a complex business service.

## License

This project is provided for educational and assignment use.
