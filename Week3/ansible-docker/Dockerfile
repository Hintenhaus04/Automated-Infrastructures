FROM --platform=linux/amd64 python:latest

RUN pip install pip --upgrade
RUN pip install ansible

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY labsuser.pem /ssh/labsuser.pem

WORKDIR /work

ENTRYPOINT ["/bin/bash"]
