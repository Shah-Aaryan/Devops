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
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    dir('backend'){
                        sh """
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker build -t alisameed/playback-space-backend-beta:${params.BACKEND_DOCKER_TAG} .
                        """
                    }
                    dir('client'){
                        sh """
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker build -t alisameed/playback-space-client-beta:${params.CLIENT_DOCKER_TAG} .
                        """
                    }
                }
            }
        }
        
        stage("Docker: Push to DockerHub"){
            steps{
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push alisameed/playback-space-backend-beta:${params.BACKEND_DOCKER_TAG}
                        docker push alisameed/playback-space-client-beta:${params.CLIENT_DOCKER_TAG}
                    """
                }
            }
        }
    }
    post{
        success{
            //archiveArtifacts artifacts: '*.xml', followSymlinks: false
            build job: "playback-space-CD", parameters: [
                string(name: 'CLIENT_DOCKER_TAG', value: "${params.CLIENT_DOCKER_TAG}"),
                string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
            ]
        }
    }
}