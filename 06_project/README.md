# Terraform Learning Projects

A collection of infrastructure projects I've been working on to learn Terraform and AWS services. This started as a simple EC2 deployment but I wanted to explore modern containerized deployments, so I tackled EKS next.

## Current Project: Node.js App with EKS

I built a simple user management app with Node.js and MySQL, then deployed it on AWS using both traditional EC2 and modern EKS approaches. The EKS deployment was definitely more challenging but I learned a lot about container orchestration.

Right now the app is running on EKS with:

- Containerized Node.js app (2 replicas for redundancy)
- RDS MySQL database for data persistence
- Everything managed through Terraform (which I thought was pretty cool)
- Load balancer for external access

**Quick test**: `kubectl port-forward -n nodejs-app service/nodejs-service 8080:3000` then visit `http://localhost:8080`

**Public access**: The app is also accessible via the AWS Load Balancer at `http://af2297c2cfb804d858ad1ac92e392174-1808336492.us-east-1.elb.amazonaws.com` (though I might take this down to save costs)

## Project Structure

```
06_project/
├── nodejs-mysql/                 # Main application
│   ├── public/                   # Frontend files
│   ├── server.js                 # Node.js backend
│   ├── package.json              # Dependencies
│   ├── Dockerfile                # Container setup
│   ├── k8s-manifests/            # Kubernetes configs
│   └── terraform/                # Infrastructure code
│       ├── eks/                  # EKS cluster setup
│       ├── ec2.tf                # EC2 configuration
│       ├── rds.tf                # Database setup
│       └── s3.tf                 # Storage bucket
└── README.md                     # This file
```

## What's in the App

It's a pretty straightforward user management system I put together:

**Frontend**: Basic HTML/CSS/JS interface for adding and viewing users
**Backend**: Express.js server that handles API requests and connects to MySQL
**Database**: RDS MySQL instance storing user data

The app has three main endpoints:

- `GET /` - Shows the main page
- `POST /users` - Adds a new user
- `GET /users` - Returns all users

Nothing fancy, but it works well for learning the deployment concepts.

## AWS Infrastructure

Here's what I set up:

**EKS Cluster**: Managed Kubernetes service running the containerized app
**RDS MySQL**: Managed database (db.t3.micro) with automated backups
**VPC**: Custom network with public/private subnets for security
**Load Balancer**: AWS ALB for external access to the application
**S3 Bucket**: Stores static assets like images

I kept the original EC2 setup (t2.micro) for comparison, but the main deployment is now on EKS. The networking part was tricky at first - I had to figure out how to connect the EKS pods to the RDS instance across different VPCs.

Here's how the traffic flows:

```
    🌐 USER BROWSER
         │
         │ 1. HTTP Request
         ▼
    ┌─────────────┐
    │ AWS LOAD    │
    │ BALANCER    │
    └─────┬───────┘
          │ 2. Health Check
          ▼
    ┌─────────────┐
    │ EKS SERVICE │
    │ (Port 80)   │
    └─────┬───────┘
          │ 3. Load Balance
          ▼
    ┌─────────────┐
    │ NODE.JS POD │
    │ (Port 3000) │
    └─────┬───────┘
          │ 4. Database Query
          ▼
    ┌─────────────┐
    │ RDS MYSQL   │
    │ (Port 3306) │
    └─────────────┘
```

## Terraform Setup

I defined all the AWS infrastructure in Terraform files, which was really helpful for learning. The main components are:

**EKS Configuration** (`terraform/eks/`): Sets up the Kubernetes cluster, VPC, subnets, and worker nodes
**Database** (`rds.tf`): Creates the RDS MySQL instance with proper security groups
**Storage** (`s3.tf`): Creates S3 bucket for static assets
**EC2** (`ec2.tf`): Original single-instance setup (kept for reference)

What I really liked about using Terraform is that I can recreate the entire infrastructure from scratch, and all changes are tracked in version control without being on the AWS console.

## How to Deploy

If you want to try this yourself:

1. Run `terraform plan` to see what will be created
2. Run `terraform apply` to create the infrastructure
3. Deploy the app to EKS using the Kubernetes manifests
4. Access via port-forwarding or load balancer

## Testing the Application

Here are the commands I use to check if everything is working:

```bash
# Check if pods are running
kubectl get pods -n nodejs-app

# Port forward to access locally
kubectl port-forward -n nodejs-app service/nodejs-service 8080:3000

# Test the API
curl http://localhost:8080

# View logs
kubectl logs -n nodejs-app -l app=nodejs-app
```

The app should be accessible at `http://localhost:8080` after port-forwarding. You can also access it publicly via the Load Balancer URL, but that costs money to keep running.

## What I Learned

This project taught me a lot about modern cloud infrastructure. The biggest challenges were:

1. **Architecture mismatch**: My Docker image was built for ARM64 but EKS nodes were x86_64 - had to rebuild the image
2. **Network connectivity**: EKS cluster was in a different VPC than RDS, so I had to update security groups
3. **Load balancer setup**: Initially tried Ingress but switched to LoadBalancer service type for simplicity

The EKS deployment was definitely more complex than the EC2 version, but I learned a ton about Kubernetes concepts like pods, services, deployments, and namespaces.

## Cost Considerations

For learning purposes, I tried to keep costs low:

- **EC2 t2.micro**: Free tier eligible (750 hours/month)
- **RDS db.t3.micro**: Free tier eligible (750 hours/month)
- **S3**: First 5GB free, then $0.023/GB/month
- **EKS**: This one costs money (~$73/month for the control plane)

## Next Steps

I'm thinking about adding:

- CI/CD pipeline with GitHub Actions
- Monitoring with Prometheus/Grafana
- Better security configurations
- Multi-environment setup (dev/staging/prod)

This was a great learning experience and I'm excited to explore more cloud-native technologies!
