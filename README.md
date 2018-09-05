# Build AWS Lambda deployment packages with Docker

## Blog post with latest tips

[An easier way to build AWS Lambda deployment packages — with Docker instead of EC2](https://blog.quiltdata.com/an-easier-way-to-build-lambda-deployment-packages-with-docker-instead-of-ec2-9050cd486ba8)

## Why?

* Logging in to EC2 and 
[creating a deployment package by hand](https://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html) 
is clumsy
* Instead, script package creation around the [`amazonlinux` image](https://hub.docker.com/_/amazonlinux/)
(blessed as an _official repository_ and
linked from [this AWS user guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/amazon_linux_container_image.html))

## Example: Python 3.6 deployment package

```sh
docker pull quiltdata/lambda

docker run --rm -v $(pwd)/create_table:/io -t \
	-e GIT_REPO quiltdata/lambda \
	bash /io/package.sh
```

* Mount `/io` as a docker volume
	* `/io` should contain `package.sh` and your lambda code \
	* `/io` is where the deployment package, lambda.zip, is written \
* Pass environment variables with `-e`
* `--rm` so that, for example, secure envs aren't written to disk


## Customize
Modify `package.sh` to suit your own purposes.

## Build container

```sh
docker build -t quiltdata/lambda .
```

## Clone private GitHub repo in container
Use a [personal access token](https://github.com/settings/tokens):

```sh
git clone https://${TOKEN}@github.com/USER/REPO
```

## Optimizations to reduce .zip size
Possible but not tried in this repo:
* [Delete *.py](https://github.com/ralienpp/simplipy/blob/master/README.md)
* [Profile code and only retain files that are used](https://medium.com/@mojodna/slimming-down-lambda-deployment-zips-b3f6083a1dff) 

