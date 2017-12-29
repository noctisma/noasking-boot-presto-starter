# 基于Ambari安装的Hadoop环境 Presto安装部署脚本

## 目录结构

- conf：存放presto的配置文件,prest.conf.
- install_all_presto.sh：安装presto的脚本。
- start_all_presto.sh：启动所有presto节点的脚本。
- istop_all_presto.sh：关闭所有presto节点的脚本。
- prestorpms：presto所依赖的压缩包。

## 准备工作

### 下载JDK和Presto到prestorpms目录

- Presto:https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.177/presto-server-0.177.tar.gz
- JDK:jdk-8u131-linux-x64.tar.gz

### Ambari

安装presto之前，需要保证ambari已经安装完成。hadoop等相关集群可以正常启动。

### 安装presto
- 当完成上述的准备工作之后，就可以安装presto软件。
```commandline
install_all_presto.sh
```
- 安装完成之后，默认会启动所有节点的presto软件。不需要手动的启动
```commandline
start_all_presto.sh

```