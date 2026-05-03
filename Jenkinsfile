pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose Action')
        choice(name: 'ENV', choices: ['dev'], description: 'Environment')
        choice(name: 'TYPE', choices: ['t2.micro', 't3.micro'], description: 'EC2 Type')
    }

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/Coach-max8/terraform-jenkins-demo.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                terraform plan \
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
                        terraform apply -auto-approve \
                        -var="region=us-east-1" \
                        -var="instance_type=${params.TYPE}" \
                        -var="environment=${params.ENV}"
                        """
                    } else {
                        sh """
                        terraform destroy -auto-approve \
                        -var="region=us-east-1" \
                        -var="instance_type=${params.TYPE}" \
                        -var="environment=${params.ENV}"
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Completed Successfully'
        }
        failure {
            echo 'Failed'
        }
    }
}
