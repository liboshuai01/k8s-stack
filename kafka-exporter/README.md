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

访问`http://[service].[namespace].svc.cluster.local:[端口号]`，
例如`http://my-kafka-exporter-prometheus-kafka-exporter.kafka.svc.cluster.local:9308`。
如果访问成功，则说明`kafak-exporter`安装成功。

更新应用
---

修改`.env`或`install.sh`文件中的内容，后重新执行`install.sh`脚本即可。

卸载应用
---

```shell
bash uninstall.sh
```
