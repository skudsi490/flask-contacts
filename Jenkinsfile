pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id') 
        DOCKERHUB_REPO = 'skudsi'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/skudsi490/flask-contacts.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    docker.build("${env.DOCKERHUB_REPO}/contacts-web", "-f docker/web/Dockerfile .")
                    docker.build("${env.DOCKERHUB_REPO}/contacts-db", "-f docker/db/Dockerfile .")
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image("${env.DOCKERHUB_REPO}/contacts-web").push('latest')
                        docker.image("${env.DOCKERHUB_REPO}/contacts-db").push('latest')
                    }
                }
            }
        }

        stage('Run Docker Containers') {
            steps {
                sh """
                docker rm -f contacts-web contacts-db || true
                docker run -d --name contacts-db -e POSTGRES_DB=contacts_db -e POSTGRES_USER=contacts_user -e POSTGRES_PASSWORD=contacts_pass ${env.DOCKERHUB_REPO}/contacts-db
                docker run -d --name contacts-web --link contacts-db:db -p 5000:5000 ${env.DOCKERHUB_REPO}/contacts-web
                """
            }
        }
    }
}
