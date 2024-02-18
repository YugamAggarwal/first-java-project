pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH" // Update the PATH to point to Java 17
        JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64" // Set JAVA_HOME to Java 17
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
