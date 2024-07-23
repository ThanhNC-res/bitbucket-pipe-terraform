terraform_destroy(){
    terraform init
    terraform destroy --auto-approve -no-color > apply.txt
}