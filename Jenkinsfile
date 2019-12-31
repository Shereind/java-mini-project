pipeline {
    agent {
        dockerfile {
            args '-v /root/.m2:/root/.m2 -v /var/lib/jenkins/.m2/settings.xml:/usr/share/maven/conf/settings.xml'
        }
     }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') { 
            steps {
                sh './jenkins/scripts/deliver.sh' 
            }
        }
    }
}
