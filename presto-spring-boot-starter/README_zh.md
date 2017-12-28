# presto-spring-boot-starter

> 

### 如何使用

#### 1、添加依赖

在项目的pom.xml中添加引用

```commandline
<dependency>
    <groupId>com.noasking</groupId>
    <artifactId>noasking-boot-presto-starter</artifactId>
    <version>1.0-SNAPSHOT</version>
</dependency>
```

#### 2、配置文件修改

- appliation.yml
```commandline
presto:
  jdbc:
    driver: com.facebook.presto.jdbc.PrestoDriver
    username: root
    password: root
    url: jdbc:presto://10.10.10.21:9000/hive/default
```

或者

- applicaton.properties
```commandline
presto.jdbc.driver=com.facebook.presto.jdbc.PrestoDriver
presto.jdbc.username=root
presto.jdbc.password=root
presto.jdbc.url=jdbc:presto://10.10.10.21:9000/hive/default
```

##### 默认值

- driver: com.facebook.presto.jdbc.PrestoDriver
- username: root
- password: root



