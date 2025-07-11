前提准备
---

复制文件`.env.example`为`.env`，复制文件`values-example.yml`为`values.yml`，并根据需求修改配置内容。

安装应用
---

**1. 执行安装脚本**

```shell
bash install.sh
```

**2. 配置`hosts`文件，添加以下内容**

```
# 格式
[任意ingress-nginx节点IP] prometheus.lbs.com grafana.lbs.com alertmanager.lbs.com

# 示例
192.168.6.202 prometheus.lbs.com grafana.lbs.com alertmanager.lbs.com
```

验证应用
---

### 初步验证

```shell
bash status.sh
```

### 进阶验证

1. 访问`http://prometheus.lbs.com`，如果访问成功，则说明`prometheus`安装成功。
2. 访问`http://grafana.lbs.com`，如果访问成功，则说明`grafana`安装成功。
3. 访问`http://alertmanager.lbs.com`，如果访问成功，则说明`alertmanager`安装成功。

更新应用
---

修改`.env`、`values.yml`文件内容后，重新执行`install.sh`脚本即可。

卸载应用
---

**1. 执行卸载脚本**

```shell
bash uninstall.sh
```

**2. （可选）删除pvc**

```shell
# 加载变量
source .env

# 查看pvc
kubectl get pvc -n ${NAMESPACE}

# 删除pvc（可能有多个pvc要删除）
kubectl delete pvc [pvc名称] -n ${NAMESPACE}
```

> 更详细的教程请查看：[K8s采用Helm部署kube-prometheus-stack](https://lbs.wiki/pages/32b0bac/)
