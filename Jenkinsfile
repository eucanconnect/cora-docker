pipeline {
    agent {
        kubernetes {
            label 'molgenis'
        }
    }
    environment {
        TIMESTAMP = sh(returnStdout: true, script: "date -u +'%F_%H-%M-%S'").trim()
    }
    stages {
        stage("Retrieve secrets") {
            steps {
                container('vault') {
                    script {
                        env.GITHUB_TOKEN = sh(script: 'vault read -field=value secret/ops/token/github', returnStdout: true)
                    }
                }
            }
        }
        stage('Build: [ pull request ]') {
            when {
                changeRequest()
            }
            steps {
                script {
                    def projectFolders = sh(returnStdout: true, script: 'ls -d */').trim().split('\n')
                    for (String projectFolder : projectFolders) {
                        // remove trailing slash
                        def project = projectFolder.replaceAll("/\\z", "");
                        dir(project) {
                            def subFolders = sh(returnStdout: true, script: 'ls -d */').trim().split('\n')
                            for (String subFolder : subFolders) {
                                // remove trailing slash
                                def dockerFolder = subFolder.replaceAll("/\\z", "");
                                dir(dockerFolder) {
                                    container('maven') {
                                        docker.build("${LOCAL_REGISTRY}/datashield/${dockerFolder}:dev", "--pull --no-cache --force-rm .")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        stage('Build: [ master ]') {
            when {
                branch 'master'
            }
            steps {
                script {
                    def projectFolders = sh(returnStdout: true, script: 'ls -d */').trim().split('\n')
                    for (String projectFolder : projectFolders) {
                        // remove trailing slash
                        def project = projectFolder.replaceAll("/\\z", "");
                        dir(project) {
                            def subFolders = sh(returnStdout: true, script: 'ls -d */').trim().split('\n')
                            for (String subFolder : subFolders) {
                                // remove trailing slash
                                def dockerFolder = subFolder.replaceAll("/\\z", "");
                                def tag = dockerFolder + '-latest-' + env.TIMESTAMP
                                dir(dockerFolder) {
                                    container('maven') {
                                        docker.withRegistry("https://${LOCAL_REGISTRY}", "datashield-jenkins-registry-secret") {
                                            def master = docker.build("${LOCAL_REGISTRY}/datashield/${dockerFolder}:${tag}", "--pull --no-cache --force-rm .")
                                            master.push(tag)
                                        }

                                    }
                                }

                            }
                        }
                    }
                }
            }
        }
        stage('Steps - Release: [ master ]') {
            when {
                branch 'master'
            }
            stages {
                stage('Push released images') {
                    steps {
                        timeout(time: 40, unit: 'MINUTES') {
                            script {
                                input(
                                        message: 'Do you want to release?',
                                        ok: 'Release'
                                )
                            }
                        }
                        milestone 2
                        script {
                            def projectFolders = sh(returnStdout: true, script: 'ls -d */ | grep -v "^.*@.*$"').trim().split('\n')
                            for (String projectFolder : projectFolders) {
                                // remove trailing slash
                                def project = projectFolder.replaceAll("/\\z", "");
                                dir(project) {
                                    def subFolders = sh(returnStdout: true, script: 'ls -d */ | grep -v "^.*@.*$"').trim().split('\n')
                                    for (String subFolder : subFolders) {
                                        // remove trailing slash
                                        def dockerFolder = subFolder.replaceAll("/\\z", "");
                                        def tag = dockerFolder + '-release-' + env.TIMESTAMP
                                        dir(dockerFolder) {
                                            container('maven') {
                                                docker.withRegistry("https://${DOCKER_REGISTRY}", "datashield-jenkins-dockerhub-secret") {
                                                    def release = docker.build("${DOCKER_REGISTRY}/datashield/${dockerFolder}:${tag}", "--pull --no-cache --force-rm .")
                                                    release.push(tag)
                                                }
                                            }
                                        }
                                        script {
                                            sh "git remote set-url origin https://${GITHUB_TOKEN}@github.com/molgenis/molgenis-ops-docker.git"
                                            sh "git checkout -f ${BRANCH_NAME}"
                                            sh "git tag ${tag}"
                                            sh "git push --tags origin ${BRANCH_NAME}"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}