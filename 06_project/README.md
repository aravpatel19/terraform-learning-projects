# Node.js MySQL Application on AWS with Terraform & EKS

## 🏗️ Project Overview

This project demonstrates deploying a full-stack Node.js application with MySQL database on AWS using Infrastructure as Code (Terraform). The application showcases both traditional EC2 deployment and modern containerized deployment on Amazon EKS (Elastic Kubernetes Service).

## 🎯 **CURRENT STATUS: EKS DEPLOYMENT COMPLETE!**

✅ **Containerized Application**: Running on EKS with 2 replicas  
✅ **Database Connectivity**: Connected to RDS MySQL  
✅ **Infrastructure as Code**: Complete Terraform automation  
✅ **Professional Tools**: Helm, AWS Load Balancer Controller  
✅ **Application Access**: Available via port-forwarding  

**Quick Access**: `kubectl port-forward -n nodejs-app service/nodejs-service 8080:3000` then visit `http://localhost:8080`

## 📁 Project Structure

```
06_project/
├── nodejs-mysql/                 # Main application directory
│   ├── public/                   # Frontend assets (HTML, CSS, JS)
│   │   ├── index.html           # Main application page
│   │   ├── style.css            # Application styling
│   │   ├── app.js               # Frontend JavaScript logic
│   │   └── images/              # Application images
│   ├── server.js                # Node.js backend server
│   ├── package.json             # Node.js dependencies and scripts
│   ├── db_commands.txt          # Database setup commands
│   ├── Dockerfile               # Container definition
│   ├── .dockerignore            # Docker build exclusions
│   ├── k8s-manifests/           # Kubernetes deployment files
│   │   ├── namespace.yaml       # K8s namespace
│   │   ├── configmap.yaml       # Configuration data
│   │   ├── secret.yaml          # Database credentials
│   │   ├── deployment.yaml      # Application deployment
│   │   ├── service.yaml         # Service definition
│   │   └── ingress.yaml         # External access
│   ├── terraform/               # Infrastructure as Code
│   │   ├── eks/                 # EKS cluster configuration
│   │   │   ├── main.tf          # EKS cluster and IAM
│   │   │   ├── vpc.tf           # VPC and networking
│   │   │   ├── node-groups.tf   # Worker nodes
│   │   │   ├── variables.tf     # EKS variables
│   │   │   ├── versions.tf      # Provider versions
│   │   │   └── outputs.tf       # EKS outputs
│   │   ├── ec2.tf               # EC2 instance configuration
│   │   ├── rds.tf               # RDS database configuration
│   │   ├── s3.tf                # S3 bucket configuration
│   │   ├── providers.tf         # AWS provider configuration
│   │   ├── variables.tf         # Terraform variables
│   │   └── terraform.tfvars     # Variable values
│   ├── TESTING_AND_OPERATIONS.md # Comprehensive testing guide
│   └── EKS_FastTrack_Plan.md    # Implementation plan
└── README.md                     # This file
```

## 🚀 Application Components

### Frontend (public/)
- **index.html**: Main application interface for user management
- **style.css**: Modern, responsive styling
- **app.js**: Frontend logic for adding/displaying users
- **images/**: Application logos and graphics

### Backend (server.js)
- **Express.js server**: Handles HTTP requests
- **MySQL connection**: Connects to RDS database
- **REST API endpoints**: 
  - `GET /`: Serves the main page
  - `POST /users`: Adds new users
  - `GET /users`: Retrieves all users

### Database (RDS)
- **MySQL 8.0**: Managed relational database
- **Users table**: Stores user information (name, email)
- **Automated backups**: Daily backups with 7-day retention

## ☁️ AWS Infrastructure

### EC2 Instance
- **Ubuntu 24.04 LTS**: Linux server for running the Node.js application
- **t2.micro**: Free tier eligible instance type
- **Public IP**: Accessible from the internet
- **Security Group**: Controls network access (SSH, HTTPS, Port 3000)

### RDS Database
- **MySQL 8.0**: Managed database service
- **db.t3.micro**: Free tier eligible database
- **Multi-AZ**: High availability configuration
- **Automated backups**: Point-in-time recovery

### S3 Bucket
- **Static file storage**: Hosts application images
- **Public access**: Images accessible via web
- **Cost-effective**: Pay only for storage used

## 🛠️ Terraform Infrastructure as Code

### What is Terraform?
Terraform is an Infrastructure as Code (IaC) tool that allows you to define and provision cloud infrastructure using declarative configuration files.

### Key Benefits
- **Version Control**: Infrastructure changes are tracked in Git
- **Reproducibility**: Same infrastructure can be created anywhere
- **Collaboration**: Team members can review and approve changes
- **Automation**: No manual AWS console clicking required

### Terraform Files Explained

#### ec2.tf
- **EC2 Instance**: Defines the virtual server specifications
- **User Data**: Automated setup script that runs on instance launch
- **Security Groups**: Network access rules (firewall)
- **Dependencies**: Ensures proper resource creation order

#### rds.tf
- **Database Instance**: MySQL database configuration
- **Security Groups**: Database access controls
- **Backup Settings**: Automated backup configuration
- **Network Configuration**: VPC and subnet placement

#### s3.tf
- **Bucket Creation**: S3 storage bucket
- **Object Uploads**: Application images and files
- **Access Policies**: Public read access for web assets

#### providers.tf
- **AWS Configuration**: Region and provider settings
- **Authentication**: AWS credentials and region

#### variables.tf
- **Reusable Values**: AMI IDs, instance types, etc.
- **Environment Flexibility**: Easy to change values per environment

## 🔄 Deployment Process

1. **Terraform Plan**: Review infrastructure changes
2. **Terraform Apply**: Create/update AWS resources
3. **Instance Launch**: EC2 starts with user data script
4. **Application Setup**: Git clone, npm install, environment setup
5. **Service Start**: Application runs automatically

## 🌐 Accessing the Application

### **EKS Deployment (Current)**
- **Local Access**: `kubectl port-forward -n nodejs-app service/nodejs-service 8080:3000` then visit `http://localhost:8080`
- **Application Status**: `kubectl get pods -n nodejs-app`
- **Logs**: `kubectl logs -n nodejs-app -l app=nodejs-app`

### **EC2 Deployment (Legacy)**
- **Public URL**: `http://[EC2_PUBLIC_IP]:3000`
- **SSH Access**: `ssh -i ~/.ssh/terraform-ec2.pem ubuntu@[EC2_PUBLIC_IP]`
- **Database**: Accessible from both EC2 and EKS

## 🚀 **EKS Deployment Features**

### **Container Orchestration**
- **Kubernetes**: Modern container orchestration platform
- **Auto-scaling**: 2 replicas with 1-4 node scaling
- **Health Checks**: Liveness and readiness probes
- **Rolling Updates**: Zero-downtime deployments

### **Infrastructure**
- **EKS Cluster**: Managed Kubernetes service
- **VPC**: Dedicated network with public/private subnets
- **IAM Roles**: Proper security and permissions
- **Load Balancer**: AWS Application Load Balancer (ALB)

### **Professional Tools**
- **Helm**: Package manager for Kubernetes
- **AWS Load Balancer Controller**: Manages ALB resources
- **Docker**: Containerized application
- **GitOps**: Infrastructure and application in version control

## 📋 **Quick Testing Commands**

```bash
# Check application status
kubectl get pods -n nodejs-app

# Access application
kubectl port-forward -n nodejs-app service/nodejs-service 8080:3000

# Test application
curl http://localhost:8080

# Check logs
kubectl logs -n nodejs-app -l app=nodejs-app

# Scale application
kubectl scale deployment nodejs-app --replicas=3 -n nodejs-app
```

**📖 For detailed testing and operations, see [TESTING_AND_OPERATIONS.md](nodejs-mysql/TESTING_AND_OPERATIONS.md)**

## 💰 Cost Considerations

- **EC2 t2.micro**: Free tier eligible (750 hours/month)
- **RDS db.t3.micro**: Free tier eligible (750 hours/month)
- **S3**: First 5GB free, then $0.023/GB/month
- **Data Transfer**: Free tier includes 15GB/month

## 🔧 Maintenance and Updates

### Application Updates
- Modify code locally
- Push to Git repository
- Redeploy with Terraform

### Infrastructure Updates
- Modify Terraform files
- Run `terraform plan` to review changes
- Run `terraform apply` to apply changes

## 🚨 Important Notes

- **Security**: Default security groups allow broad access (not production-ready)
- **Backups**: RDS has automated backups enabled
- **Monitoring**: Basic CloudWatch metrics included
- **Scaling**: Current setup is single-instance (not production-ready)

## 📚 Learning Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [Node.js Documentation](https://nodejs.org/docs/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `terraform plan`
5. Submit a pull request

## 📄 License

This project is for educational purposes. Please review AWS pricing and terms before deploying to production.
