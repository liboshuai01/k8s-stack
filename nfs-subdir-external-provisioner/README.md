> 更详细的教程请查看：[K8s采用Helm部署nfs-subdir-external-provisioner实现动态存储](https://lbs.wiki/pages/e3673e0e/)

前提准备
---

修改`.env`文件中配置的变量为自定义内容，如安装的命名空间、helm实例名称、char版本号等（可选）。

安装应用
---

1. 执行安装脚本
    ```shell
    bash install.sh
    ```

2. 取消`local-path`存储类的默认值设置
    ```shell
    kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
    ```

3. 卸载`local-path`存储类
    ```shell
    kubectl delete storageclass local-path
    ```

4. 禁用k3s的`local-path`组件
    ```shell
    # sudo vim /etc/systemd/system/k3s.service
    ExecStart=/usr/local/bin/k3s \
        server \
        # 添加此行到最后（不要添加注释）
        --disable local-storage \
    
    # 重新加载 systemd 配置并重启 K3s 服务
    sudo systemctl daemon-reload
    sudo systemctl restart k3s
    ```

初步验证
---

```shell
bash status.sh
```

进阶验证
---

1. 编写测试 PVC 资源配置

    > pvc-test.yaml
    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: pvc-test
    spec:
      storageClassName: "nfs" # 存储类名称
      accessModes:
        - ReadWriteMany
      resources:
        requests:
          storage: 10Mi
    ```

2. 创建测试 PVC
    ```shell
    kubectl apply -f pvc-test.yaml
    ```
   
3. 查看测试 PVC 状态
    ```shell
    kubectl get pvc pvc-test
    ```
    理想状态为 Bound，表示 PVC 已成功绑定底层 PV。

更新应用
---

修改`.env`或`install.sh`文件中的内容，后重新执行`install.sh`脚本即可。

卸载应用
---

```shell
bash uninstall.sh
```
