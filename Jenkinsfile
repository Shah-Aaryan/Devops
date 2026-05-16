pipeline {
    agent {label 'alisa'}
    parameters {
        string(name: 'CLIENT_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
    }
    
    stages {
        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
                }
            }
        }

        stage("Set Image Tags") {
            steps {
                script {
                    env.CLIENT_TAG = params.CLIENT_DOCKER_TAG?.trim() ? params.CLIENT_DOCKER_TAG.trim() : "latest"
                    env.BACKEND_TAG = params.BACKEND_DOCKER_TAG?.trim() ? params.BACKEND_DOCKER_TAG.trim() : "latest"
                }
            }
        }
        
        stage('Git: Code Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: "*/main"]],
                    userRemoteConfigs: [[
                        url: "https://github.com/Shah-Aaryan/Devops.git"
                    ]]
                ])
            }
        }
        
        stage("Trivy: Filesystem scan"){
            steps{
                sh '''
                    trivy fs --exit-code 0 \
                             --severity HIGH,CRITICAL \
                             --format table \
                             -o trivy-fs-report.html \
                             .
                '''
            }
        }

        stage("Docker: Build Images"){
            steps{
                dir('backend'){
                    sh """
                        docker build -t alisameed/playback-space-backend-beta:${env.BACKEND_TAG} .
                    """
                }
                dir('client'){
                    sh """
                        docker build -t alisameed/playback-space-client-beta:${env.CLIENT_TAG} .
                    """
                }
            }
        }
        
    }

}