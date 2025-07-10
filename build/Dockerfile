# Dockerfile for building a Docker image with Terraform and Ansible
# Based on Alpine Linux
FROM alpine:latest

ENV USER=deploy

# Set the maintainer label
LABEL maintainer="Alexeiev Araujo"
LABEL EMAIL="ceievfa@gmail.com"
LABEL description="Docker image for projetoRancher with Terraform and Ansible"


RUN apk add --no-cache \
    bash \
    sudo \
    curl \
    git \
    python3 \
    py3-jsonpatch \
    py3-pyyaml-env-tag \
    py-pip \
    py3-kubernetes \
    musl-dev \
    libffi-dev \
    openssl-dev \
    ansible-core \
    unzip \
    wget \
    make \
    openssh-client && \
    addgroup -g 1001 -S deploy && \
    adduser -h /home/$USER -s /bin/bash -u 1001 -G $USER -S $USER && \
    echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/deploy && \
    chmod 0440 /etc/sudoers.d/$USER

RUN git clone https://github.com/alexeiev/projetoRancher.git /home/$USER/ && \
    mkdir -p /home/$USER/.ssh && \
    mkdir -p /home/$USER/.ansible/collections && \
    ansible-galaxy collection install -r /home/$USER/ansible/requirements.yaml --collections-path /home/$USER/.ansible/collections && \
    chown $USER:$USER -R /home/$USER/ && \
    chmod 700 -R /home/$USER/.ssh && \
    chmod 770 -R /home/$USER/.ansible && \
    mkdir -p /etc/ansible && \
    wget -qO /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip && \
    unzip /tmp/terraform.zip terraform -d /usr/local/bin && \
    rm /tmp/terraform.zip && \
    chmod +x /usr/local/bin/terraform
    
WORKDIR /app

COPY files/Makefile /home/deploy/Makefile
COPY files/entrypoint.sh /
COPY files/ansible.cfg /etc/ansible/ansible.cfg

RUN chmod +x /entrypoint.sh 

USER $USER

ENTRYPOINT ["/entrypoint.sh"]
