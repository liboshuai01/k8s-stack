前提准备
---

复制文件`.env.example`为`.env`，并根据需求修改配置内容。

安装应用
---

**1. 执行安装脚本**

```shell
bash install.sh
```

**2. 复制文件`config-example.yml`为`config.yml`，并根据需求修改配置内容**

**3. 应用配置文件**

> 一定要等待metallb启动完成

```shell
kubectl apply -f config.yml
```

验证应用
---

### 初步验证

```shell
bash status.sh
```
   
### 进阶验证

**1. 创建一个 `test-metallb.yml` 文件**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-test-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-test
  template:
    metadata:
      labels:
        app: nginx-test
    spec:
      containers:
      - name: nginx-test
        image: nginx:1.25
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-test-service
spec:
  type: LoadBalancer # 关键：类型必须是 LoadBalancer
  selector:
    app: nginx-test
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

**2. 应用这个测试文件**

```shell
kubectl apply -f test-metallb.yml
```

**3. 等待片刻，然后检查 Service 的状态**

```shell
kubectl get svc nginx-test-service
```

您应该会看到类似下面的输出，其中 EXTERNAL-IP 已经被分配了一个来自您地址池的 IP（例如 192.168.6.240）。
```shell
NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
nginx-test-service   LoadBalancer   10.43.212.16   192.168.6.240   80:31593/TCP   5s
```
现在，您可以从局域网内的任何其他机器上通过 http://192.168.6.240 访问到这个 Nginx 服务了。

**4. 删除测试应用**

```shell
kubectl delete -f test-metallb.yml
```

更新应用
---

### 1. 若更新配置文件

修改`config.yml`文件内容后，重新执行`kubectl apply -f config.yml`命令。

### 2. 若更新metallb应用

修改`.env`，重新执行`install.sh`脚本。

卸载应用
---

**1. 取消应用配置文件**

```shell
kubectl delete -f config.yml
```

**2. 执行卸载脚本**

```shell
bash uninstall.sh
```
