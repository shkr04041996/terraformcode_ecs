pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials ('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout your Terraform code repository
                git 'https://github.com/shkr04041996/terraformcode_ecs.git'
            }
        }
        
        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                // Generate Terraform plan
                sh 'terraform plan -out=tfplan'
            }
        }
        
        stage('Terraform Apply') {
            steps {
                // Apply Terraform changes
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
