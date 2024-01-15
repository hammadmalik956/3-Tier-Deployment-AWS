# 3-Tier-Deployment-AWS
A 3-Tier Web Applicaiton deployment on Amazon Aws using Terraform 


## Overview

This repository contains Terraform scripts for deploying a 3-tier web application on Amazon AWS. The application stack includes a frontend built with the MERN (MongoDB, Express.js, React.js, Node.js) stack, while the backend is composed of Amazon RDS for database management, EC2 instances for application hosting, an Application Load Balancer (ALB) for traffic distribution, and an Auto Scaling Group for dynamic scaling.

## Deployment Architecture

The deployment architecture involves three main tiers:

1. **Frontend (React.js):** The user interface of the application built using React.js.

2. **Backend (Node.js, Express.js):** The server-side logic and API endpoints hosted on EC2 instances.

3. **Database (MongoDB on Amazon RDS):** The relational database management system for data storage.

## AWS Services Used

- **EC2 Instances:** Hosting backend application components.
- **Amazon RDS:** Managed relational database service for the backend.
- **Application Load Balancer (ALB):** Efficiently distributes incoming traffic across EC2 instances.
- **Auto Scaling Group (ASG):** Dynamically adjusts the number of EC2 instances based on demand.
- **Route 53:** Manages domain registration and provides DNS services.

## Terraform Scripts

The `terraform/` directory contains Terraform scripts organized as follows:

- `backend/`: Terraform scripts for configuring the backend infrastructure (EC2 instances, RDS, ASG, ALB).
- `networking/`: Configuration for VPC, subnets, and Route 53.
- `variables.tf`: Variables file for parameterizing the Terraform scripts.
- `main.tf`: Main Terraform script for initializing the deployment.

## Getting Started

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/3-Tier-Deployment-AWS.git
