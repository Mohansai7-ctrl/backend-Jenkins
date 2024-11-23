pipeline {

    agent {
        label 'AGENT-1'
    }
    
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    environment {
        DEBUG = 'true'
        appVersion = '' //its global can be used for any stage and for any section
        }

    stages {
        
        stage("Reading the version") {

            steps {

                script {

                    def packageJson = readJSON file: 'package.json'  //this will read the entire package.json into packageJson variable as defined here.
                    appVersion = packageJson.version // so the version in package.json will get into appVersion
                    echo "App version: ${appVersion}"

                }

            }
 
        }

        stage("Installing the dependencies") {

            steps {
                sh 'npm install' //but this wont occur, before this 1)login into AGNET-1 and 2)then install npm and 3)then install docker and 4)add docker as secondary group for ec2-user 5)finally restart the AGENT-1 in the Jenkins
            }


        }

        stage("Building the docker Image") {
            steps {
                sh """
                docker build -t mohansai7/backend:${appVersion} .
                docker images
                """

            }

            
        }

        stage("pushing the image into ECR") {
            steps {
                echo "This built image to be pushed to AWS ECR"

            }
            
        }

        stage ("Deploying via EKS") {
            steps {
                echo "This needs to be deployed via Kubernetes EKS"

            }
            
        }

    }

    post {

        always {
            echo "This prints always irrespective of above stage section success or failes"
            deleteDir()
        }

        success {
            echo "This is printed as above stages are successful"
        }

        failure {
            echo "This is printed as above stages are failed"
        }
    }

}
