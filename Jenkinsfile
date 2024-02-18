pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    stages('Clone-code') {
        steps {
            git banch: 'main', url: 'https://github.com/YugamAggarwal/first-java-project.git'
        }
    }
}
