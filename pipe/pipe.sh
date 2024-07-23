#!/usr/bin/env bash
#
# This pipe is an example to show how easy is to create pipes for Bitbucket Pipelines.
#

source "$(dirname "$0")/common.sh"
source "/terraform_plan.sh"
source "/terraform_apply.sh"
source "/terraform_destroy_plan.sh"
source "/terraform_destroy.sh"
source "/pr_comment_plan.sh"
source "/pr_comment_apply.sh"
source "/pr_comment_output.sh"

info "Executing the pipe..."

# Required parameters
TOKEN_RUN_TERRAFORM=${TOKEN_RUN_TERRAFORM:?'TOKEN_RUN_TERRAFORM is missing'}
TERRAFORM_MODE=${TERRAFORM_MODE:?'TERRAFORM_MODE is missing'}


if [[ "${TERRAFORM_MODE}" != "apply" && "${TERRAFORM_MODE}" != "destroy" ]]; then
  exit 1
fi
# Default parameters
OUTPUT=${OUTPUT:="false"}
DEBUG=${DEBUG:="false"}
PWD=$(pwd)

info ${PWD}
ls -l 
export
terraform version
aws --version

#config git authentication
git config --global url."https://x-token-auth:${TOKEN_RUN_TERRAFORM}@bitbucket.org".insteadOf "https://bitbucket.org"

#export AWS_ROLE_ARN=arn:aws:iam::856777607988:role/bitbucket-openid-connect
AWS_WEB_IDENTITY_TOKEN_FILE=$(pwd)/web-identity-token
echo ${BITBUCKET_STEP_OIDC_TOKEN} > $(pwd)/web-identity-token

if [[ "${BITBUCKET_BRANCH}" == "feature/"* && "${BITBUCKET_PR_DESTINATION_BRANCH}" == "master" && "${TERRAFORM_MODE}" == "apply"  ]]; then

  terraform_plan
  plan_comment
  success "Plan Success!"

elif [[ "${BITBUCKET_BRANCH}" == "master" && "${TERRAFORM_MODE}" == "apply" ]]; then

  terraform_apply
  apply_comment
  success "Apply Success!"

  if [[ "${OUTPUT}" == "true" ]]; then
    output_comment
  fi

elif [[ "${BITBUCKET_BRANCH}" == "feature/"* && "${BITBUCKET_PR_DESTINATION_BRANCH}" == "master" && "${TERRAFORM_MODE}" == "destroy"  ]]; then

  terraform_destroy_plan
  plan_comment
  success "Destroy Plan Success!"

elif [[ "${BITBUCKET_BRANCH}" == "master" && "${TERRAFORM_MODE}" == "destroy" ]]; then

  terraform_destroy
  apply_comment
  success "Destroy Success!"

else

  fail "Terraform Fail!"
  exit 1

fi


# if [[ "${status}" == "0" ]]; then
#   success "Success!"
# else
#   fail "Error!"
# fi