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
        stage('Build with Java 11') {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('Sonar Analysis with Java 17') {
            environment {
                scannerHome = tool 'sonar-scanner'
            }
            steps {
                echo '<--------------- Sonar Analysis started  --------------->'
                withSonarQubeEnv('sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                    echo '<--------------- Sonar Analysis stopped  --------------->'
                }
            }
        }
    }
}
