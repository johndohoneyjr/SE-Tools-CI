### Docker, Vagrant and Kubernetes Jenkins Features

# Jenkins Operations
This repo has a `Dockerfile` and a `helm` chart for setting up a simple Jenkins master for running on your Mac as well as Kubernetes.

**IMPORTANT:** This example is for demos only. It should not be used a production environment!  It is ill advised to have small children in your presence when working with Docker or Jenkins

### Get the example Docker image
You can snag an pre-built version of this Jenkins image from Docker Hub
```bash
# Pull the image
$ docker pull johndohoney/jenkins-ci
```

### Build the Jenkins Docker image
You can build the image yourself
```bash
$ export DOCKER_REG=SET_YOUR_DOCKER_REGISTRY_HERE

# Build the image
$ docker build -t ${DOCKER_REG}/jenkins-ci 

# Push the image
$ docker push ${DOCKER_REG}/jenkins-ci
```

### Test your image
You can run your container locally, if you have Docker installed
- Using the pre-built image
```bash
# Run the container you built before
$ docker run -d --name jenkins -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock johndohoney/jenkins-ci

```

- Using your built image
```bash
# Run the container you built before
$ docker run -d --name jenkins -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_REG}/jenkins-ci

```
- Browse to http://localhost:8080 on your local browser


### Vagrant
You can test your Docker image using `Vagrant`. The enclosed Vagrantfile, and it will provision a VM with Docker.

- Spin up the Vagrant VM then build and run the Docker image
```bash
# Spin up the Vagrant VM
$ vagrant up

# SSH into the VM
$ vagrant ssh

# Go to the mounted sources repository
$ cd /opt/provisioning

# Build and run your Jenkins container as shown above
```
- Browse to http://localhost:8080 on your local browser

### Deploy Jenkins helm chart to Kubernetes
If you are using the pre-built image `johndohoney/jenkins-ci`, you can install the helm chart with
```bash
# Init helm and tiller on your cluster
$ helm init

# Deploy the Jenkins helm chart
# (same command for install and upgrade)
$ helm upgrade --install jenkins ./helm/jenkins-ci
```
**NOTE:** This helm chart deploys a pod with two containers. One for the Docker daemon and another for Jenkins. This is based on the suggestion in https://applatix.com/case-docker-docker-kubernetes-part-2/ and it works!!!

If you are building your own version of Jenkins, you need your Kubernetes cluster to be able to pull the Docker image.
You have to create a Docker registry secret and reference to it in your `helm install` command.
```bash
# Create a Docker registry secret
$ export DOCKER_REG=SET_YOUR_DOCKER_REGISTRY_HERE
$ export DOCKER_USR=SET_YOUR_DOCKER_USERNAME_HERE
$ export DOCKER_PWD=SET_YOUR_DOCKER_PASSWORD_HERE
$ export DOCKER_EML=SET_YOUR_DOCKER_EMAIL_HERE

$ kubectl create secret docker-registry docker-secret \
        --docker-server=${DOCKER_REG} \
        --docker-username=${DOCKER_USR} \
        --docker-password=${DOCKER_PWD} \
        --docker-email=${DOCKER_EML}


# Deploy the Jenkins helm chart
# (same command for install and upgrade)
$ helm upgrade --install jenkins \
        --set imagePullSecrets=docker-secret \
        --set image.repository=${DOCKER_REG}/jenkins \
        --set image.tag='lts-k8s' \
        ./helm/jenkins-ci
```

### Data persistence
By default, in Kubernetes, the Jenkins deployment uses a persistent volume claim that is mounted to `/var/jenkins_home`.
This assures your data is saved across crashes, restarts and upgrades.

