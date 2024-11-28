// Once 70-ecr, images are created in ecr repository, then we need to login into ecr repo, build and push the image into ecr, we will get these commands in ECR under created image name, we need to provide these details in Deploy stage here.
pipeline {

    agent {
        label 'AGENT-1'
    }
    
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    environment {
        //DEBUG = 'true'
        appVersion = '' //its global can be used for any stage and for any section
        region = 'us-east-1'  //all these for Deploy stage into ECR
        account_id = '022499022353'
        project = 'expense'
        environment = 'dev'
        component = 'backend'
        }

    stages {
        
        stage("Reading the version") {

            steps {

                script {

                    def packageJson = readJSON file: 'package.json'  //this will read the entire package.json into packageJson variable as defined here. To read the version we installed Pipeline Utility Steps Plugin.
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

        stage("Building the docker Image and Pushing into ECR") {  //Here we need to push to ECR which is a aws service, we shouldnt push to dockerhub(our public repositories)
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-creds') {
                    sh """
                    aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.us-east-1.amazonaws.com

                    docker build -t ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${environment}/${component}:${appVersion} .

                    docker images

                    docker push ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${environment}/${component}:${appVersion}
                        
                    """

                }

                
            }

            
        }

        stage("Deploy") {

            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-creds') {
                    sh """
                    aws eks update-kubeconfig --region ${region} --name ${project}-${environment}
                    cd helm
                    sed -i 's/IMAGE_VERSION/${appVersion}/g' values-${environment}.yaml
                    helm upgrade --install ${component} -n ${project} -f values-${environment}.yaml . 
                    """

                }
            }
            
            
        }


    }

    post {

        always {
            echo "This prints always irrespective of above stage section success or failes"
            //deleteDir()
        }

        success {
            echo "This is printed as above stages are successful"
        }

        failure {
            echo "This is printed as above stages are failed"
        }
    }

}
