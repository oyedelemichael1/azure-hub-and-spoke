// pipeline {
//     agent any

//     environment{
//         DEV_VARS = credentials('dev-variable-credential-id')
//         STAGING_VARS = credentials('staging-variable-credential-id')
//         PROD_VARS = credentials('prod-variable-credential-id')
//     }

//     stages {

//         stage('dev') {
//             steps{
//                 script {
//                     echo 'deploying to dev 1'
//                     echo "running terraform apply -auto-approve -var-file=DEV_VARS"
//                 }
//             }
//         }

//         stage('staging') {         
//             steps {
//                 script {
//                     input message: 'Deploy to staging?', ok: 'Proceed'
//                     echo "Deploying to staging 1"
//                     echo "running terraform apply -auto-approve -var-file=STAGING_VARS"
//                 }
//             }
//         }

//         stage('prod') {
//             steps {
//                 script {
//                     input message: 'Deploy to production?', ok: 'Proceed'
//                     echo "Deploying to production 1"
//                     echo "running terraform apply -auto-approve -var-file=PROD_VARS"
//                 }
//             }
//         }
//     }
// }

pipeline {
    agent any

    // parameters {
    //     choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Choose the environment to deploy to', defaultValue: 'dev')
    // }

    stages {
        stage('Deploy Selection') {
            steps {
                script {
                    // Default to 'dev' if no input is provided
                    def environmentChoice = params.ENVIRONMENT ?: input(
                        message: 'Choose the environment to deploy to:',
                        parameters: [
                            choice(
                                name: 'ENVIRONMENT',
                                // choices: ['dev', 'staging', 'prod'],
                                description: 'Select the environment for deployment',
                                defaultValue: 'dev'
                            )
                        ]
                    )

                    echo "Selected Environment: ${environmentChoice}"

                    // You can now use the environment choice to determine actions
                    if (environmentChoice == 'dev') {
                        echo 'Deploying to development environment...'
                    } else if (environmentChoice == 'staging') {
                        echo 'Deploying to staging environment...'
                    } else if (environmentChoice == 'prod') {
                        echo 'Deploying to production environment...'
                    }
                }
            }
        }

        stage('Deployment') {
            steps {
                echo 'Performing deployment tasks...'
            }
        }
    }
}

