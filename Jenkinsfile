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
            environment {
                JAVA_HOME = tool 'JDK11' // Assuming JDK11 is configured in Jenkins tools
            }
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('Sonar Analysis with Java 17') {
            environment {
                JAVA_HOME = tool 'JDK17' // Assuming JDK17 is configured in Jenkins tools
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
