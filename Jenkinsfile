pipeline {
    agent {label 'alisa'}
    parameters {
        string(name: 'CLIENT_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
    }
    
    stages {
        stage("Validate Parameters") {
            steps {
                script {
                    if (params.CLIENT_DOCKER_TAG == '' || params.BACKEND_DOCKER_TAG == '') {
                        error("CLIENT_DOCKER_TAG and BACKEND_DOCKER_TAG must be provided.")
                    }
                }
            }
        }
        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
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
                        docker build -t alisameed/playback-space-backend-beta:${params.BACKEND_DOCKER_TAG} .
                    """
                }
                dir('client'){
                    sh """
                        docker build -t alisameed/playback-space-client-beta:${params.CLIENT_DOCKER_TAG} .
                    """
                }
            }
        }
        
    }

}