# k8s-cookbook: 常用服务 Kubernetes (K8s) 部署清单

## 项目简介

本项目是一个个人使用的 Kubernetes (K8s) 容器化部署清单集合，主要包含了各种常用服务（如基础设施组件、数据库、消息队列、监控工具等）在 Kubernetes 上部署所需的 YAML 文件、Helm Charts 或辅助脚本。旨在提供一个便捷、快速的方式来部署这些服务，避免重复配置工作或者作为学习实践 K8s 部署的参考。

本项目就像一个“Kubernetes 部署菜谱”，每种服务都是一道“菜”，您可以在相应的目录中找到制作（部署）这道“菜”所需的配方（K8s YAML 文件、Helm Chart 以及可能的 `.env` 或辅助脚本）。

## 特点

*   **一站式集合:** 收录了作者常用的多种服务在 K8s 上的部署配置，持续更新。
*   **快速部署:** 每个服务通常包含必要的 K8s 配置（如 Deployment, Service, PersistentVolumeClaim 等）和可能的辅助脚本 (`install.sh`, `uninstall.sh`)，易于理解和快速上手部署。
*   **模块化:** 每个服务的配置独立存放于自己的目录中，互不干扰，方便查找、管理和选择性部署。对于复杂的服务（如 Kafka, Redis），可能进一步划分为子目录（如 集群、Exporter 等）。
*   **可定制:** 通过修改 YAML 文件、编辑 `.env` 文件（如果使用脚本读取配置）或修改 Helm Chart 的 `values.yaml` 文件，可以轻松 Anpassung 配置，如副本数、存储配置、环境变量、Service 类型等。

## 环境要求

在使用本项目中的配置之前，请确保您拥有一个正在运行的 Kubernetes 集群，并且您的本地系统已经安装了以下软件和工具：

*   **kubectl:** Kubernetes 命令行工具，已配置连接到您的集群。
*   **helm (可选):** 如果某些服务使用 Helm Chart 进行部署，则需要安装 Helm。
*   **git:** 克隆本项目仓库。
*   **shell 环境:** 执行辅助脚本（如 `install.sh`, `uninstall.sh`）。

> **注意:** 本项目中的配置可能依赖特定的 K8s 版本或集群特性（如特定的 StorageClass、Ingress Controller 等）。具体要求请参考每个服务目录下的 `README.md` 文件。

## 项目结构

项目根目录 `k8s-cookbook` 下包含了各个服务的独立子目录。每个服务目录的命名通常对应于服务的名称（例如 `redis`, `kafka`）。

对于复杂的服务或需要特定配置的部署，可能在服务名称目录下进一步包含子目录，每个子目录代表一个具体的部署场景或组件（例如 `kafka/kafka-cluster`, `redis/redis-cluster`）。

每个最终的服务/组件目录（即可直接进行部署操作的目录）通常包含以下关键文件或结构：

*   `.env` (可选): 存储了配置可能需要的环境变量，供辅助脚本读取。**在使用前，您可能需要根据自己的需求修改此文件。**
*   `*.yaml`: 一个或多个 Kubernetes 资源定义文件（Deployment, Service, StatefulSet, ConfigMap, Secret, PersistentVolumeClaim, Ingress 等）。
*   `install.sh` (可选): 用于自动化执行部署命令（如 `kubectl apply -f .` 或 `helm install`）的脚本。
*   `uninstall.sh` (可选): 用于自动化删除资源的脚本（如 `kubectl delete -f .` 或 `helm uninstall`）。
*   `status.sh` (可选): 用于检查服务部署状态的脚本。
*   `README.md` (强烈建议阅读): 针对该服务的具体说明、配置细节、部署步骤、使用注意事项或访问方式等。

## 如何使用 (部署一个服务)

要部署某个服务，请执行以下步骤：

1.  **克隆本项目** (如果尚未克隆):
    ```bash
    git clone https://github.com/liboshuai01/k8s-cookbook
    # git clone https://gitee.com/liboshuai01/k8s-cookbook
    cd k8s-cookbook
    ```

2.  **进入您想要部署的服务或组件目录**:
    例如，如果您想部署 Kafka 集群，请进入 `kafka/kafka-cluster` 目录：
    ```bash
    cd kafka/kafka-cluster
    ```
    或者部署 Nginx Ingress Controller：
    ```bash
    cd ingress-nginx
    ```
    *请务必进入包含部署文件的*最终*叶子目录。*

3.  **配置服务**:
    *   **务必**仔细阅读该目录下的 `README.md` 文件。它包含最重要的配置说明、部署命令和使用细节。
    *   如果存在 `.env` 文件，根据您的实际需求修改其中的变量值。
    *   根据需要直接编辑目录下的 YAML 文件或 Helm Chart 的 `values.yaml` 文件进行更高级的定制。

4.  **部署服务**:
    在服务目录中，通常有两种部署方式，具体取决于该目录下提供的文件：

    *   **使用辅助脚本 (推荐如果存在):**
        运行部署脚本。例如：
        ```bash
        ./install.sh
        ```
        这个脚本通常会执行 `kubectl apply -f .` 或 `helm install ...` 等命令。检查脚本内容以了解其具体操作。

    *   **直接使用 kubectl/helm:**
        如果目录中只有 YAML 文件且没有 `install.sh` 脚本，或者您希望手动控制：
        ```bash
        # 对于 YAML 文件
        kubectl apply -f . -n <namespace> # 替换 <namespace> 为目标命名空间

        # 对于 Helm Chart (如果目录是 Chart 的根目录)
        helm install <release-name> . -n <namespace> # 替换 <release-name> 和 <namespace>
        ```
        *请根据目标命名空间替换 `<namespace>`。*

5.  **查看服务状态**:
    部署完成后，您可以使用以下命令或提供的 `status.sh` 脚本来检查资源状态：
    ```bash
    # 如果有 status.sh 脚本
    ./status.sh

    # 使用 kubectl 检查 Pods, Services, Deployments 等
    kubectl get all -n <namespace>
    ```

6.  **访问服务**:
    根据您部署的服务类型 (Service Type 如 NodePort, LoadBalancer) 或是否配置了 Ingress，通过相应的 IP/域名和端口访问服务。具体的访问方式通常会在该服务目录下的 `README.md` 中详细说明。

### 停止和删除服务

*   **删除服务 (移除 K8s 资源):**
    在相应的服务目录中执行删除操作。同样，优先使用提供的辅助脚本（如果存在）：

    *   **使用辅助脚本 (推荐如果存在):**
        运行卸载脚本。例如：
        ```bash
        ./uninstall.sh
        ```
        这个脚本通常会执行 `kubectl delete -f .` 或 `helm uninstall ...` 等命令。

    *   **直接使用 kubectl/helm:**
        如果目录中只有 YAML 文件：
        ```bash
        kubectl delete -f . -n <namespace>
        ```
        如果使用 Helm Chart 部署：
        ```bash
        helm uninstall <release-name> -n <namespace> # 替换 <release-name> 和 <namespace>
        ```
        *请注意：* 删除操作可能会删除相关的 PersistentVolumeClaim (PVC)，从而**丢失数据**。在执行删除前，请务必查看该服务目录下的 `README.md` 或 K8s YAML 文件，了解数据持久化的配置和删除行为，谨慎操作！
