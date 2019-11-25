程序是在Centos7.5下编译，故仅确保Centos7.5下，按以下步骤能稳定运行。

安装步骤
1.安装epel源，下面随便一下，优先国内源。
   rpm -ivh https://mirrors.ustc.edu.cn/epel/epel-release-latest-7.noarch.rpm   
   rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
   如果上述EPEL源无法安装，则在网上搜索一下吧。
2.安装依赖项
   sudo yum install -y glog protobuf

3.完成。

因为pika_port和nemo_blackwindow的体积太大，故删除了相关应用，如有需要，从官方渠道下载。

如果经过上述处理后，仍然不能运行，则可采用如下命令检查缺少哪些依赖，下述指令随便一个。
ldd pika
strace pika