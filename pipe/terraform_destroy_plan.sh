terraform_destroy_plan(){
    terraform init
    terraform validate
    terraform fmt
    terraform plan -destroy -no-color > tf.txt
}