# Approach and implementation notes

## 1. Infrastructure design

The solution follows a simple but production-aware AWS reference architecture:

- VPC with public and private subnets for separation of internet-facing and data-plane components
- Application Load Balancer in the public tier to expose the app to users
- EC2 instance(s) in the public tier for the application runtime
- RDS PostgreSQL in the private tier for secure data persistence
- Security groups that restrict ingress to only required ports and trusted sources

This layout keeps the database protected from direct internet exposure while keeping the app reachable.

## 2. Application choice

The assignment allows using a ready-made application, as long as the architecture and deployment flow are sound. This repository uses a minimal Flask app with:

- a landing route at `/`
- a health check route at `/health`

The app is intentionally lightweight so the focus remains on infrastructure automation, deployment flow, and operational maturity.

## 3. CI/CD flow

The GitHub Actions workflow performs the following on pull requests and merges:

- install dependencies
- run unit tests
- run dependency vulnerability scanning with Trivy
- build a Docker image
- push the image to Docker Hub
- deploy to staging automatically
- require manual approval before production deployment

This matches the assignment requirement for automated validation and controlled release promotion.

## 4. Monitoring and logging

The monitoring stack uses Prometheus and Grafana to provide operational visibility, while Loki and Promtail are included for centralized log collection. The goal is to provide:

- application health visibility
- system resource monitoring
- log aggregation for troubleshooting
- at least two dashboards for meaningful operational views

## 5. Security best practices

- database is placed in private subnets
- security groups allow only necessary traffic
- secrets such as database passwords should be moved to AWS Secrets Manager in real deployments
- public ingress is limited to the ALB and required admin sources

## 6. Cost optimization considerations

- dev and staging use smaller instance classes
- only one application instance is provisioned by default
- the database is cost-conscious and can be scaled later as needed
- Terraform variables allow quick changes without changing the code structure

## 7. Challenges and resolutions

1. Challenge: keep the solution secure without overcomplicating infrastructure.
   Resolution: VPC segmentation, private DB subnets, and SG-based access restrictions.

2. Challenge: balance practicality against assignment completeness.
   Resolution: use a minimal app and focus on automation and cloud architecture, not feature-heavy business logic.

3. Challenge: maintain a clean deployment flow.
   Resolution: use staged promotion, Docker builds, and approval gates that support real-world deployment control.
