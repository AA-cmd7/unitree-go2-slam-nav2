#!/usr/bin/env bash

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/go2_ws_toolbox}"
UNITREE_WS="${UNITREE_WS:-$HOME/unitree_ros2/cyclonedds_ws}"

source /opt/ros/humble/setup.bash
source "$UNITREE_WS/install/setup.bash"
source "$WORKSPACE_DIR/install/setup.bash"

export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# Change enp129s0 to the network interface connected to the Unitree Go2.
export CYCLONEDDS_URI='<CycloneDDS><Domain><General><Interfaces>
  <NetworkInterface name="enp129s0" priority="default" multicast="default" />
</Interfaces></General></Domain></CycloneDDS>'
