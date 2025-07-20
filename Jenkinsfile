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
                script {
                    try {
                        echo "Cloning application code..."
                        git url: 'https://github.com/ParthG26/ChatApp-Deployment-through-Kubernetes-and-Jenkins.git', branch: 'main'
                    } catch (err) {
                        error "Failed to clone repository: ${err}"
                    }
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    try {
                        echo "Logging into AWS ECR..."
                        sh '''
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                        '''
                    } catch (err) {
                        error "ECR login failed: ${err}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        echo "Building Docker image..."
                        sh '''
                        docker build -t $ECR_REPO:$IMAGE_TAG .
                        '''
                    } catch (err) {
                        error "Docker image build failed: ${err}"
                    }
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                script {
                    try {
                        echo "Pushing image to AWS ECR..."
                        sh '''
                        docker push $ECR_REPO:$IMAGE_TAG
                        '''
                    } catch (err) {
                        error "Failed to push Docker image to ECR: ${err}"
                    }
                }
            }
        }

        stage('Update Deployment Manifest and Push to GitHub') {
            steps {
                script {
                    try {
                        echo "Updating deployment manifest with new image tag and pushing to GitHub..."
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
                            git commit -m "CI: Update image to tag $IMAGE_TAG" || echo "No changes to commit"
                            git push origin main
                            '''
                        }
                    } catch (err) {
                        error "Failed to update deployment manifest or push to GitHub: ${err}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline execution completed."
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check error messages above."
        }
    }
}
