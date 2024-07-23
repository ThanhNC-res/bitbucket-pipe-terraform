terraform_apply(){
    terraform init
    terraform apply --auto-approve -no-color > apply.txt
}