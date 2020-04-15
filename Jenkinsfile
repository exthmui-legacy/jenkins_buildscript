pipeline {
    agent {
        label "$AGENT_LABEL"
    }
/*
    paramenters {
        choice(name:'EXTHM_COMPILERTYPE',choices:'OFFICIAL\nUNOFFICIAL',description:'Type of compiler')
        choice(name:'EXTHM_BUILDTYPE',choices:'SNAPSHOT\nALPHA\nBETA\nRELEASE',description:'Type of this build')
        string(name:'BUILD_THREADS',description:'The number of threads',defaultValue:'16')
    }
*/
    environment {
        TARGET_CODE_NAME = sh label: '', returnStdout: true, script: 'echo -n $JOB_NAME | sed "s/^exTHmUI-//g"'
        EXTHM_SOURCE_PATH = "${EXTHM_SOURCE_BASEPATH}/exthm-${TARGET_VERSION}"
    }
    stages {
        stage('Build') {
            steps {
                sh label: '', script: '''bash -c "cd ${EXTHM_SOURCE_PATH}
                                                  . build/envsetup.sh
                                                  rm out/target/product/${TARGET_CODE_NAME}/exthm-*.zip
                                                  lunch exthm_${TARGET_CODE_NAME}-userdebug
                                                  mka bacon -j${BUILD_THREADS}"'''
            }
        }
        stage('Upload') {
            steps {
                sh label: '', script: '''bash -c "mkdir out
                                                  cp ${EXTHM_SOURCE_PATH}/out/target/product/${TARGET_CODE_NAME}/exthm-*.zip ./out"'''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'out/*', onlyIfSuccessful: true
            cleanWs()
        }
    }
}
