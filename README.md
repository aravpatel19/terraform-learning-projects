# Terraform Learning Projects

This repository contains my Terraform learning journey with various projects and examples.

## Project Structure

### 01_basics/
Basic Terraform configuration examples to get started with infrastructure as code.

### 02_state/
Examples of Terraform state management and remote state configuration.

### 03_vars-outputs/
Working with Terraform variables, outputs, and different environment configurations.

### 04_giving_values/
Examples of providing values to Terraform variables through different methods.

### 05_modules/
Creating and using Terraform modules for reusable infrastructure components.

### 06_project/nodejs-mysql/
A complete Node.js application with MySQL database, deployed using Terraform to AWS.

## Getting Started

Each directory contains its own Terraform configuration. Navigate to any directory and run:

```bash
terraform init
terraform plan
terraform apply
```

## Security Notes

- `.env` files containing secrets are excluded from version control
- Terraform state files are excluded from version control
- `.terraform/` directories with provider binaries are excluded

## Prerequisites

- Terraform installed
- AWS CLI configured (for AWS examples)
- MySQL (for the Node.js project)
- Node.js and npm (for the Node.js project)
