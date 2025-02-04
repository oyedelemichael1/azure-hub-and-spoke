pipeline {
    agent any

    environment{
        DEV-VARS = credentials('dev-varible-credential-id')
        STAGING-VARS = credentials('staging-varible-credential-id')
        PROD_VRS = credentials('production-varible-credential-id')
    }

    stages {

        stage('MR') {
            when {changeRequest()}
            steps {
                sh "running terraform plan with dev credentials"
            }  
        }

        stage('dev') {
            when { not{ changeRequest()}}
            steps {
                sh "deploying to dev"
            }
        }

        stage('staging') {
            when { not{ changeRequest()}}           
            steps {

                def userInput = false
                script {
                    def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
                    echo 'userInput: ' + userInput

                    if(userInput == true) {
                        echo "deploying to staging"
                    } else {
                        // not do action
                        echo "staging deployment was aborted."
                    }

                }    
            }
        }

        stage('prod') {
            when { not{ changeRequest()}}
            steps {
                def userInput = false
                script {
                    def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
                    echo 'userInput: ' + userInput

                    if(userInput == true) {
                        echo "deploying to prod"
                    } else {
                        // not do action
                        echo "staging deployment was aborted."
                    }

                }    
            }
        }
    }
}