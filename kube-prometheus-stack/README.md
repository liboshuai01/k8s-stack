前提准备
---

修改`.env`文件中配置的变量为自定义内容，如安装的命名空间、helm实例名称、char版本号等（可选）。

安装应用
---

**1. 执行安装脚本**

```shell
bash install.sh
```

**2. 配置`hosts`文件，添加以下内容**

```
[任意ingress-nginx节点IP] prometheus.lbs.com grafana.lbs.com alertmanager.lbs.com

# 例如
# 192.168.6.202 prometheus.lbs.com grafana.lbs.com alertmanager.lbs.com
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

修改`.env`或`install.sh`文件中的内容，后重新执行`install.sh`脚本即可。

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
