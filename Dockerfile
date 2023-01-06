FROM ghcr.io/airtai/nbdev-mkdocs:latest

# Use python 3.9 and install python3.9-dev
RUN update-alternatives --set python3 /usr/bin/python3.9

RUN python3 -m pip install --upgrade pip

RUN wget https://raw.githubusercontent.com/airtai/nbdev-mkdocs/main/docker/top_level_requirements.txt -O top_level_requirements.txt \
    && python3 -m pip install --no-cache-dir -r top_level_requirements.txt \
    && rm top_level_requirements.txt

RUN nbdev_install_quarto

# Install and configure jupyter notebook
## Install and enable black python formatter for notebooks
RUN jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip \
    && jupyter nbextension enable jupyter-black-master/jupyter-black

## Install jupyter theme with airt theme
RUN python3 -m pip install --no-cache-dir git+https://github.com/airtai/jupyter-themes.git

# Install apt dependencies
RUN apt update -y && apt install --assume-yes --fix-missing --no-install-recommends\
      python3.9-dev gettext-base default-libmysqlclient-dev virtualenv \
    && apt purge --auto-remove && apt clean && rm -rf /var/lib/apt/lists/*

# Install azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install confluent CLI
RUN curl -sL --http1.1 https://cnfl.io/cli | sh -s -- -b /usr/local/bin v2.37.0

# Install trivy
RUN wget https://github.com/aquasecurity/trivy/releases/download/v0.32.1/trivy_0.32.1_Linux-64bit.deb && \
    dpkg -i  trivy_0.32.1_Linux-64bit.deb && rm trivy_0.32.1_Linux-64bit.deb

# Install git secret scanners
RUN git clone https://github.com/awslabs/git-secrets.git && cd git-secrets && make install && cd ../ && rm -rf git-secrets
