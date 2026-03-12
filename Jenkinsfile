pipeline {
    agent any

    parameters {
        choice(
            name: 'TF_DIR',
            choices: ['terraform-insecure', 'terraform'],
            description: 'Choose insecure or secure Terraform directory'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Show Selected Terraform Directory') {
            steps {
                echo "Using Terraform directory: ${params.TF_DIR}"
            }
        }

        stage('Infrastructure Security Scan') {
            steps {
                bat "trivy config --exit-code 1 ${params.TF_DIR}"
            }
        }

        stage('Terraform Init') {
            when {
                expression { params.TF_DIR == 'terraform' }
            }
            steps {
                dir("${params.TF_DIR}") {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            when {
                expression { params.TF_DIR == 'terraform' }
            }
            steps {
                dir("${params.TF_DIR}") {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.TF_DIR == 'terraform' }
            }
            steps {
                dir("${params.TF_DIR}") {
                    bat 'terraform plan'
                }
            }
        }
    }
}