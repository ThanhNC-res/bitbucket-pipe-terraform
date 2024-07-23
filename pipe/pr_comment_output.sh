output_comment(){
    terraform output -no-color > output.txt

    sed '1s/^/* Terraform Output for this Repository\n```\n/; $ s/$/\n```\n*/' output.txt > output-2.txt

    CONTENT=$(cat "./output-2.txt");

    echo ${CONTENT}

    BITBUCKET_PR_ID=$(curl -X GET https://api.bitbucket.org/2.0/repositories/$BITBUCKET_REPO_FULL_NAME/commit/$BITBUCKET_COMMIT/pullrequests --header "Authorization: Bearer ${TOKEN_RUN_TERRAFORM}" --header 'Accept: application/json' | jq '.values | .[] | .id')
    
    curl -X POST https://api.bitbucket.org/2.0/repositories/$BITBUCKET_REPO_FULL_NAME/pullrequests/$BITBUCKET_PR_ID/comments  --header "Authorization: Bearer ${TOKEN_RUN_TERRAFORM}" --header 'Content-Type: application/json' --data "$(jq -n --arg n "$CONTENT" '{"content": {"raw":$n}}')"
}