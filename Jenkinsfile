def registry = 'https://yugam.jfrog.io/'

def imageName = 'yugam.jfrog.io/fjp-docker-docker-local/fjp-docker-image'
def version   = '2.1.2'

pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64'
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
                    def server = Artifactory.newServer url:registry + '/artifactory' ,  credentialsId:'652109e4-04f2-4dbb-abf7-402fa739452e'
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
                    app = docker.build(imageName + ':' + version)
                }
            }
        }
        stage('Docker Publish') {
            steps {
                script {
                    docker.withRegistry(registry, '652109e4-04f2-4dbb-abf7-402fa739452e') {
                        app.push()
                    }
                }
            }
        }
    }
}
