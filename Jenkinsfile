pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = '878436876448.dkr.ecr.ap-south-1.amazonaws.com/chatapp'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Clone Code') {
            steps {
                git url: 'https://github.com/ParthG26/ChatApp-Deployment-through-Kubernetes-and-Jenkins.git', branch: 'main'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $ECR_REPO:$IMAGE_TAG .
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker push $ECR_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Update Deployment Manifest and Push to GitHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-pat', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh '''
                    git config --global user.email "jenkins@Parth.com"
                    git config --global user.name "Jenkins CI"
                    
                    if [ -d "Chatapp-Deployment-Using-Jenkins-Kubenetes-ArgoCD" ]; then
                        rm -rf Chatapp-Deployment-Using-Jenkins-Kubenetes-ArgoCD
                    fi
                    
                    git clone https://$GIT_USER:$GIT_TOKEN@github.com/ParthG26/Chatapp-Deployment-Using-Jenkins-Kubenetes-ArgoCD.git
            
                    sed -i 's|image: .*/chatapp:.*|image: 878436876448.dkr.ecr.ap-south-1.amazonaws.com/chatapp:'"$IMAGE_TAG"'|' Chatapp-Deployment-Using-Jenkins-Kubenetes-ArgoCD/Backend/backend-deployment.yml

                    cd Chatapp-Deployment-Using-Jenkins-Kubenetes-ArgoCD
                    git add Backend/backend-deployment.yml
                    git commit -m "CI: Update image to tag $IMAGE_TAG"
                    git push origin main
                    '''
                }
            }
        }
    }
}
