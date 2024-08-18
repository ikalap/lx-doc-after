FROM openjdk:17-alpine
LABEL authors="kalpa"
LABEL maintainer="kalpa"

# 应用名称和版本
ENV APP_NAME=springboot_test
ENV APP_VERSION=0.0.1

# 创建应用目录
WORKDIR /app

# 编译后的spring boot jar 文件复制到镜像
COPY target/lx-doc.jar /app.jar

# 暴露容器端口
EXPOSE 8080

# 允许spring boot 应用
ENTRYPOINT ["java", "-jar", "/app.jar"]
