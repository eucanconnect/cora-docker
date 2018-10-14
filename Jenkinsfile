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
    }
    stages {
        stage('Build: [ pull request ]') {
            when {
                changeRequest()
            }
            steps {
                container('maven') {
                    script {
                        echo "Build RStudio docker [ ${ORG}/${APP_NAME}:latest ]"
                        rstudioDocker = docker.build("${ORG}/${APP_NAME}:latest", "--pull --no-cache --force-rm .")
                    }
                }
            }
        }
        stage('Build [ master ]') {
            steps {
                sh "echo Test ${ORG}/${APP_NAME} docker-image [ ${APP_NAME}:latest]"
            }
        }
        stage('Release [ master ]') {
            steps {
                container('maven') {
                    script {
                        docker.withRegistry("https://registry.hub.docker.com", 'molgenis-jenkins-dockerhub-secret') {
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