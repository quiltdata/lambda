FROM amazonlinux:2

# Need to set "ulimit -n" to a small value to stop yum from hanging:
# https://bugzilla.redhat.com/show_bug.cgi?id=1715254#c1
# See the following for installing 3.8 via yum on amazon-linux
# https://techviewleo.com/how-to-install-python-on-amazon-linux/
RUN ulimit -n 1024 \
	&& amazon-linux-extras enable python3.8 && yum clean metadata \
	&& yum -y update && yum -y install \
	  git \
	  gcc \
	  python38 \
	  python38-devel \
	  jq \
	  nano \
	  unzip \
	  zip \
	  && yum clean all

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

COPY requirements.txt quilt/requirements.txt

RUN python3 -m pip install pip==21.1.1

# Requirements copied from lambda Python 3.6, but not in base image
# (Plus Cython which is a build-time requirement for numpy)
RUN python3 -m pip install -r quilt/requirements.txt

# Make it possible to build numpy:
# https://github.com/numpy/numpy/issues/14147
ENV CFLAGS=-std=c99
