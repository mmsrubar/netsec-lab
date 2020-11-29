# Use the official image as a parent image.
FROM centos:8

# Run the command inside your image filesystem.
RUN dnf update -y
RUN dnf install bind -y
RUN dnf install bind-utils -y
RUN mkdir /etc/bind
RUN mkdir /var/log/bind

# Testing
RUN dnf install vim -y

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 53

WORKDIR /etc/bind

# Copy the rest of your app's source code from your host to your image filesystem.
COPY named.conf /etc/bind/named.conf
COPY rndc.conf /etc/rndc.conf

RUN chown named:named -R /etc/bind
RUN chown named:named -R /var/log/bind

CMD ["/usr/sbin/named", "-u", "named", "-g", "-c", "/etc/bind/named.conf"]
