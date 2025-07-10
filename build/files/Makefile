
SHELL 				:= /bin/bash
DIR_TERRAFORM := ./infra
DIR_ANSIBLE		:=./ansible
DIR_BIN				:=./bin
include ./conf/.env



.PHONY: help
help: 
			@echo -e " \nMakefile commands:\n"
			@echo -e "  make infra_create\tCreate the infrastructure with Terraform and configure Rancher with Ansible"
			@echo -e "  make infra_destroy\tDestroy the infrastructure with Terraform"
			@echo -e "  make k8s_install\tInstalling Kubernetes/Rahcner with Ansible"
			@echo -e "  make help\t\tShow this help message\n"

.PHONY: infra_terraform
infra_terraform:
			@echo -e "\nCreating infrastructure with Terraform\n"
			@cd $(DIR_TERRAFORM) && terraform init && terraform validate && terraform apply -auto-approve \
			

.PHONY: infra_terraform_destroy
infra_terraform_destroy:
			@echo -e "\nDestroying infrastructure with Terraform\n"
			@cd $(DIR_TERRAFORM) && terraform destroy -auto-approve && cd - >/dev/null 2>&1

.PHONY: infra_validate
infra_validate:
			@echo -e "\nValidating infrastructure with Terraform\n"
			@cd $(DIR_TERRAFORM) && terraform init && terraform validate

.PHONY: k8s_install
k8s_install:
			@echo -e "\nInstalling Kubernetes/Rahcner with Ansible\n"
			@echo -e "This will install Rancher on the target hosts defined in the Ansible inventory file\n"
			@cd $(DIR_ANSIBLE) && ansible-playbook -i inventory/hosts install-rancher.yaml -e "target_hosts=rancher" ; cd - >/dev/null 2>&1

.PHONY: wait_hosts
wait_hosts:
			@python3 $(DIR_BIN)/wait_hosts.py 

.PHONY: clean
clean:
			@echo -e "\nCleaning up the environment\n"
			@rm -rf $(DIR_TERRAFORM)/.terraform >/dev/null 2>&1 \
			rm -f $(DIR_TERRAFORM)/terraform.tfstate* >/dev/null 2>&1 \
			rm -f $(DIR_TERRAFORM)/.terraform.lock* >/dev/null 2>&1

.PHONY: infra_create
infra_create: infra_terraform wait_hosts k8s_install

.PHONY: infra_destroy
infra_destroy: infra_terraform_destroy clean
