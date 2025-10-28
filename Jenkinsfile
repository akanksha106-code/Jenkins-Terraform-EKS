pipeline {
    agent any

    parameters {
        choice(
            name: 'action',
            choices: ['apply', 'destroy'],
            description: 'Choose Terraform action'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_Access_Key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_Secret_Key')
        AWS_DEFAULT_REGION    = 'us-east-1'
        TF_PLUGIN_CACHE_DIR   = "${WORKSPACE}/.terraform.d/plugin-cache"
        TF_DATA_DIR           = "${WORKSPACE}/.terraform-data"
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/akanksha106-code/Jenkins-Terraform-EKS.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh '''
                        rm -rf .terraform .terraform.lock.hcl
                        mkdir -p $TF_PLUGIN_CACHE_DIR $TF_DATA_DIR
                        terraform init -upgrade
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
                input message: "Approve Terraform ${params.action}?", ok: "Proceed"
            }
        }

        stage('Terraform Apply/Destroy') {
            steps {
                dir('terraform') {
                    sh "terraform ${params.action} --auto-approve"
                }
            }
        }
    }

    post {
        success {
            echo "Terraform ${params.action} completed successfully."
        }
        failure {
            echo "Terraform ${params.action} failed."
        }
        always {
            cleanWs()
        }
    }
}
