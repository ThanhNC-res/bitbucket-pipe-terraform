# Bitbucket Pipelines Pipe: Terraform Automation Pipe

This pipe will be served for TERA team in order to automate terraform workflow purposes.

## YAML Definition

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
script:
    - pipe: docker://856777607988.dkr.ecr.ap-northeast-1.amazonaws.com/terraform-aws-test-pipe:latest
    variables:
        TOKEN_RUN_TERRAFORM: ${TOKEN_RUN_TERRAFORM} #required
        TERRAFORM_MODE: apply #<destroy>  #required
      # DEBUG: "<boolean>" # Optional
```
## Variables

| Variable | Usage                                                             |
|----------|-------------------------------------------------------------------|
| TOKEN_RUN_TERRAFORM (*) | Copy token for Authorization                       |
| TERRAFORM_MODE (*)      | Terraform mode: apply or destroy                   | 
| DEBUG                   | Turn on extra debug information. Default: `false`. |

_(*) = required variable._

## Prerequisites

Authentication for ECR image pulling action.

```yaml
oidc: true
script:
    - export AWS_ROLE_ARN=arn:aws:iam::856777607988:role/bitbucket-openid-connect
    - export AWS_WEB_IDENTITY_TOKEN_FILE=$(pwd)/web-identity-token-2
    - echo $BITBUCKET_STEP_OIDC_TOKEN > $(pwd)/web-identity-token-2
    - export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts assume-role --region ap-northeast-1 --role-arn arn:aws:iam::856777607988:role/thanh-nc2-test-role --role-session-name Image-Pull --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
    - aws --version
    - aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 856777607988.dkr.ecr.ap-northeast-1.amazonaws.com
```

## Examples

Basic example:

- Apply Mode:
```yaml
script:
    - pipe: docker://856777607988.dkr.ecr.ap-northeast-1.amazonaws.com/terraform-aws-test-pipe:latest
    variables:
        TOKEN_RUN_TERRAFORM: ${TOKEN_RUN_TERRAFORM} #required
        TERRAFORM_MODE: apply
```

- Destroy Mode:
```yaml
script:
    - pipe: docker://856777607988.dkr.ecr.ap-northeast-1.amazonaws.com/terraform-aws-test-pipe:latest
    variables:
        TOKEN_RUN_TERRAFORM: ${TOKEN_RUN_TERRAFORM} #required
        TERRAFORM_MODE: destroy
```

Advanced example:

```yaml
script:
    - pipe: docker://856777607988.dkr.ecr.ap-northeast-1.amazonaws.com/terraform-aws-test-pipe:latest
    variables:
        TOKEN_RUN_TERRAFORM: ${TOKEN_RUN_TERRAFORM} #required
        TERRAFORM_MODE: apply
        DEBUG: true
```

## Support
If you'd like help with this pipe, or you have an issue or feature request, please contact to DevOps team
The pipe is maintained by Thanh Ngo Cong (CMC-Telecom)

If you're reporting an issue, please include:

- the version of the pipe
- relevant logs and error messages
- steps to reproduce