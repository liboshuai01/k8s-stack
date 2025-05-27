前提准备
---

修改`.env`文件中配置的变量为自定义内容，如安装的命名空间、helm实例名称、char版本号等（可选）。

安装应用
---

```shell
bash install.sh
```

初步验证
---

```shell
bash status.sh
```

进阶验证
---

1. 创建临时应用，访问`kafka-exporter`的metrics地址

    ```shell
    # 启动一个临时pod用于测试 (例如在 default 命名空间)
    kubectl run -i --tty --rm debug --image=curlimages/curl --restart=Never -- sh
    
    # 在临时pod的shell中执行，有值响应即可
    # 格式为：curl http://${RELEASE_NAME}-prometheus-kafka-exporter.${NAMESPACE}.svc.cluster.local:9308/metrics
    curl http://my-kafka-exporter-prometheus-kafka-exporter.kafka.svc.cluster.local:9308/metrics
    ```

2. 访问`prometheus`的`/targets`页面，查看`kafka-exporter`是否正常 scrape metrics

3. 访问`grafana`并导入面板`7589`，查看`kafka-exporter`的dashboard是否正常显示。

> 注意：必须先使用非控制台生产者、消费者进行生产和消费数据，否则grafana面板会无数据

更新应用
---

修改`.env`或`install.sh`文件中的内容，后重新执行`install.sh`脚本即可。

卸载应用
---

```shell
bash uninstall.sh
```

> 更详细的教程请查看：[K8s采用Helm部署kafka-exporter实战指南](https://lbs.wiki/pages/64683bd3/)
