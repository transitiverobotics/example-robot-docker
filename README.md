# Transitive Robotics: Example Robot Docker

A simple docker container to simulate a robot that installs and runs a Transitive agent.

# Usage

Copy `sample.env` to `.env` and edit it to set your user id and token from your portal.transitiverobotics.com account.

Then run:
```
./run.sh
```
This builds the docker image and runs it. The created container will run the pre-installed Transitive agent, so you should see your simulated robot show up on https://portal.transitiverobotics.com right away. From here you can install capabilities.