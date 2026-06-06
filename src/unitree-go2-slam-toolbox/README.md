# 源码目录说明

这个目录保存本项目的 ROS 2 源码包和原始工程内容。面向新手的安装、编译、建图、保存地图、Nav2 导航、键盘控制、安全过滤器和常见问题说明，请查看仓库根目录 README：

```text
~/go2_ws_toolbox/README.md
```

建议从根目录开始操作：

```bash
cd ~/go2_ws_toolbox
less README.md
```

## 源码包

实际 ROS 2 包位于：

```text
~/go2_ws_toolbox/src/unitree-go2-slam-toolbox/src
```

主要包：

- `base/go2_core`：总启动入口、键盘控制、可选 EKF。
- `base/go2_driver`：Go2 里程计、TF、关节状态和 IMU 转换。
- `base/go2_twist_bridge`：`/cmd_vel` 到 `/api/sport/request` 的桥接。
- `go2_description`：URDF、mesh 和机器人模型显示。
- `go2_perception`：L1 点云累积和 LaserScan 转换。
- `go2_slam`：slam_toolbox 建图 launch 和参数。
- `go2_navigation2`：Nav2、AMCL、map_server 和安全过滤器。

## 文档入口

- 根目录 README：`~/go2_ws_toolbox/README.md`
- 安装说明：`~/go2_ws_toolbox/docs/01_install.md`
- 网络配置：`~/go2_ws_toolbox/docs/02_network_setup.md`
- 建图说明：`~/go2_ws_toolbox/docs/03_mapping.md`
- 地图保存：`~/go2_ws_toolbox/docs/04_save_map.md`
- 导航说明：`~/go2_ws_toolbox/docs/05_navigation.md`
- 键盘控制：`~/go2_ws_toolbox/docs/06_keyboard_control.md`
- 安全过滤器：`~/go2_ws_toolbox/docs/07_safety_filter.md`
- 常见问题：`~/go2_ws_toolbox/docs/08_troubleshooting.md`
- 系统架构：`~/go2_ws_toolbox/docs/system_architecture.md`
