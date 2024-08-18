pipeline {
    agent any


    stages {
        stage('拉取git代码') {
            steps {
                checkout scm
            }
        }

        stage('验证jenkinsfiles版本') {
            steps {
                echo "当前jenkinsfiles 版本 0.0.1"
            }
        }

        stage('maven构建') {
            tools { maven 'maven3.9.8' }

            steps { sh 'mvn clean package -DskipTests' }
        }

        stage('打包镜像') {
            steps {
                script {
                    def dockerImageName = "${env.JOB_NAME}-${env.BUILD_NUMBER}"
                    sh """
                        echo '使用${dockerImageName}镜像部署'
                        export IMAGE_TAG=${dockerImageName}
                        docker build -t ${dockerImageName} .

                        echo 'push到本地镜像仓库里面'
                        docker tag ${dockerImageName} localhost:30500/${dockerImageName}
                        docker push localhost:30500/${dockerImageName}
                    """

                    sh """
                        echo '将k8s部署文件deployment中的image:tag更改为${dockerImageName}'
                        sed -i "s/{image_name}/${env.JOB_NAME}/" deployment.yml
                        sed -i "s/{image_tag}/${env.BUILD_NUMBER}/" deployment.yml
                    """
                }

            }
        }

        stage('部署到k8s') {
            steps {
                sh """
                    kubectl apply -f deployment.yml
                    kubectl rollout status deployment/springboot-test
                """
            }
        }
    }
}
