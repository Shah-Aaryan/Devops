def call(String sonarToolName, String projectKey, String projectName) {
    withSonarQubeEnv(sonarToolName) {
        sh """
            ${tool(sonarToolName)}/bin/sonar-scanner \
              -Dsonar.projectKey=${projectKey} \
              -Dsonar.projectName=${projectName} \
              -Dsonar.sources=.
        """
    }
}
