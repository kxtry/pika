
# 1.安装docker环境
# 2.执行docker构建指令。
#    docker build -t pika .
# 3.运行容器
    docker run pika:latest bash -c "ping 127.0.0.1"
# 4.假如运行的容器名为d600bff8e7c8
# 5.使用容器拷贝指令，拷贝到宿主机的本地目录
     docker cp d600bff8e7c8:/pika/output ./
