# heptio-authenticator-client
This repository contains a docker-image that can be used to authenticate against Kubernetes clusters running heptio on AWS for authentication.
For more information on heptio, how to install it and why ou would want it, please refer to the official heptio repo https://github.com/heptio/authenticator.


## How to Build
Build the image and pass the version of kubectl you want to run inside the container.

```bash
docker build --build-arg KUBECTL_VERSION=1.8.4 -t heptio-authenticator-client .
```


## How to Run
Run the container with some useful mounts and start a bash shell inside the container.

```bash
docker run -ti --rm -v $(pwd):/workdir -v $HOME/.kube:/root/.kube -v ~/.aws:/root/.aws -v $HOME/.ssh:/root/.ssh heptio-authenticator-client bash
```

The following folders from the host system will be mounted into the container:

- the current directory from which the container was start will be mounted to /workdir
- the *.kube* directory is mounted into the container, so that i.e. the kubectl-config from the host system will be used
- the *.aws* directory is mounted into the container
- the *.ssh* directory is mounted into the container

## How to Use

### Prerequisites

To use the heptio-client, you need to have a script prepared to assume a role on your AWS account.
The script needs to set the following env-variables:

Run your script using the *source* command from inside the container, i.e.:

```bash
source assume-role-on-aws.sh
```

### Using kubectl without certificates

Afterwards, for the time your AWS-token is valid, you can use the alias *k* inside the container just as you would use the *kubectl* command,
i.e.

```bash
k get ns
```
