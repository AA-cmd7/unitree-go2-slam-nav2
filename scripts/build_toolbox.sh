#!/usr/bin/env bash
set -e

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/go2_ws_toolbox}"
UNITREE_WS="${UNITREE_WS:-$HOME/unitree_ros2/cyclonedds_ws}"

cd "$WORKSPACE_DIR"
source /opt/ros/humble/setup.bash
source "$UNITREE_WS/install/setup.bash"
colcon build --symlink-install
