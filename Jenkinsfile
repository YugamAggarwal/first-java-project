def registry = 'https://yugam.jfrog.io'
def imageName = 'image-docker-local/first-java-project'
def version = '2.1.2'

pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
        DOCKER_REGISTRY = 'https://yugam.jfrog.io/artifactory/image-docker-local'
        DOCKER_CREDENTIALS_ID = '652109e4-04f2-4dbb-abf7-402fa739452e'
    }
    stages {
        stage('Build') {
            steps {
                echo '----------- Build started ----------'
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo '----------- Build completed ----------'
            }
        }
        stage('Jar Publish') {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url: registry + '/artifactory', credentialsId: DOCKER_CREDENTIALS_ID
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "final-libs-release-local/{1}",
                                "flat": "false",
                                "props": "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    def app = docker.build("${registry}/artifactory/${imageName}:${version}")
                    echo '<--------------- Docker Build Ended --------------->'
                }
            }
        }
        stage('Docker Publish') {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'
                    docker.withRegistry(DOCKER_REGISTRY, DOCKER_CREDENTIALS_ID) {
                        app.push("${version}")
                    }
                    echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }
    }
}
