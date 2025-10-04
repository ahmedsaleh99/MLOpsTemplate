# Ubuntu-based Dockerfile that installs Miniforge explicitly
FROM ubuntu:22.04

ARG MINIFORGE_NAME=Miniforge3
ARG MINIFORGE_VERSION=25.3.1-0
ARG TARGETPLATFORM
ARG CONDA_ENV_NAME

ENV CONDA_DIR=/opt/conda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=${CONDA_DIR}/bin:${PATH}


# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    bzip2 \
    tini \
    build-essential \
    git \
    curl \
    make \
 && apt-get clean && rm -rf /var/lib/apt/lists/*


# Install Miniforge 
RUN  wget --no-hsts --quiet https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh -O /tmp/miniforge.sh && \
    /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge.sh && \
    conda clean --tarballs --index-cache --packages --yes && \
    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
    conda clean --force-pkgs-dirs --all --yes  && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /etc/skel/.bashrc && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> ~/.bashrc



WORKDIR /app
# Copy project files to /app
COPY ./scripts scripts
RUN chmod +x ./scripts/install_env.sh
COPY requirements.yaml requirements.yaml
COPY requirements-dev.yaml requirements-dev.yaml
COPY Makefile Makefile
# Create the conda environment
RUN make dev-docker

ENTRYPOINT ["tini", "--"]
CMD [ "/bin/bash" ]