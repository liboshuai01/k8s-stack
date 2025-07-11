前提准备
---

复制文件`.env.example`为`.env`，复制文件`values-example.yml`为`values.yml`，并根据需求修改配置内容。

安装应用
---

**1. 执行安装脚本**

```shell
bash install.sh
```

**2. 获取`ingress`的`EXTERNAL-IP`**

```shell
# EXTERNAL-IP 为 192.168.6.241
[lbs@master ingress-nginx]$ kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.43.51.133    192.168.6.241   80:32443/TCP,443:30784/TCP   26s
ingress-nginx-controller-admission   ClusterIP      10.43.230.20    <none>          443/TCP                      26s
ingress-nginx-controller-metrics     ClusterIP      10.43.141.155   <none>          10254/TCP                    26s
```

**3. 配置客户端机器`hosts`文件，添加一下内容**

```
> 格式
EXTERNAL-IP    nginx.lbs.com

> 示例
192.168.6.241  nginx.lbs.com
```

验证应用
---

### 初步验证

```shell
bash status.sh
```

### 进阶验证

访问`http://nginx.lbs.com`(ingress.hostname值)，如果访问成功，则说明`prometheus`安装成功。

### 监控验证

**1. 访问`prometheus`的`/targets`页面，查看`nginx-exporter`是否正常 scrape metrics**

**2. 访问`grafana`并导入面板文件`dashboard.json`中的内容，查看`kafka-exporter`的dashboard是否正常显示。**

更新应用
---

修改`.env`、`values.yml`文件内容后，重新执行`install.sh`脚本即可。

卸载应用
---

**1. 执行卸载脚本**

```shell
bash uninstall.sh
```

## 如何访问

```markdown
> 配置项
ingress.hostname

> 示例
nginx.lbs.com
```

> 更详细的教程请查看：[K8s采用Helm部署nginx(https://lbs.wiki/pages/fdb2064a/)

> 如果您在Kubernetes集群中已经安装并配置了 ingress-nginx，那么它将作为您集群的统一入口和反向代理。在这种情况下，您通常不需要在项目的Pod内部单独部署额外的Nginx实例。
> 
> 所以此处我们安装的Nginx实例只是为了测试，并没有提供完整的配置文件挂载、网站静态文件挂载等配置项。
