��������Centos7.5�±��룬�ʽ�ȷ��Centos7.5�£������²������ȶ����С�

��װ����
1.��װepelԴ���������һ�£����ȹ���Դ��
   rpm -ivh https://mirrors.ustc.edu.cn/epel/epel-release-latest-7.noarch.rpm   
   rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
   �������EPELԴ�޷���װ��������������һ�°ɡ�
2.��װ������
   sudo yum install -y glog protobuf

3.��ɡ�

��Ϊpika_port��nemo_blackwindow�����̫�󣬹�ɾ�������Ӧ�ã�������Ҫ���ӹٷ��������ء�

������������������Ȼ�������У���ɲ�������������ȱ����Щ����������ָ�����һ����
ldd pika
strace pika