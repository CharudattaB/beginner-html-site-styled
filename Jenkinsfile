pipeline {
    // 1. Specify where this job should run.
    // It will run on any available agent with the 'docker-agent' label we configured earlier.
    agent {
        label 'docker-agent'
    }

    stages {
        // 2. The 'Checkout' stage clones the repository onto the agent.
        stage('Checkout') {
            steps {
                git branch: 'gh-pages', url: 'https://github.com/CharudattaB/beginner-html-site-styled.git'
            }
        }

        // 3. The 'Build' stage creates the Docker image from the Dockerfile.
        stage('Build Docker Image') {
            steps {
                script {
                    // The docker.build command uses the Docker plugin.
                    // 'my-website:${BUILD_NUMBER}' tags the image with the job's build number, ensuring a unique tag for each run.
                    echo "Building Docker image..."
                    def dockerImage = docker.build('my-website:${BUILD_NUMBER}')
                }
            }
        }

        // 4. The 'Deploy' stage runs the new container.
        stage('Deploy Container') {
            steps {
                script {
                    // This shell script block first checks if a container with the same name is already running.
                    // If it is, it stops and removes it to prevent port conflicts.
                    echo "Stopping and removing old container if it exists..."
                    sh '''
                    if [ "$(docker ps -q -f name=my-website-container)" ]; then
                        docker stop my-website-container
                        docker rm my-website-container
                    fi
                    '''
                    // This runs the new container.
                    // -d: detached mode (runs in the background)
                    // --name: gives the container a predictable name
                    // -p 99:80: maps port 99 on the host (agent machine) to port 80 in the container
                    echo "Deploying new container..."
                    sh 'docker run -d --name my-website-container -p 99:80 my-website:${BUILD_NUMBER}'
                }
            }
        }
    }

    post {
        // This 'post' block runs after all stages are complete, regardless of success or failure.
        always {
            echo 'Pipeline finished.'
            // This is a cleanup step to remove old, unused Docker images to save disk space.
            echo 'Cleaning up old Docker images...'
            sh '''
            docker image prune -f
            '''
        }
    }
}
