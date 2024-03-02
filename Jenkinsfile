def registry = 'yugam.jfrog.io'
def imageName = 'artifactory/image-docker-local/first-java-project'
def version = '2.1.2'

pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }
    stages {
        stage('Build Stage') {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('Jar Publish') {
            steps {
                script {
                    def server = Artifactory.newServer url: "https://${registry}/artifactory", credentialsId: '652109e4-04f2-4dbb-abf7-402fa739452e'
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "final-libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                }
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    app = docker.build("${registry}/${imageName}")
                }
            }
        }
        stage('Docker Publish') {
            steps {
                script {
                    docker.withRegistry("${registry}", '652109e4-04f2-4dbb-abf7-402fa739452e') {
                        app.push("${version}")
                    }
                }
            }
        }
    }
}
