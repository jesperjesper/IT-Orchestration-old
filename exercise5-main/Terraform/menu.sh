#!/bin/bash

# Create VM
create_vm() {
    source ~/.cloudrc
    echo "Starting the process of setting up virtual machines."
    terraform init
    echo "Terraform init success"
    terraform apply -auto-approve
    echo "Virtual machine created successfully!"
}

# Destroy VM
destroy_vm() {
    echo "Starting the process of destroying virtual machines"
    terraform init
    echo "Terraform init success"
    terraform destroy -auto-approve
    echo "Virtual machine destroyed successfully!"
}

# Menu options
PS3="Please enter your choice: "
options=("Create Virtual Machine" "Destroy Virtual Machine" "Quit")

# Menu loop
select menu in "${options[@]}"
do
    case $menu in
        "Create Virtual Machine")
            create_vm
            ;;
        "Destroy Virtual Machine")
            destroy_vm
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option";;
    esac
done
