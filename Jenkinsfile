pipeline {
    agent any

    environment{
        DEV_VARS = credentials('dev-varible-credential-id')
        STAGING_VARS = credentials('staging-varible-credential-id')
        PROD_VRS = credentials('production-varible-credential-id')
    }

    stages {

        stage('MR') {
            // when {changeRequest()}
            steps {
                sh "echo 'running terraform plan with dev credentials'"
            }  
        }

        stage('dev') {
            // when { not{ changeRequest()}}
            steps {
                sh "echo 'deploying to dev'"
            }
        }

        stage('staging') {
            // when { not{ changeRequest()}}           
            steps {
                script {
                    input message: 'Deploy to staging?', ok: 'Proceed'
                }
            }
        }

        stage('prod') {
            // when { not{ changeRequest()}}
            steps {
                script {
                    input message: 'Deploy to production?', ok: 'Proceed'
                }
            }
        }
    }
}