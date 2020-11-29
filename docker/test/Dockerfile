# Use the official image as a parent image.
FROM centos:8

# Run the command inside your image filesystem.
RUN dnf update -y
RUN dnf install bind-utils -y

# Copy the rest of your app's source code from your host to your image filesystem.
COPY test.sh test.sh

CMD ["/usr/bin/bash"]
