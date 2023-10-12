
#!/bin/bash
#
# Copyright (c) 2023 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#

# exit immediately when a command fails
set -ex
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail

export PUBLIC_REPO_SSH_URL=${PUBLIC_REPO_SSH_URL:-"git@ssh.dev.azure.com:v3/chepullreq1/che-pr-public/public-repo"}
export PRIVATE_REPO_SSH_URL=${PRIVATE_REPO_SSH_URL:-"git@ssh.dev.azure.com:v3/chepullreq1/che-pr-private/private-repo"}

# import common test functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${SCRIPT_DIR}"/common.sh

trap "catchFinish" EXIT SIGINT

setupTestEnvironment ${OCP_NON_ADMIN_USER_NAME}
setupSSHKeyPairs "${AZURE_PRIVATE_KEY}" "${AZURE_PUBLIC_KEY}"
testFactoryResolverResponse ${PUBLIC_REPO_SSH_URL} 200
testFactoryResolverResponse ${PRIVATE_REPO_SSH_URL} 500

testCloneGitRepoProjectShouldExists ${PUBLIC_REPO_WORKSPACE_NAME} ${PUBLIC_PROJECT_NAME} ${PUBLIC_REPO_SSH_URL} ${USER_CHE_NAMESPACE}
deleteTestWorkspace ${PUBLIC_REPO_WORKSPACE_NAME} ${USER_CHE_NAMESPACE}

testCloneGitRepoProjectShouldExists ${PRIVATE_REPO_WORKSPACE_NAME} ${PRIVATE_PROJECT_NAME} ${PRIVATE_REPO_SSH_URL} ${USER_CHE_NAMESPACE}
deleteTestWorkspace ${PRIVATE_REPO_WORKSPACE_NAME} ${USER_CHE_NAMESPACE}