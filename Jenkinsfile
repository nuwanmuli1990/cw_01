pipeline {
  environment {
   	 PROJECT = "etfbpipeline"
 	   APP_NAME = "etfbcore3febu"
     BRANCH_NAME = "deployment_fe"
     PORT = "5070"
   	 IMAGE_TAG = "${PROJECT}/${APP_NAME}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
                }
    agent none 
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') {
            agent {
                docker {
      image 'maven'
      args '-v /root/.m2:/root/.m2'
     }
            }
         steps {
            sh "mvn -f pom.xml -Dmaven.test.skip=true clean install -X"
          }
        }
  	stage('Test') {
              agent {
                docker {
      image 'maven'
      args '-v /root/.m2:/root/.m2'
     }
            }
            steps {
                sh 'mvn test'
            }
        }
        stage('Deliver') {
            agent {
                docker {
      image 'maven'
      args '-v /root/.m2:/root/.m2'
     }
            }
          steps {
               sh 'bash ./jenkins/scripts/deliver-allbu.sh'
               sh 'bash ./jenkins/scripts/kill.sh'
         }
        }
		stage('Building & Deploy Image') {
            agent {
                docker {
      image 'ravialuthge/gcp:latest'
      args '-v /root/.m2:/root/.m2'
     }
            }
		    steps{
					sh 'mkdir -p dockerImage'
					sh 'cp Dockerfile dockerImage/'
					sh 'cp target/demo-0.0.1-SNAPSHOT.jar dockerImage/'
					sh 'docker build --tag=${APP_NAME} dockerImage/.'
					sh 'docker tag ${APP_NAME} ${IMAGE_TAG}'
					
          sh 'docker image rm ${IMAGE_TAG}'
          sh 'docker image rm ${APP_NAME}'
          sh 'rm -rf dockerImage/'          
        }
        }
        stage('Deploy cluster') {
              agent {
                 docker {
                       image 'ravialuthge/gcp:latest' 
                         args '-v /root/.m2:/root/.m2'   
                        }
                    }
              steps {
                  sh 'mkdir -p /root/.kube/'
                  sh 'mkdir -p /etc/kubernetes/pki/'
                  sh 'cp /root/.m2/config /root/.kube/'
                  sh 'cp /root/.m2/ca.crt /etc/kubernetes/pki/'
                  sh '''cat <<EOF > deployment.yaml
apiVersion: apps/v1                  
kind: Deployment
metadata:
  name: ${APP_NAME}-deploy
spec:
  selector:
    matchLabels:
      app: ${APP_NAME}-deploy
      department: stage
  replicas: 1
  template:
    metadata:
      labels:
        app: ${APP_NAME}-deploy
        department: stage
    spec:
      containers:
      - name: ${APP_NAME}
        image: ${IMAGE_TAG}
        env:
        - name: "PORT"
          value: "${PORT}"
      imagePullSecrets:
      - name: registry-secret
EOF'''
               sh 'kubectl apply -f deployment.yaml'
               sh '''cat <<EOF > service.yaml
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}-service
spec:
  selector:
    app: ${APP_NAME}-deploy
  ports:
    - name: http
      protocol: TCP
      port: ${PORT}
      targetPort: ${PORT}
  externalIPs:
    - 192.168.1.181
EOF'''
               sh 'kubectl apply -f service.yaml'               
                  }
        }
            }
          //  post {
          //    success {
          //       mail to: 'pamitha.lakbodha@inovaitsys.com',
          //                subject: "Success Pipeline: ${currentBuild.fullDisplayName}",
          //                body: "${env.BRANCH_NAME}/${env.BUILD_NUMBER}"
            //         }
          //    failure {
           //         mail to: 'ravi.aluthge@inovaitsys.com',
            //          cc: 'pamitha.lakbodha@inovaitsys.com',
            //              subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
            //              body: "Something is wrong with ${env.BUILD_URL}"
             //         }
           //     } 
}
