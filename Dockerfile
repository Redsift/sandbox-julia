FROM quay.io/redsift/sandbox:latest
MAINTAINER Rahul Powar email: rahul@redsift.io version: 1.1.101

LABEL io.redsift.sandbox.install="/usr/bin/redsift/install.jl" io.redsift.sandbox.run="-J /run/sandbox/sift/sysimg.so /usr/bin/redsift/run.jl"

# Install nodejs and a minimal git + python + build tools as npm and node-gyp often needs it for modules
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository -y ppa:staticfloat/juliareleases && \
	apt-get update && \
	apt-get install -y julia build-essential && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy support files across
COPY root /

RUN chown -R sandbox:sandbox /usr/share/julia

RUN julia -e "Pkg.add(\"JSON\");import JSON;Pkg.clone(\"https://github.com/Redsift/Nanomsg.jl\");import Nanomsg;"

RUN chown -R sandbox:sandbox $HOME/.julia

ENTRYPOINT [ "/usr/bin/julia", "-q" ]
