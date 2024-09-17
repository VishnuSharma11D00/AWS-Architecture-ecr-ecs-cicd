# AWS-Architecture:  ECR-ECS CICD (Complete implementation using terraform)
Launching Complete AWS Architecture made easy using **Terraform**.
## **_With only 3 simple steps_**.

## Architecture Diagram
![screenshot](time-off_Architecture(updated).jpg)

## Resources
- AWS Account
- Terraform as IaC
- GitHub for code hosting
- Application Packages and Dockerfile

## Introduction
This is an highly secure, and highly available AWS architecture that I have meticulously crafted. Using Terraform, I streamlined the implementation for **_easy deployment_**. The application runs on AWS Elastic Container Service (ECS) - Fargate, showcasing **_serverless technology and cost optimization_**. It's designed for **_maximum availability_** with a load balancer across two Availability Zones (AZs) and autoscaling. Security is paramount, with the application hosted in private subnets. The deployment process is fully automated via an AWS CI/CD pipeline _which is also implemented using terraform_, ensuring **_seamless updates and continuous delivery_**. This architecture exemplifies cutting-edge cloud solutions and sets a new standard in efficiency and **_security_**.
## Repo Info
In this Repository, 
1. Terraform folder - contains descriptive codes for implementating resources in AWS
2. README.md file
3. time-off_Architecture.drawio.png file - AWS Architecture Diagram


## Codes and Instructions
### Pre-Requisites
1. AWS Account - AWS User Permissions with appropriate permissions like AmazonEC2ContainerRegistryFullAccess.
2. Terraform
3. Git-Hub Account
4. builspec.yml for Code Build

## Instructions
1. **Connect GITHUB using aws_codestar_connection**
   The reason you would use a CodeStar Connection for a GitHub repository in your CodePipeline is to provide a secure and managed way to connect your AWS resources to your external GitHub repository.
   Steps:
      - Open AWS Console
      - Go to CodePipeline Page
      - In the sidebar, go to settings and under settings, click Connections
      - **Create connection** , from here everything is straight forward.    
   
2. **Edit local.tf & environment variables in cicd.tf**
   - In the above files go to Terraform/local.tf. Edit the variables according to your credentials and project needs.
     If you are performing the current project, then just edit:
        1. bucket_name
        2. codestar_connection_arn
        3. codestar_connection_name
        4. artifact_store_bucket_name
        5. AWS_ACCOUNT_ID
   - After editing local.tf, go to Terraform/modules/CICD/cicd.tf and scroll down to # CodeBuild Project. Here you can edit the environment variables according to your buildspec.yml.
     If you are performing the current project, then leave it as such. editing the local.tf is enough.
3. **Create Complete Architecture**
   - Now once the variables and environment variables are set correctly,
   - Launch Infrastructure:
   ```sh
   terraform plan      #check before applying
   ```
   ```sh
   terraform apply
   ```
   This may take some time to execute.

After the Infrastructure is launched you can access the application from **load balancer https url**.

### Output
The website should be accessable with load balancer DNS link.
We have configured Fully automated AWS Architecture in even fewer simple steps than the previous version of this project. 
 #### **Congrats! Now your web application is hosted.**

## **Terminate**
- This is the crucial part of this project to save costs, Delete Code Pipeline and Code Build project from Console.
- Firstly, empty the S3 bucket created for artifact store and tfstate. Next, Delete all the images created in the ECR.
- Now go to Terraform terminal and run:
  ```sh
  terraform destroy
  ```
- This will destroy all the resources that were launched, saving the time and work for you.
- Once again, this projects proves to make your job easy by implementing the resources via terraform.

# Terraform Files Description
- **Terraform**
     - main.tf -> This final code structure of all components used in the project
     - local.tf -> This is a variable file, used for customizing the names of resources and providing account information for the code to run.
     - provider.tf -> This file specifies terraform which cloud provider are we using and the region.
     - **modules**
          - **tfstate**
             - tfstate.tf -> creating resources (S3, Dynamodb), to maintain remote tfstate
             - variables.tf -> variables
             - output.tf -> output of bucket id and bucket arn that are created.      
          -**vpc**
               - VPC.tf -> all the resources needed to create vpc
               - variables.tf -> variables
               - output.tf -> output of vpc and subnet ids that are created.
               - terraform.tfvars -> used for giving vpc and subnet cidrs
           - **ecr**
               - ecs.tf -> resources created for ecr
               - variables.tf -> variables
               - output.tf -> output of repository url after creation.
            - **ecs**
               - ecs.tf -> resources created for ecs
               - data.tf -> iam policy document
               - variables.tf -> variables
            - **CICD**
               - cicd.tf -> resources created for cicd
               - data.tf -> iam policy document
               - variables.tf -> variables  


               
# Customization 
### Use EFS with Fargate
  - Amazon Elastic File System (Amazon EFS) provides simple, scalable file storage for use with your Amazon ECS tasks. With Amazon EFS, storage capacity is elastic. It grows and shrinks automatically as you add and remove files. Your applications can have the storage they need and when they need it. 

### Adding more AZs for HA:
  - I have made the Terraform code very easy to understand and update. You can just edit the vpc.tf in vpc module by adding more AZs and updating the resources accordingly.
     
### Using WAF on top of load balancer:
  - Adding a Web Application Firewall helps protect web applications by filtering and monitoring HTTP traffic between a web application and the Internet.

### DynamoDB for Database service
  - Since we are hosting application in ECS Fargate, use DynamoDB to make this a complete serverless architecture.

### Security Groups and NACL
   - customize Security groups and NACL rules accordingly. These are very crucial to protect your application.

# Feedback
Please report any issues or feedback to vishnusharma11d00@gmail.com
