pipeline {
  environment {
   	 PROJECT = "cw_pipeline"
 	 APP_NAME_CW = "cw_01"
 	 BRANCH_NAME = "dev_branch"
   	 IMAGE_TAG_CW = "${PROJECT}/${APP_NAME}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
                }
    agent any 
    options {
        skipStagesAfterUnstable()
    }
    stages {

        stage('Cw') {
          stages {
            stage('Build & Test Cw') {
         steps {
            sh "mvn clean install -X"
            sh 'bash ./jenkins/scripts/runtest.sh'
            sh 'bash ./jenkins/scripts/kill.sh'
          }
        }
		stage('Building & Deploy Image Cw') {
		    steps{
					sh 'mkdir -p dockerImage'
					sh 'cp Dockerfile dockerImage/'
					sh 'cp target/demo-0.0.1-SNAPSHOT.jar dockerImage/'
					sh 'docker build --tag=${APP_NAME} dockerImage/.'
					sh 'docker tag ${APP_NAME} ${IMAGE_TAG}'
					sh 'rm -rf dockerImage/'       
        }
        }
        stage('Deploy cluster Cw') {
             steps {
               sh 'kubectl set image deployment/cw_01  cw_01=${IMAGE_TAG_CW}  --record -n staging'
}
}
        }
        }

            }
}
