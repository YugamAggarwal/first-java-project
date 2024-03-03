def registry = 'https://yugam.jfrog.io'
def imageName = 'yugam.jfrog.io/image-docker-local/first-java-project'
def version   = '2.1.2'
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
        stage('Build') {
            steps {
                echo '----------- Build Started ----------'
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo '----------- Build Completed ----------'
            }
        }
        stage('Publish .jar File') {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
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
                    echo '<--------------- Jar Publish Completed --------------->'
                }
            }
        }
        stage(' Docker Image Build ') {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build(imageName + ':' + version)
                    echo '<--------------- Docker Build Completed --------------->'
                }
            }
        }
        stage(' Publish Docker Image ') {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'
                    docker.withRegistry(registry, '652109e4-04f2-4dbb-abf7-402fa739452e') {
                        app.push()
                    }
                    echo '<--------------- Docker Publish Completed --------------->'
                }
            }
        }
        stage(' Deploy ') {
            steps {
                script {
                    echo '<--------------- Helm Deploy Started --------------->'
                    sh 'helm upgrade fjp fjp-0.1.0.tgz'
                    echo '<--------------- Helm deploy Completed --------------->'
                }
            }
        }
    }
}
