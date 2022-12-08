FROM ghcr.io/airtai/nbdev-mkdocs:latest

# Install azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install trivy
RUN wget https://github.com/aquasecurity/trivy/releases/download/v0.32.1/trivy_0.32.1_Linux-64bit.deb && \
    dpkg -i  trivy_0.32.1_Linux-64bit.deb && rm trivy_0.32.1_Linux-64bit.deb

# Install git secret scanners
RUN git clone https://github.com/awslabs/git-secrets.git && cd git-secrets && make install && cd ../ && rm -rf git-secrets
