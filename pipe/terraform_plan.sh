terraform_plan(){
    terraform init
    terraform validate
    terraform fmt
    terraform plan -no-color -out=.terraform/tf.plan > tf.txt
    ls -l ./.terraform
}