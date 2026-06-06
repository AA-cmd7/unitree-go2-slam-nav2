#!/usr/bin/env bash

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/go2_ws_toolbox}"
UNITREE_WS="${UNITREE_WS:-$HOME/unitree_ros2/cyclonedds_ws}"

source /opt/ros/humble/setup.bash
source "$UNITREE_WS/install/setup.bash"
source "$WORKSPACE_DIR/install/setup.bash"
