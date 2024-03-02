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
    }
    stages {
        stage('build') {
            steps {
                echo '----------- build started ----------'
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo '----------- build completed ----------'
            }
        }
        stage('test') {
            steps {
                echo '----------- unit test started ----------'
                sh 'mvn surefire-report:report'
                echo '----------- unit test completed ----------'
            }
        }
        stage('Jar Publish') {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url: registry, credentialsId: '652109e4-04f2-4dbb-abf7-402fa739452e'
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
                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }
        stage('Docker Build and Publish') {
            steps {
                script {
                    echo '<--------------- Docker Build and Publish Started --------------->'
                    def dockerImage = docker.build imageName + ':' + version
                    docker.withRegistry(registry, '652109e4-04f2-4dbb-abf7-402fa739452e') {
                        dockerImage.push()
                    }
                    echo '<--------------- Docker Build and Publish Ended --------------->'
                }
            }
        }
    }
}
