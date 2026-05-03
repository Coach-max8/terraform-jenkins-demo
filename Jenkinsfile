```groovy
pipeline {
    agent any

    environment {
        AWS_SHARED_CREDENTIALS_FILE = '/var/jenkins_home/.aws/credentials'
        AWS_CONFIG_FILE = '/var/jenkins_home/.aws/config'
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select Terraform Action')
        choice(name: 'ENV', choices: ['dev'], description: 'Select Environment')
        choice(name: 'TYPE', choices: ['t2.micro', 't3.micro'], description: 'Select EC2 Type')
    }

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/Coach-max8/terraform-jenkins-demo.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -no-color'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                terraform plan -no-color \
                -var="region=us-east-1" \
                -var="instance_type=${params.TYPE}" \
                -var="environment=${params.ENV}"
                """
            }
        }

        stage('Approval') {
            steps {
                input message: 'Approve Terraform Action?', ok: 'Proceed'
            }
        }

        stage('Apply or Destroy') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        sh """
                        terraform apply -auto-approve -no-color \
                        -var="region=us-east-1" \
                        -var="instance_type=${params.TYPE}" \
                        -var="environment=${params.ENV}"
                        """
                    } else {
                        sh """
                        terraform destroy -auto-approve -no-color \
                        -var="region=us-east-1" \
                        -var="instance_type=${params.TYPE}" \
                        -var="environment=${params.ENV}"
                        """
                    }
                }
            }
        }

        stage('Outputs') {
            steps {
                sh 'terraform output -no-color || true'
            }
        }
    }

    post {
        success {
            echo 'Terraform Pipeline Completed Successfully'
        }

        failure {
            echo 'Terraform Pipeline Failed'
        }

        always {
            echo 'Pipeline Finished'
        }
    }
}
```
