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
        stage('build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage ("Sonar Analysis") {
            environment {
               scannerHome = tool 'sonar-scanner'
               
            }
            steps {
                withSonarQubeEnv('sonar-qube-server') {    
                    sh "${scannerHome}/bin/sonar-scanner"
                }    
               
            }   
        }
    }
}
