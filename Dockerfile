# Pull the image from Docker Hub
FROM spidercatnat/raspbian-buster-for-x86_64:latest

# Install the latest stable version of node via NVM
RUN apt-get update
RUN apt-get install curl -y
RUN curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

# Start in bash shell
ENTRYPOINT ["/bin/bash"]
