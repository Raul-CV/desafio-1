pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        // stage('Checkout') {
        //     steps {
        //         git 'https://github.com/Raul-CV/desafio-1.git'  // Cambia esto a tu repositorio
        //     }
        // }

        stage('Terraform Inicia') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}