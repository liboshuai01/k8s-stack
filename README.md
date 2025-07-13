# K8s Stack - 个人 Kubernetes 应用部署集合

## 🚀 项目简介

本项目是一个个人使用的 Kubernetes (K8s) 应用部署方案集合，旨在为各类常用服务（如数据库、消息队列、监控、CI/CD 等）提供一套标准、快速、可复用的部署配置。

您可以将此项目视为一个 "Kubernetes 部署菜谱"。每种服务都是一道“菜”，您可以在相应的目录中找到部署这道“菜”所需的“配方”（即 K8s YAML 文件、Helm Chart 配置以及辅助脚本）。这使得在新的 K8s 环境中初始化基础设施变得简单高效，也适合作为学习和实践 K8s 部署的参考。

## ✨ 项目特点

*   **一站式方案**: 汇集了多种常用服务的 K8s 部署配置，并持续更新。
*   **模块化设计**: 每种服务存放在独立的目录中，结构清晰，互不干扰，方便按需取用。
*   **快速部署**: 大部分服务都提供了 `install.sh` 和 `uninstall.sh` 脚本，简化了部署和清理流程。
*   **高度可定制**: 通过修改 `.env.example` 文件、`values-example.yml` 或直接编辑 K8s YAML 文件，可以轻松定制化部署参数。

## 🛠️ 已包含的服务

以下是本项目当前包含的部署方案，按功能分类：

| 分类 | 服务 | 部署模式 |
| :--- | :--- | :--- |
| 🌐 **网络与服务网格** | `ingress-nginx` | Ingress Controller |
| | `metallb` | 裸金属负载均衡器 |
| | `cert-manager` | TLS 证书自动化管理 |
| 🗃️ **数据库** | `mongodb` | Standalone / Replica Set / Sharded |
| | `mysql` | Standalone / Replication |
| | `redis` | Standalone / Sentinel / Cluster |
| 🐘 **消息队列** | `kafka` | Cluster |
| 🌊 **大数据与流处理** | `flink` | Operator / Application & Session Clusters |
| 📦 **存储** | `nfs-subdir-external-provisioner` | 动态 NFS 存储供应 |
| ⚙️ **CI/CD 与 DevOps** | `jenkins` | CI/CD 服务 |
| | `harbor` | 镜像仓库 |
| | `nexus3` | 制品仓库 |
| 📊 **监控与告警** | `kube-prometheus-stack` | Prometheus + Grafana 监控栈 |
| 🌐 **Web 服务** | `nginx` | 高性能 Web 服务器 |

## 📋 环境要求

在开始之前，请确保您的环境中已安装并配置好以下工具：

*   **kubectl**: 已配置并能成功连接到您的 Kubernetes 集群。
*   **Helm**: (可选) 部分服务使用 Helm Chart 部署，需要安装 Helm。
*   **Shell 环境**: 用于执行 `.sh` 辅助脚本 (如 Git Bash on Windows)。
*   **Git**: 用于克隆本项目。

> **⚠️ 注意**: 项目中的某些配置可能依赖特定的 K8s 版本、StorageClass 或 Ingress Controller。请在部署前仔细阅读各服务目录下的 `README.md` 文件。

## 📖 如何使用

部署一个服务通常遵循以下步骤：

1.  **克隆本项目**:
    ```bash
    git clone https://github.com/your-repo/k8s-stack.git
    cd k8s-stack
    ```

2.  **选择并进入服务目录**:
    例如，要部署 Redis 集群，请进入 `redis/redis-cluster` 目录。
    ```bash
    cd redis/redis-cluster
    ```

3.  **阅读服务文档**:
    **强烈建议**首先阅读当前目录下的 `README.md`，它包含了针对该服务的详细说明、配置选项和注意事项。

4.  **配置服务**:
    *   如果存在 `.env.example` 或 `values-example.yml`，请复制一份并重命名为 `.env` 或 `values.yml`。
    *   根据您的需求修改配置文件中的参数（如密码、域名、存储大小等）。

5.  **执行部署**:
    *   **使用脚本 (推荐)**:
        ```bash
        ./install.sh
        ```
    *   **手动部署**:
        如果想手动控制，可以执行 `kubectl` 或 `helm` 命令。
        ```bash
        # 示例
        kubectl apply -f . -n <your-namespace>
        ```

6.  **检查状态**:
    部署后，可以使用 `status.sh` 脚本或 `kubectl` 命令检查 Pod 和 Service 的状态。
    ```bash
    ./status.sh
    # 或者
    kubectl get pods,svc -n <your-namespace>
    ```

## 🗑️ 如何卸载

*   **使用脚本 (推荐)**:
    在服务目录下执行卸载脚本。
    ```bash
    ./uninstall.sh
    ```
*   **手动卸载**:
    ```bash
    kubectl delete -f . -n <your-namespace>
    ```
> **⚠️ 警告**: 卸载操作可能会删除相关的 PVC，导致**数据丢失**。在执行前，请务必确认数据备份策略。

## 🤝 贡献

欢迎提交 Pull Request 来添加新的服务或改进现有配置。请确保您的提交遵循项目的模块化结构，并包含清晰的文档。

## 📄 许可证

本项目采用 [MIT](LICENSE) 许可证。