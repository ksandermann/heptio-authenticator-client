FROM golang:1.9 as builder

ENV GOBIN=/go/bin

#go get the heptio-authenticator-aws binaries
RUN go get -u -v github.com/heptio/authenticator/cmd/heptio-authenticator-aws


FROM ubuntu:16.04

LABEL maintainer="Kevin Sandermann"

ARG KUBECTL_VERSION
ENV KUBECTL_VERSION ${KUBECTL_VERSION}

# AWS CLI needs the PYTHONIOENCODING environment varialbe to handle UTF-8 correctly:
ENV PYTHONIOENCODING=UTF-8

RUN apt-get update

RUN apt-get install -y \
    less \
    curl \
    nano \
    python \
    python-pip \
    python-virtualenv \
    openssh-client \
    python-passlib \
    jq \
    git \
    vim \
    wget

RUN pip install awscli j2cli[yaml] boto boto3

RUN curl -SsL --retry 5 "https://storage.googleapis.com/kubernetes-release/release/v1.8.4/bin/linux/amd64/kubectl" > /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl


RUN mkdir -p $HOME/go/bin
WORKDIR $HOME/go/bin

COPY --from=builder /go/bin/heptio-authenticator-aws .

ENV PATH=$PATH:$HOME/go/bin

#set alias for heptio authenticator
RUN echo 'alias kubectl-getclustername="kubectl config view -o jsonpath="{.clusters[0].name}""' >> ~/.bashrc
RUN echo 'alias heptio-gettoken="heptio-authenticator-aws token -i \$(kubectl-getclustername) -r arn:aws:iam::\$AWS_IAM_ROLE_ARN:role/\$AWS_IAM_ROLE"' >> ~/.bashrc
RUN echo 'alias k="kubectl --token \$(heptio-gettoken)"' >> ~/.bashrc


WORKDIR /project

