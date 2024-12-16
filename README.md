
---

# **Infrastructure Setup for a Node.js Web Application on AWS**

This project demonstrates a modular, secure, and scalable cloud infrastructure deployment for a containerized Node.js web application. It uses Terraform for Infrastructure as Code, Docker for containerization, and GitHub Actions for Continuous Integration and Deployment (CI/CD).

---


## **Table of Contents**
1. [Project Overview](#project-overview)
2. [Folder Structure](#folder-structure)
3. [Architecture Diagram](#architecture-diagram)
4. [Components and Workflow](#components-and-workflow)
   - [VPC Module](#1-vpc-module)
   - [ECS Module](#2-ecs-module)
   - [RDS Module](#3-rds-module)
   - [Redis Module](#4-redis-module)
   - [Route 53 Module](#5-route-53-module)
   - [Monitoring and Security](#6-monitoring-and-security)
5. [CI/CD Pipeline](#cicd-pipeline)
6. [Features](#features)
   - [Autoscaling](#autoscaling)
   - [Monitoring](#monitoring)
   - [Cost Efficiency](#cost-efficiency)
   - [Security](#security)
7. [Deployment Steps](#deployment-steps)
8. [Key Benefits](#key-benefits)
9. [Example Usage](#example-usage)
10. [Future Enhancements](#future-enhancements)

---

## **Project Overview**

This project provisions cloud infrastructure for deploying a Node.js web application. The setup includes:
- **AWS ECS**: Runs containerized applications.
- **Amazon RDS**: Provides a managed MySQL database.
- **Amazon ElastiCache**: Implements Redis for in-memory caching.
- **AWS Route 53**: Manages DNS and routes traffic.
- **Application Load Balancer**: Balances traffic across ECS tasks.
- **Autoscaling and Monitoring**: Ensures high availability and resource optimization.

---

## **Folder Structure**

The project is organized as follows:

```
/project-root
├── /terraform
│   ├── /modules
│   │   ├── /vpc
│   │   │   ├── main.tf               # Defines the VPC resource
│   │   │   ├── variables.tf          # Input variables for the VPC module
│   │   │   └── outputs.tf            # Outputs for the VPC module
│   │   ├── /ecs
│   │   │   ├── main.tf               # Defines ECS cluster and services
│   │   │   ├── iam.tf                # IAM roles and policies for ECS tasks
│   │   │   ├── variables.tf          # Input variables for the ECS module
│   │   │   ├── autoscaling.tf        # Autoscaling policies for ECS tasks
│   │   │   ├── monitoring.tf         # CloudWatch monitoring configuration for ECS tasks
│   │   │   └── outputs.tf            # Outputs for the ECS module
│   │   ├── /rds
│   │   │   ├── main.tf               # Defines the RDS instance
│   │   │   ├── variables.tf          # Input variables for the RDS module
│   │   │   └── outputs.tf            # Outputs for the RDS module
│   │   ├── /redis
│   │   │   ├── main.tf               # Defines Redis caching setup
│   │   │   ├── variables.tf          # Input variables for the Redis module
│   │   │   └── outputs.tf            # Outputs for the Redis module
│   │   ├── /security
│   │   │   ├── main.tf               # Security groups for ECS, RDS, and Redis
│   │   │   ├── variables.tf          # Input variables for the security module
│   │   │   └── outputs.tf            # Outputs for the security module
│   ├── main.tf                       # Root Terraform configuration
│   ├── variables.tf                  # Root variables shared across modules
│   ├── outputs.tf                    # Outputs shared across modules
│   └── README.md                     # Terraform usage instructions
├── /docker
│   ├── Dockerfile                    # Docker image definition for the Node.js app
│   └── .dockerignore                 # Files to ignore during Docker build
├── /app
│   ├── server.js                     # Node.js application entry point
│   ├── package.json                  # Application dependencies
│   ├── package-lock.json             # Dependency lock file
│   └── README.md                     # Application setup instructions
├── /.github
│   └── /workflows
│       └── terraform-ci-cd.yaml      # GitHub Actions workflow for CI/CD
├── README.md                         # Main README for the project
```

---

## **Architecture Diagram**

Below is the architecture diagram representing the cloud setup:

![Infrastructure Diagram](aws_arch_diagram.svg)


## Explanation to the Diagram

The architecture diagram represents a **3-tier application architecture** on AWS, designed for scalability, high availability, and secure data handling. This document merges the previous detailed explanations with the new additions to provide an updated and comprehensive description.


### **Components in the 3-Tier Architecture**

#### **1. Presentation Layer (Frontend)**:
- **Node.js Application**:
  - Hosted on **AWS Fargate** within an **ECS cluster**.
  - The user accesses the application via the **Application Load Balancer (ALB)**.
  - ALB directs traffic to the Node.js service running as ECS tasks.
  - **DNS Resolution**:
    - Configured using **Amazon Route 53**, providing a custom domain for the application.
- **Amazon CloudFront**:
  - Distributes static assets (e.g., images, JavaScript, CSS) globally.
  - Acts as a Content Delivery Network to improve latency and reduce load on backend resources.

- **Amazon WAF (Web Application Firewall)**:
  - Protects the application from malicious traffic such as SQL injections, XSS, and DDoS attacks.

- **Amazon API Gateway**:
  - Serves as an entry point for RESTful API requests, forwarding traffic to ALB.

#### **2. Business Logic Layer (Middle Tier)**:
- **AWS Fargate**:
  - Fargate is used to run the containerized Node.js application in the ECS cluster.
  - Automatically scales based on the traffic (autoscaling policies are applied).
  - The **IAM role** associated with the ECS tasks ensures secure access to backend resources, such as RDS and Redis.

- **Redis Cache (Amazon ElastiCache)**:
  - Acts as a caching layer, storing frequently used data to reduce load on the database and improve performance.
  - Communicates with the Fargate-based Node.js service over a **private subnet** within the VPC.

#### **3. Data Layer (Backend)**:
- **Amazon RDS (Relational Database)**:
  - MySQL database hosted in private subnets for secure storage of application data.
  - RDS is accessed only by the Node.js service through a **security group** allowing connections from ECS tasks.
  - Encryption at rest and automated backups ensure data protection.

- **Redis Cache**:
  - Redis is also part of the backend but serves as a high-speed in-memory data store to reduce database calls.

---

### **Networking and Security Enhancements**

#### **VPC (Virtual Private Cloud)**:
- The architecture spans multiple availability zones within a single VPC.
- **Public Subnets**:
  - Hosts the **Application Load Balancer** and allows external traffic into the application.
- **Private Subnets**:
  - Hosts backend services such as RDS and Redis.

#### **Security Groups**:
- Configures inbound and outbound traffic for ECS, RDS, and Redis.
- Restricts access to backend services by allowing only required traffic from the ECS cluster.

#### **IAM Roles**:
- Ensure secure access to AWS resources by Fargate tasks (e.g., accessing RDS or ElastiCache).

#### **AWS WAF**:
- Blocks malicious traffic and web-based threats before they reach the application.

#### **Highly Available Zones**:
- Managed by the ALB to distribute traffic across ECS tasks deployed in multiple availability zones.
- Ensures fault tolerance and minimizes downtime.

---

### **Monitoring and Logging Enhancements**

#### **Amazon CloudWatch**:
- Monitors ECS cluster performance, RDS metrics, and application logs.
- Captures metrics for key performance indicators (e.g., CPU utilization, memory usage).
- Alarms notify administrators about critical issues.

#### **Amazon CloudTrail**:
- Tracks API calls and resource changes for audit purposes.
- Ensures traceability for all actions performed in the AWS environment.

---

### **Communication Flow Between Components**

#### **1. User to Amazon Route 53**:
- Users interact with the application through a domain configured in **Amazon Route 53**.
- Route 53 resolves the domain to the CloudFront distribution or API Gateway.

#### **2. CloudFront to WAF to API Gateway**:
- CloudFront serves cached static content, improving global performance.
- API Gateway validates and forwards API requests to the ALB.

#### **3. ALB to Node.js Service (ECS)**:
- ALB distributes incoming traffic to ECS tasks running on AWS Fargate.
- Fargate tasks automatically scale based on demand.

#### **4. Node.js to Redis (ElastiCache)**:
- The Node.js application queries **Redis** for cached data first (e.g., session data, API responses).
- If data is not found in Redis, the application queries the RDS database.

#### **5. Node.js to Amazon RDS**:
- When Redis does not contain the requested data, the Node.js application fetches it from the RDS database.
- Security groups ensure that only the ECS cluster can access RDS.

#### **6. Monitoring and Logging**:
- CloudWatch collects metrics and logs from ECS, RDS, and the Node.js application.
- Alarms are set up for critical metrics like CPU utilization, memory usage, and database connections.

---

### **How the Diagram Reflects the Architecture**

The diagram includes:

1. **Route 53**:
   - Provides DNS resolution for the application, mapping a custom domain to the CloudFront distribution.
2. **Amazon CloudFront**:
   - Serves static content and forwards dynamic requests to the API Gateway.
3. **AWS WAF**:
   - Protects the application from malicious traffic.
4. **Amazon API Gateway**:
   - Acts as an entry point for API requests and routes them to the ALB.
5. **Application Load Balancer**:
   - Distributes traffic to the ECS tasks running on Fargate.
6. **AWS Fargate (ECS)**:
   - Hosts the Node.js service and represents the middle tier of the 3-tier architecture.
7. **Redis Cache (ElastiCache)**:
   - Connected to the ECS tasks for caching.
8. **RDS (MySQL)**:
   - Connected to ECS tasks for persistent data storage.
9. **Public and Private Subnets**:
   - Public subnets for ALB, private subnets for ECS, Redis, and RDS.
10. **IAM Roles and Security Groups**:
   - IAM roles are assigned to secure access to backend services.
   - Security groups control network traffic at the component level.
11. **Highly Available Zones**:
    - ALB ensures traffic distribution across multiple zones for fault tolerance.
12. **CloudWatch and CloudTrail**:
    - Monitors and logs application performance and tracks resource changes for auditing.


---
## **Components and Workflow**

### **1. VPC Module**
- Creates a custom VPC with public and private subnets.
- Includes an Internet Gateway for public subnets.
- Exposes outputs like VPC ID and subnet IDs.

### **2. ECS Module**
- Provisions an ECS cluster with AWS Fargate.
- Includes autoscaling configurations to handle traffic spikes.
- Monitored using CloudWatch.

### **3. RDS Module**
- Deploys a MySQL database with Multi-AZ configurations.
- Autoscaling storage ensures cost-efficiency.

### **4. Redis Module**
- Sets up ElastiCache for Redis in private subnets.
- Multi-AZ replication for high availability.

### **5. Route 53 Module**
- Configures a hosted zone for managing DNS.
- Ensures secure routing with SSL certificates.

### **6. Monitoring and Security**
- **CloudWatch**:
  - Tracks ECS metrics (CPU, memory).
  - Monitors database performance.
- **Security Groups**:
  - Restrict access to resources.
- **IAM Roles**:
  - Provide least-privilege access.

---

## **CI/CD Pipeline**

The CI/CD pipeline in `terraform-ci-cd.yaml` automates:
1. Infrastructure provisioning with Terraform.
2. Docker image building and pushing to Amazon ECR.
3. Application deployment to ECS with zero downtime.

---

## **Features**

### **Autoscaling**
1. **ECS Task Autoscaling**:
   - **Dynamic Scaling**: Automatically adjusts the number of ECS tasks running on **AWS Fargate** based on traffic load.
   - **CloudWatch Metrics**:
     - Monitors CPU and memory usage for ECS tasks to trigger scaling events.
     - Thresholds are configured to handle traffic spikes during peak usage.
   - **Service Scaling**:
     - Minimum and maximum task limits ensure cost control and high availability.

2. **RDS Storage Autoscaling**:
   - **Storage Growth**: Amazon RDS automatically increases the storage capacity when nearing the current limit, avoiding downtime.
   - **Read Replicas**:
     - If implemented, additional read replicas can handle read-heavy workloads, improving performance.

3. **Application Load Balancer Autoscaling**:
   - ALB dynamically adjusts based on incoming traffic patterns to efficiently route requests to ECS tasks.

4. **Redis (ElastiCache) Autoscaling**:
   - Node replication ensures caching performance is optimized during high-traffic periods.

5. **AWS Lambda and Amazon SQS**:
   - Used for decoupling workloads and handling asynchronous tasks with scalable processing power.
   - Lambda functions scale automatically based on the number of events or messages in the SQS queue.

---

### **Monitoring**
1. **AWS CloudWatch**:
   - **Real-Time Metrics**:
     - Monitors ECS, RDS, Redis, and ALB performance metrics such as CPU, memory usage, and connection counts.
   - **Custom Dashboards**:
     - Provides detailed insights into application performance and resource utilization.
   - **CloudWatch Alarms**:
     - Configured for critical thresholds like CPU spikes, high memory usage, or database connection limits.
     - Sends alerts to the team via **SNS (Simple Notification Service)** for proactive issue resolution.

2. **AWS CloudTrail**:
   - **API Call Auditing**:
     - Tracks all API calls across AWS services, ensuring full visibility for security and compliance.
   - **Change Tracking**:
     - Logs changes in ECS, RDS, Redis, and network configurations for audit trails.

3. **AWS GuardDuty**:
   - Identifies and alerts on malicious activity or unauthorized behavior in the AWS environment.

4. **AWS Metrics Insights**:
   - Provides a powerful query language to analyze operational data across multiple services.

5. **ElastiCache Monitoring**:
   - Tracks Redis cache metrics like eviction count, hit rate, and latency to ensure optimal caching performance.

6. **Application Logs**:
   - Centralized logging via **CloudWatch Logs**, consolidating ECS task logs, Node.js application logs, and database logs.

---

### **Cost Efficiency**
1. **Fargate's Pay-As-You-Go Model**:
   - **Serverless Compute**:
     - Eliminates the need to manage EC2 instances, paying only for the vCPU and memory used by running tasks.
   - **Fine-Tuned Resource Allocation**:
     - Allocates just the required resources to ECS tasks, avoiding over-provisioning.

2. **RDS Optimized Instance Types**:
   - **Right-Sized Instances**:
     - Selects database instance types based on workload (e.g., `db.t3.micro` for cost efficiency).
   - **RDS Reserved Instances**:
     - Cost savings through reserved capacity for predictable workloads.
   - **Storage Autoscaling**:
     - Automatically scales storage to meet demand, avoiding unused capacity costs.

3. **Spot Instances for Non-Critical Workloads**:
   - **Cost-Effective Computing**:
     - Spot Instances can be utilized for batch processing or non-critical workloads.

4. **AWS Trusted Advisor**:
   - Provides insights on cost savings by identifying idle resources and recommending optimizations.

5. **AWS Cost Explorer**:
   - Tracks and forecasts spending trends to help budget and optimize costs.

6. **Reserved Capacity for ElastiCache**:
   - Locks in long-term Redis usage to save on costs.

7. **Optimized Network Data Transfers**:
   - Ensures that most data traffic occurs within the **private subnet** of the VPC to avoid public data transfer costs.

---

### **Security**
1. **Private Subnets**:
   - RDS and Redis are hosted in private subnets, completely inaccessible from the public internet.

2. **HTTPS via ALB**:
   - Secures data in transit between users and the application using SSL/TLS encryption.

3. **AWS WAF (Web Application Firewall)**:
   - Protects the application from common web threats, such as SQL injection, cross-site scripting (XSS), and DDoS attacks.

4. **IAM Roles and Policies**:
   - **Least Privilege Access**:
     - Ensures ECS tasks, Lambda functions, and other resources only have permissions necessary to perform their jobs.
   - **Fine-Grained Access Control**:
     - Policies restrict access to sensitive resources like RDS and ElastiCache.

5. **CloudTrail and GuardDuty**:
   - Tracks API activity and identifies suspicious behavior for enhanced security monitoring.

6. **Security Groups**:
   - Controls traffic flow:
     - Only allows traffic to RDS from ECS tasks.
     - Redis traffic is restricted to the ECS cluster.

7. **Data Encryption**:
   - **At Rest**:
     - RDS and ElastiCache data are encrypted using AWS-managed keys.
   - **In Transit**:
     - Encrypted using SSL/TLS for secure data flow.

8. **S3 Bucket Security**:
   - **IAM Policies**:
     - Ensures that only authorized users and resources can access the S3 bucket.
   - **Bucket Versioning**:
     - Maintains versions of files to recover from accidental deletions or overwrites.

9. **Periodic Security Audits**:
   - Regularly reviews security configurations using AWS Trusted Advisor and compliance tools.

10. **VPC Flow Logs**:
    - Tracks and analyzes traffic in and out of the VPC for network security insights.


---

## **Deployment Steps**

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd project-root
   ```

2. **Initialize and deploy infrastructure**:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

3. **Build the Docker image**:
   ```bash
   cd docker
   docker build -t webapp:latest .
   ```

4. **Push changes to GitHub**:
   - Triggers the CI/CD pipeline for deployment.

---

## **Key Benefits**
- **Scalability**: Handles traffic spikes using autoscaling.
- **Security**: Ensures data protection with IAM and security groups.
- **Cost Optimization**: Uses managed services for operational efficiency.
- **Monitoring**: Real-time metrics for proactive monitoring.

---

## **Future Enhancements**
- Integrate AWS WAF for web application security.
- Support for blue-green deployments in the pipeline.
- Add advanced tracing with AWS X-Ray.

--- 