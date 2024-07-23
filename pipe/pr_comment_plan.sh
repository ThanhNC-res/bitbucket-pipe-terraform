plan_comment(){
    sed '1s/^/* Ran `terraform plan` for this repository\n```\n/; $ s/$/\n```\n* To apply this plan, please `MERGED` this PR/' tf.txt > tf-2.txt
    CONTENT=$(cat "./tf-2.txt");
    echo ${CONTENT}
    curl -X POST https://api.bitbucket.org/2.0/repositories/${BITBUCKET_REPO_FULL_NAME}/pullrequests/${BITBUCKET_PR_ID}/comments --header "Authorization: Bearer ${TOKEN_RUN_TERRAFORM}" --header 'Content-Type: application/json' --data "$(jq -n --arg n "${CONTENT}" '{"content": {"raw":$n}}')"
}