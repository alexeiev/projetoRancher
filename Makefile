include ./conf/.env

ENV 						:= dev 
SHELL						:= /bin/bash
DIR_TERRAFORM		:= ./infra
DIR_ANSIBLE			:=./ansible
HOMEDIR					:= $(HOME)
LOCALDIR				:= $(PWD)
UID							:= $(id -u)
GID							:= $(id -g)
MAKEFILE				:= /home/deploy/Makefile

.PHONY: help
help: 
		@echo -e " \nMakefile commands:\n"
		@echo -e "  make infra_create\tCreate the infrastructure with Terraform and configure Rancher with Ansible"
		@echo -e "  make infra_destroy\tDestroy the infrastructure with Terraform"
		@echo -e "  make k8s_install\tInstalling Kubernetes/Rahcner with Ansible"
		@echo -e "  make help\t\tShow this help message\n"


.PHONY: infra_validate
infra_validate:
ifeq ($(MAKETYPE),linux)
		@echo -e "\nValidating infrastructure with Terraform\n"
		@cd $(DIR_TERRAFORM) && terraform init && terraform validate
else ifeq ($(MAKETYPE),docker)
		@echo -e "\nValidate infrastructure with Docker\n"
		@docker run --rm -v $(LOCALDIR):/app -v $(HOMEDIR)/.ssh/id_rsa:/home/deploy/.ssh/id_rsa ceievfa/projetorancher:$(ENV) make -f $(MAKEFILE) infra_validate
endif

.PHONY: k8s_install
k8s_install:
ifeq ($(MAKETYPE),linux)
			@echo -e "\nInstalling Kubernetes/Rahcner with Ansible\n"
			@echo -e "This will install Rancher on the target hosts defined in the Ansible inventory file\n"
			@cd $(DIR_ANSIBLE) && ansible-playbook -i inventory/hosts install-rancher.yaml -e "target_hosts=rancher" ; cd - >/dev/null 2>&1
else ifeq ($(MAKETYPE),docker)
			@echo -e "\Installing Kubernetes/Rahcner with Ansible and Docker\n"
			@docker run --rm -v $(LOCALDIR):/app -v $(HOMEDIR)/.ssh/id_rsa:/home/deploy/.ssh/id_rsa ceievfa/projetorancher:$(ENV) make -f $(MAKEFILE) k8s_install
endif


.PHONY: clean
clean:
ifeq ($(MAKETYPE),linux)
			@echo -e "\nCleaning up the environment\n"
			@rm -rf $(DIR_TERRAFORM)/.terraform >/dev/null 2>&1 \
			rm -f $(DIR_TERRAFORM)/terraform.tfstate* >/dev/null 2>&1 \
			rm -f $(DIR_TERRAFORM)/.terraform.lock* >/dev/null 2>&1
else ifeq ($(MAKETYPE),docker)
			@echo -e "\cleanup infrastructure with Docker\n"
			@docker run --rm -v $(LOCALDIR):/app -v $(HOMEDIR)/.ssh/id_rsa:/home/deploy/.ssh/id_rsa ceievfa/projetorancher:$(ENV) make -f $(MAKEFILE) clean
endif

.PHONY: infra_create
infra_create:
ifeq ($(MAKETYPE),linux)
			@echo -e "\nCreating infrastructure with Terraform\n"
			@cd $(DIR_TERRAFORM) && terraform init && terraform validate && terraform apply -auto-approve

			@echo -e "\nInstalling Kubernetes/Rahcner with Ansible\n"
			@echo -e "This will install Rancher on the target hosts defined in the Ansible inventory file\n"
			@cd $(DIR_ANSIBLE) && ansible-playbook -i inventory/hosts install-rancher.yaml -e "target_hosts=rancher" ; cd - >/dev/null 2>&1
else ifeq ($(MAKETYPE),docker)
			@echo -e "\nCreating infrastructure with Docker\n"
			@sudo chown $(UID):1001 -R $(DIR_TERRAFORM) >/dev/null 2>&1
			@sudo chmod -R 2775 $(DIR_TERRAFORM) >/dev/null 2>&1
			@docker run --rm -v $(LOCALDIR):/app -v $(HOMEDIR)/.ssh/id_rsa:/home/deploy/id_rsa ceievfa/projetorancher:$(ENV) make -f $(MAKEFILE) infra_create
endif

.PHONY: infra_destroy
infra_destroy:
ifeq ($(MAKETYPE),linux)
			@echo -e "\nDestroying infrastructure with Terraform\n"
			@cd $(DIR_TERRAFORM) && terraform destroy -auto-approve && cd - >/dev/null 2>&1
else ifeq ($(MAKETYPE),docker)
			@echo -e "\nDestroy infrastructure with Docker\n"
			@docker run --rm -v $(LOCALDIR):/app -v $(HOMEDIR)/.ssh/id_rsa:/home/deploy/.ssh/id_rsa ceievfa/projetorancher:$(ENV) make -f $(MAKEFILE) infra_destroy
endif