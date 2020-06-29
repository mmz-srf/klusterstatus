#FROM debian:stable-slim
FROM python:3.8-slim-buster

ARG KUBECTL_VERSION="v1.17.0"
ENV DOCKER_USER=""
ENV DOCKER_PASS=""
ENV ANCHORE_CLI_USER="admin"
ENV ANCHORE_CLI_PASS="foobar"
ENV ANCHORE_CLI_URL="http://172.17.0.1:8228"
ENV KUBECONFIG="/kube.config"

#install kubectl
RUN apt-get update && apt-get install -y apt-transport-https curl gnupg2; \
echo https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl; \
curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl ; \
chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

#install gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY klusterstatus.py klusterstatus.py