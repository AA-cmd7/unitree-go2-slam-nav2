# 01 安装与编译

本文面向从零复现用户，按顺序完成 ROS 2 依赖、Unitree ROS 2 underlay、本项目 clone 与编译。

## Step 0：系统要求

需要：

- Ubuntu 22.04
- ROS 2 Humble
- Unitree Go2 EDU
- Unitree L1 LiDAR
- PC 与 Go2 之间的有线网络连接

检查 ROS 2：

```bash
source /opt/ros/humble/setup.bash
ros2 --version
```

应该看到 `ros2` 命令能正常输出版本信息。如果提示 `ros2: command not found`，请先安装 ROS 2 Humble。

## Step 1：安装 ROS 2 apt 依赖

```bash
sudo apt update
sudo apt install \
  python3-colcon-common-extensions \
  ros-humble-navigation2 \
  ros-humble-nav2-bringup \
  ros-humble-nav2-map-server \
  ros-humble-nav2-amcl \
  ros-humble-nav2-controller \
  ros-humble-nav2-planner \
  ros-humble-nav2-bt-navigator \
  ros-humble-nav2-behaviors \
  ros-humble-nav2-lifecycle-manager \
  ros-humble-slam-toolbox \
  ros-humble-robot-localization \
  ros-humble-rmw-cyclonedds-cpp \
  ros-humble-rviz2 \
  ros-humble-tf2-tools \
  ros-humble-laser-geometry \
  ros-humble-message-filters \
  ros-humble-tf2-sensor-msgs \
  ros-humble-xacro \
  ros-humble-robot-state-publisher \
  ros-humble-joint-state-publisher
```

完成后应该能找到常用包：

```bash
source /opt/ros/humble/setup.bash
ros2 pkg list | grep nav2_map_server
ros2 pkg list | grep slam_toolbox
ros2 pkg list | grep rmw_cyclonedds_cpp
```

如果没有输出，常见原因是 apt 安装失败、ROS apt 源未配置、或当前终端未 source ROS 2。

## Step 2：安装 Unitree ROS 2 underlay

本项目依赖 Unitree ROS 2 通信包，但本仓库不包含：

- `unitree_go`
- `unitree_api`
- `unitree_hg`

本机检查到的 Unitree underlay 来源：

```text
https://github.com/unitreerobotics/unitree_ros2
```

本机 `cyclonedds_ws/src` 中还检查到：

```text
https://github.com/eclipse-cyclonedds/cyclonedds
https://github.com/ros2/rmw_cyclonedds
```

推荐目录：

```text
~/unitree_ros2/cyclonedds_ws
```

克隆 Unitree ROS 2 仓库：

```bash
cd ~
git clone https://github.com/unitreerobotics/unitree_ros2.git
```

进入 underlay 工作区：

```bash
cd ~/unitree_ros2/cyclonedds_ws
```

检查源码目录：

```bash
find src -maxdepth 3 -name package.xml -print
```

应该至少看到类似：

```text
src/unitree/unitree_api/package.xml
src/unitree/unitree_go/package.xml
src/unitree/unitree_hg/package.xml
```

如果 `src/cyclonedds` 或 `src/rmw_cyclonedds` 不存在，请先按照 Unitree 官方 ROS 2 SDK / `unitree_ros2` 教程补齐通信 underlay。不要随意从不明来源复制通信包。

编译 underlay：

```bash
source /opt/ros/humble/setup.bash
colcon build --symlink-install
```

编译成功后应该存在：

```bash
ls install/setup.bash
ls install/unitree_go
ls install/unitree_api
ls install/unitree_hg
```

source underlay：

```bash
source ~/unitree_ros2/cyclonedds_ws/install/setup.bash
```

验证包：

```bash
ros2 pkg list | grep unitree
ros2 pkg list | grep rmw_cyclonedds_cpp
```

期望至少看到：

```text
unitree_api
unitree_go
unitree_hg
rmw_cyclonedds_cpp
```

如果 `unitree_go` 或 `unitree_api` 不出现，常见原因：

- 没有编译 `~/unitree_ros2/cyclonedds_ws`
- 编译失败但没有处理报错
- 当前终端没有 source `~/unitree_ros2/cyclonedds_ws/install/setup.bash`
- Unitree 仓库没有按官方教程完整拉取

## Step 3：克隆本项目

```bash
cd ~
git clone https://github.com/AA-cmd7/unitree-go2-slam-nav2.git go2_ws_toolbox
cd ~/go2_ws_toolbox
```

应该看到：

```bash
ls README.md scripts src
```

## Step 4：检查脚本路径

本项目脚本默认使用：

```bash
WORKSPACE_DIR="$HOME/go2_ws_toolbox"
UNITREE_WS="$HOME/unitree_ros2/cyclonedds_ws"
```

如果你的路径不同，请修改：

- `scripts/env_toolbox.sh`
- `scripts/env_go2_robot.sh`
- `scripts/build_toolbox.sh`

或在执行前导出：

```bash
export WORKSPACE_DIR="$HOME/go2_ws_toolbox"
export UNITREE_WS="$HOME/unitree_ros2/cyclonedds_ws"
```

## Step 5：编译本项目

推荐使用脚本：

```bash
cd ~/go2_ws_toolbox
bash scripts/build_toolbox.sh
```

等价手动命令：

```bash
cd ~/go2_ws_toolbox
source /opt/ros/humble/setup.bash
source ~/unitree_ros2/cyclonedds_ws/install/setup.bash
colcon build --symlink-install
```

编译成功后应该存在：

```bash
ls install/setup.bash
ls install/go2_core
ls install/go2_navigation2
```

加载本项目环境：

```bash
source ~/go2_ws_toolbox/install/setup.bash
ros2 pkg list | grep go2
```

期望看到：

```text
go2_core
go2_driver
go2_twist_bridge
go2_description
go2_perception
go2_slam
go2_navigation2
```

## Step 6：连接真实 Go2 的环境

连接真实机器狗时，每个新终端使用：

```bash
cd ~/go2_ws_toolbox
source scripts/env_go2_robot.sh
```

这会加载：

- ROS 2 Humble
- Unitree underlay
- 本项目 overlay
- `RMW_IMPLEMENTATION=rmw_cyclonedds_cpp`
- `CYCLONEDDS_URI`

如果不连接机器人，只做本地包检查，可以使用：

```bash
cd ~/go2_ws_toolbox
source scripts/env_toolbox.sh
```

## 常见失败原因

### 找不到 unitree_go 或 unitree_api

现象：

```text
Could not find a package configuration file provided by "unitree_go"
```

原因通常是 Unitree underlay 未编译或未 source。

检查：

```bash
source ~/unitree_ros2/cyclonedds_ws/install/setup.bash
ros2 pkg list | grep unitree
```

解决：

```bash
cd ~/unitree_ros2/cyclonedds_ws
source /opt/ros/humble/setup.bash
colcon build --symlink-install
source install/setup.bash
```

### 找不到 slam_toolbox 或 Nav2

检查：

```bash
ros2 pkg list | grep slam_toolbox
ros2 pkg list | grep nav2_map_server
```

解决：

```bash
sudo apt update
sudo apt install ros-humble-slam-toolbox ros-humble-navigation2 ros-humble-nav2-bringup
```

### 找不到本项目 go2 包

检查：

```bash
cd ~/go2_ws_toolbox
source install/setup.bash
ros2 pkg list | grep go2
```

解决：

```bash
cd ~/go2_ws_toolbox
bash scripts/build_toolbox.sh
source install/setup.bash
```

### underlay 编译成功但连接 Go2 没有话题

先不要怀疑 Nav2。优先检查网络、CycloneDDS 网卡和 source 顺序。继续看 [02_network_setup.md](02_network_setup.md)。
