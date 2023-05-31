ARG BASE_IMAGE
FROM ${BASE_IMAGE:-'ubuntu:20.04'}

RUN apt-get update && apt-get install -y iputils-ping curl git lsb-release gnupg vim

# a sudo user, for testing
RUN adduser -q --gecos "testuser" --disabled-password testuser
RUN addgroup testuser sudo
RUN echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# a normal user, for testing
RUN adduser -q --gecos "normaluser" --disabled-password normaluser

WORKDIR /root/.transitive
COPY config.json .

ARG USERID
ARG TOKEN
ENV USERID=${USERID}
ENV TOKEN=${TOKEN}
RUN curl -sf "https://install.transitiverobotics.com?id=$USERID&token=$TOKEN&docker=true" > /tmp/install.sh

# Install the agent
RUN bash /tmp/install.sh

# If you want to pre-install capabilities that use ROS2, then you'll need to
# first source your ROS2 environment. Comment out the above line and use this
# instead (you may need to fill in the name of your ROS2 distro):
#RUN bash -c ". /opt/ros/*/setup.bash && /tmp/install.sh"

WORKDIR /root
COPY entrypoint.sh .
CMD ["./entrypoint.sh"]