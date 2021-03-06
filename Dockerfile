FROM ubuntu:focal
USER root

# Uncomment to use local apt-cacher-ng instance. If you don't what that is, don't worry about it.
# RUN echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -qq update && \
    apt-get -y upgrade && \
    bash -c "apt-get install -y --no-install-recommends \
        sudo \
        python3-dev python3-pip \
        jupyter jupyter-notebook jupyter-nbconvert python3-ipykernel \
        build-essential zip unzip parallel cython3 \
        python3-{argh,atomicwrites,attr,cached-property,future,h5py} \
        python3-{matplotlib,pandas,pint,pprofile,pytest} \
        python3-{scipy,sortedcontainers,sphinx,sphinx-rtd-theme,tabulate} \
        python3-{tqdm,yaml,yamlordereddictloader} \
        optipng poppler-utils \
        git libboost-all-dev libtool mrbayes" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    git clone https://github.com/plewis/galax.git && \
    cd galax && \
    git checkout -f --detach 542db9d094775eded4a04f8dc175e7610323349d && git clean -dfx &&\
    ./bootstrap && \
    ./configure && \
    make install

# Create user.
# Let user run anything they want as root inside the container.
RUN useradd -m -s /bin/bash user && echo "user:docker" | chpasswd && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/user
USER user
