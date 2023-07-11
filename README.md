<p align="center">
  <a href="https://transitiverobotics.com">
    <img src="https://transitiverobotics.com/img/logo.svg" style="height: 64px">
  </a>
</p>

# Transitive Robotics: Example Robot Docker

A simple docker container to simulate a robot that installs and runs a Transitive agent.

# Usage

Copy `sample.env` to `.env` and edit it to set your user id and token from your portal.transitiverobotics.com account.

Then run:
```
./run.sh
```
This builds the docker image and runs it. The created container will run the pre-installed Transitive agent, so you should see your simulated robot show up on https://portal.transitiverobotics.com right away. From here you can install capabilities.

## Notes

If you want to adapt this repo to build a docker image for your purposes, you will propably also want to change the folder where the host-mounted directory lives. In the `run.sh` script here it is placed in `/tmp` which is deleted on restarts, so you may want to put it in a more permanent place, e.g., `DIR=$HOME/.transitive_docker`.
