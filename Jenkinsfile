def rstudioDocker
pipeline {
    agent {
        kubernetes {
            label 'molgenis'
        }
    }
    environment {
        ORG = 'molgenis'
        APP_NAME = 'rstudio'
        DOCKER_REGISTRY = 'registry.hub.docker.com'
    }
    stages {
        stage('Build: [ pull request ]') {
            when {
                changeRequest()
            }
            steps {
                container('maven') {
                    script {
                        rstudioDocker = docker.build("${DOCKER_REGISTRY}/${ORG}/${APP_NAME}:latest", "--pull --no-cache --force-rm .")
                    }
                }
            }
        }
        stage('Build [ master ]') {
            when {
                branch 'master'
            }
            steps {
                container('maven') {
                    script {
                        rstudioDocker = docker.build("${DOCKER_REGISTRY}/${ORG}/${APP_NAME}:latest", "--pull --no-cache --force-rm .")
                    }
                }
            }
        }
        stage('Release [ master ]') {
            when {
                branch 'master'
            }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    script {
                        input(
                                message: 'Do you want to release?',
                                ok: 'Release'
                        )
                    }
                }
                milestone 2
                container('maven') {
                    script {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'molgenis-jenkins-dockerhub-secret') {
                            echo "Publish ${APP_NAME} docker to [ hub.docker.com ]"
                            rstudioDocker.push("latest")
                            rstudioDocker.push("stable")
                        }
                    }
                }
            }
        }
    }
}