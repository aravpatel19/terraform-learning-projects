# 🚀 EKS Application Testing & Operations Guide

## 📋 Quick Status Check Commands

### 1. **Check Application Status**
```bash
# Check if pods are running
kubectl get pods -n nodejs-app

# Check pod details and events
kubectl describe pods -n nodejs-app

# Check pod logs
kubectl logs -n nodejs-app <pod-name>
kubectl logs -n nodejs-app -l app=nodejs-app  # All pods with label
```

### 2. **Check Services and Networking**
```bash
# Check services
kubectl get services -n nodejs-app

# Check ingress
kubectl get ingress -n nodejs-app

# Check endpoints
kubectl get endpoints -n nodejs-app
```

### 3. **Check EKS Cluster Status**
```bash
# Check cluster nodes
kubectl get nodes

# Check node details
kubectl describe nodes

# Check cluster info
kubectl cluster-info
```

## 🌐 Accessing the Application

### **Method 1: Port Forwarding (Current Setup)**
```bash
# Start port forwarding (run this in a separate terminal)
kubectl port-forward -n nodejs-app service/nodejs-service 8080:3000

# Access application
open http://localhost:8080
# OR
curl http://localhost:8080
```

### **Method 2: Direct Pod Access (For Testing)**
```bash
# Get pod name
kubectl get pods -n nodejs-app

# Port forward directly to pod
kubectl port-forward -n nodejs-app <pod-name> 8080:3000
```

### **Method 3: Load Balancer (Future Enhancement)**
```bash
# Check if ALB is created
kubectl get ingress -n nodejs-app -o wide

# Get ALB URL (when available)
kubectl get ingress nodejs-ingress -n nodejs-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## 🔍 Detailed Testing Commands

### **Application Health Checks**
```bash
# Test application endpoint
curl -v http://localhost:8080

# Test with specific headers
curl -H "Accept: application/json" http://localhost:8080

# Check application logs in real-time
kubectl logs -n nodejs-app -f <pod-name>
```

### **Database Connectivity Test**
```bash
# Check if database connection is working
kubectl exec -n nodejs-app <pod-name> -- curl -s http://localhost:3000 | grep -i "connected"

# Check environment variables
kubectl exec -n nodejs-app <pod-name> -- env | grep DB_
```

### **Resource Monitoring**
```bash
# Check resource usage
kubectl top pods -n nodejs-app
kubectl top nodes

# Check resource limits and requests
kubectl describe pods -n nodejs-app | grep -A 5 "Requests\|Limits"
```

## 🛠️ Troubleshooting Commands

### **Pod Issues**
```bash
# Check pod events
kubectl get events -n nodejs-app --sort-by='.lastTimestamp'

# Check pod status in detail
kubectl describe pod <pod-name> -n nodejs-app

# Check previous container logs (if pod restarted)
kubectl logs <pod-name> -n nodejs-app --previous
```

### **Service Issues**
```bash
# Check service endpoints
kubectl get endpoints -n nodejs-app

# Test service connectivity from within cluster
kubectl run test-pod --image=busybox -it --rm -- nslookup nodejs-service.nodejs-app.svc.cluster.local
```

### **Network Issues**
```bash
# Check network policies
kubectl get networkpolicies -n nodejs-app

# Test DNS resolution
kubectl exec -n nodejs-app <pod-name> -- nslookup nodejs-service
```

## 📊 Monitoring and Observability

### **Application Metrics**
```bash
# Check deployment status
kubectl get deployments -n nodejs-app

# Check replica set
kubectl get rs -n nodejs-app

# Check deployment rollout status
kubectl rollout status deployment/nodejs-app -n nodejs-app
```

### **Cluster Health**
```bash
# Check cluster components
kubectl get componentstatuses

# Check system pods
kubectl get pods -n kube-system

# Check AWS Load Balancer Controller
kubectl get pods -n kube-system | grep aws-load-balancer
```

## 🔧 Common Operations

### **Scaling**
```bash
# Scale deployment
kubectl scale deployment nodejs-app --replicas=3 -n nodejs-app

# Check scaling status
kubectl get pods -n nodejs-app -w
```

### **Updates and Rollouts**
```bash
# Update image
kubectl set image deployment/nodejs-app nodejs-app=aravpatel2319/nodejs-mysql-app:latest -n nodejs-app

# Check rollout history
kubectl rollout history deployment/nodejs-app -n nodejs-app

# Rollback if needed
kubectl rollout undo deployment/nodejs-app -n nodejs-app
```

### **Configuration Updates**
```bash
# Update ConfigMap
kubectl apply -f k8s-manifests/configmap.yaml

# Update Secret
kubectl apply -f k8s-manifests/secret.yaml

# Restart deployment to pick up changes
kubectl rollout restart deployment/nodejs-app -n nodejs-app
```

## 🗂️ File Locations and Structure

```
06_project/nodejs-mysql/
├── k8s-manifests/           # Kubernetes manifests
│   ├── namespace.yaml       # Namespace definition
│   ├── configmap.yaml       # Configuration data
│   ├── secret.yaml          # Sensitive data (DB credentials)
│   ├── deployment.yaml      # Application deployment
│   ├── service.yaml         # Service definition
│   └── ingress.yaml         # Ingress for external access
├── terraform/               # Infrastructure as Code
│   ├── eks/                 # EKS cluster configuration
│   ├── ec2.tf              # EC2 instance
│   ├── rds.tf              # RDS database
│   └── s3.tf               # S3 bucket
├── Dockerfile              # Container definition
├── .dockerignore           # Docker build exclusions
└── TESTING_AND_OPERATIONS.md # This file
```

## 🚨 Emergency Procedures

### **If Application is Down**
```bash
# 1. Check pod status
kubectl get pods -n nodejs-app

# 2. Check logs
kubectl logs -n nodejs-app <pod-name>

# 3. Restart deployment
kubectl rollout restart deployment/nodejs-app -n nodejs-app

# 4. Check service
kubectl get services -n nodejs-app
```

### **If Database Connection Fails**
```bash
# 1. Check RDS security group
aws ec2 describe-security-groups --group-ids sg-04bb6399bee57d592

# 2. Test from pod
kubectl exec -n nodejs-app <pod-name> -- nslookup nodejs-rds-mysql.cq7gmo6s8s6l.us-east-1.rds.amazonaws.com

# 3. Check environment variables
kubectl exec -n nodejs-app <pod-name> -- env | grep DB_
```

## 📱 Application URLs

- **Local Access**: http://localhost:8080 (via port-forward)
- **Direct Pod Access**: Use port-forward to specific pod
- **Future ALB Access**: Will be available when ingress is fully configured

## 🔑 Key Information

- **Namespace**: `nodejs-app`
- **Application**: `nodejs-app`
- **Service**: `nodejs-service`
- **Database**: `nodejs-rds-mysql.cq7gmo6s8s6l.us-east-1.rds.amazonaws.com`
- **Docker Image**: `aravpatel2319/nodejs-mysql-app:latest`
- **EKS Cluster**: `nodejs-eks-cluster`

## 📝 Quick Reference

```bash
# Most common commands
kubectl get pods -n nodejs-app                    # Check pods
kubectl logs -n nodejs-app -l app=nodejs-app      # Check logs
kubectl port-forward -n nodejs-app service/nodejs-service 8080:3000  # Access app
curl http://localhost:8080                        # Test app
kubectl get ingress -n nodejs-app                 # Check ingress
```
