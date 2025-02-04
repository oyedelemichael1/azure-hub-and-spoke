pipeline {
    agent any

    environment{
        DEV_VARS = credentials('dev-variable-credential-id')
        STAGING_VARS = credentials('staging-variable-credential-id')
        PROD_VARS = credentials('prod-variable-credential-id')
    }

    stages {

        stage('dev') {
            steps{
                script {
                    echo 'deploying to dev 1'
                    echo "running terraform apply -auto-approve -var-file=DEV_VARS"
                }
            }
        }

        stage('staging') {         
            steps {
                script {
                    input message: 'Deploy to staging?', ok: 'Proceed'
                    echo "Deploying to staging 1"
                    echo "running terraform apply -auto-approve -var-file=STAGING_VARS"
                }
            }
        }

        stage('prod') {
            steps {
                script {
                    input message: 'Deploy to production?', ok: 'Proceed'
                    echo "Deploying to production 1"
                    echo "running terraform apply -auto-approve -var-file=PROD_VARS"
                }
            }
        }
    }
}