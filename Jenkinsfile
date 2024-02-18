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
            tools {
                jdk 'jdk11' // the name you have given the JDK installation using the JDK manager (Global Tool Configuration)
            }
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('Sonar Analysis') {
            tools {
                jdk 'jdk17' // the name you have given the JDK installation using the JDK manager (Global Tool Configuration)
            }
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
