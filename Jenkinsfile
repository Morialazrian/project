pipeline {
    agent any  // Runs on any available agent

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Replace with your actual Git repo URL where the PowerShell script is stored
                    git branch: 'main', url: 'https://github.com/Morialazrian/project.git'
                }
            }
        }

        stage('Run Employee Management Script') {
            steps {
                script {
                    // Running the PowerShell script interactively
                    powershell '''
                    Write-Host "Starting Employee Management System in PowerShell..."
                    ./employees.ps1
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Employee Management Script executed successfully!"
        }
        failure {
            echo "❌ Pipeline failed! Check logs for errors."
        }
    }
}
