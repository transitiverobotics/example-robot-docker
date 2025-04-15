
ARG ROS_DISTRO=noetic
FROM ros:${ROS_DISTRO}

# Install dependencies. This includes dependencies for webrtc-video and the capabilities using it (e.g., remote-teleop)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils iputils-ping curl git lsb-release gnupg vim build-essential pkg-config fontconfig gobject-introspection gstreamer1.0-x gstreamer1.0-libav gstreamer1.0-nice gstreamer1.0-plugins-bad gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools libgstreamer1.0-0 libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev libgirepository1.0-dev libc-dev libcairo2 libcairo2-dev avahi-utils

WORKDIR /root/.transitive
COPY config.json .

# RUN curl -sf "https://install.transitiverobotics.com?id=placeholder&token=placeholder&docker=true" > /tmp/install.sh
ADD https://install.transitiverobotics.com?id=placeholder&token=placeholder&docker=true /tmp/install.sh
RUN chmod +x /tmp/install.sh

# Install the agent
RUN bash -c ". /opt/ros/${ROS_DISTRO}/setup.bash && /tmp/install.sh"

# We need to clear but not delete the machine-id to avoid duplicate device Ids
RUN echo "" > /etc/machine-id

WORKDIR /root
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
