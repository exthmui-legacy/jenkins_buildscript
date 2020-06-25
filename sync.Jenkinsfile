pipeline {
    agent {
        label "$AGENT_LABEL"
    }

    environment {
        EXTHM_SOURCE_PATH = "${EXTHM_SOURCE_BASEPATH}/exthm-${TARGET_VERSION}"
    }

    stages {
        stage('Sync Projects') {
            steps {
                sh label: '', script: '''bash -c "cd ${EXTHM_SOURCE_PATH}
                repo sync --force-sync"'''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
