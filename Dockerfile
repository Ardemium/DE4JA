# Use an official Ubuntu base image
FROM ubuntu:latest

# Set the maintainer label
LABEL maintainer="yourname@example.com"

# Set environment variables to non-interactive to prevent some prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list
RUN apt-get update

# Install necessary packages
RUN apt-get install -y curl wget unzip locales

# Generate locale
RUN locale-gen en_US.UTF-8

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale environment
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Download and extract OpenJDK 19
RUN wget https://download.oracle.com/java/19/archive/jdk-19.0.2_linux-x64_bin.tar.gz \
    && tar -xzf jdk-19.0.2_linux-x64_bin.tar.gz -C /usr/local \
    && rm jdk-19.0.2_linux-x64_bin.tar.gz

# Set JAVA_HOME and update PATH environment variable
ENV JAVA_HOME=/usr/local/jdk-19.0.2
ENV PATH="$JAVA_HOME/bin:$PATH"

# Download the Joern installation script to the home directory
RUN curl -L "https://github.com/joernio/joern/releases/latest/download/joern-install.sh" -o /root/joern-install.sh

# Make the Joern installation script executable
RUN chmod u+x /root/joern-install.sh

# Run the Joern installation script non-interactively
RUN echo Y | /root/joern-install.sh

# Manually unzip Joern
RUN unzip /root/joern-cli.zip -d /root/joern-cli

# Set the working directory to the Joern installation directory
WORKDIR /root/joern-cli/joern-cli

# Set the entry point to the Joern executable
ENTRYPOINT ["/bin/bash"]
