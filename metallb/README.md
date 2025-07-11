前提准备
---

复制文件`.env.example`为`.env`，复制文件`config-example.yml`为`config.yml`，并根据需求修改配置内容。

安装应用
---

```shell
bash install.sh
```

验证应用
---

### 初步验证

```shell
bash status.sh
```
   
### 进阶验证

**1. 创建一个 `test-metallb.yaml` 文件**

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
kubectl apply -f test-metallb.yaml
```

**3. 等待片刻，然后检查 Service 的状态**

```shell
kubectl get svc nginx-test-service
```

您应该会看到类似下面的输出，其中 EXTERNAL-IP 已经被分配了一个来自您地址池的 IP（例如 192.168.6.240）。
```shell
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)        AGE
nginx-service   LoadBalancer   10.101.5.123   192.168.6.240    80:31234/TCP   1m
```
现在，您可以从局域网内的任何其他机器上通过 http://192.168.6.240 访问到这个 Nginx 服务了。

更新应用
---

修改`.env`、`config.yml`文件内容后，重新执行`install.sh`脚本即可。

卸载应用
---

```shell
bash uninstall.sh
```
