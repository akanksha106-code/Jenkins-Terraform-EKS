pipeline {
    agent any

    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Choose Terraform action')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_Access_Key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_Secret_Key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Clone the Code') {
            steps {
                git branch: 'main', url: 'https://github.com/akanksha106-code/Jenkins-Terraform-EKS.git'
            }
        }

        stage('Terraform Initialization') {
            steps {
                dir('terraform') {
                    sh '''
                        echo "🧹 Cleaning old Terraform files..."
                        rm -rf .terraform .terraform.lock.hcl

                        echo "🚀 Initializing Terraform (upgrade mode)..."
                        terraform init -upgrade
                    '''
                }
            }
        }

        stage('Terraform Validation') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Infrastructure Checks') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
                input(message: "Approve deployment?", ok: "Proceed")
            }
        }

        stage('Create/Destroy EKS Cluster') {
            steps {
                dir('terraform') {
                    sh "terraform ${params.action} --auto-approve"
                }
            }
        }
    }
}
