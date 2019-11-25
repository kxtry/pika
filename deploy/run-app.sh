#!/bin/sh

# crontab -e
# */1 * * * * sh /data/scripts/run-app.sh start

path_current=`pwd`
path_script=$(cd "$(dirname "$0")"; pwd)
path_data=$path_script/data
logfile=$path_data/check.log
mode=$1
name=pika
pikaPID=0
rsyncPID=0

if [ -f $path_data/pika.pid ];then
   pikaPID=`cat $path_data/pika.pid`
fi

if [ -f $path_data/dbsync/rsync/slash_rsync.pid ];then
   rsyncPID=`cat $path_data/dbsync/rsync/slash_rsync.pid`
fi

app_process=`ps -ef | grep "$name"| grep -v grep`

if [ ! -d $path_data ];then 
   mkdir -p $path_data
fi

function qecho() {
   echo $* >> $logfile
   echo $*
}


s=`du -b $logfile | awk '{print $1}'`
if [ $s -gt 104857600 ];then
   qecho "ready rotate $logfile"
   rm "${logfile}.1"
   mv $logfile "${logfile}.1"
fi

qecho `date`
qecho "ready to check...."
case "$mode" in
   'install')
      if [ ! -f $path_script/.envok ]; then
         rpm -ivh https://mirrors.ustc.edu.cn/epel/epel-release-latest-7.noarch.rpm
         yum install -y glog protobuf && touch $path_script/.envok
      fi
      if [ ! -f $path_script/conf/pika.conf ]; then
         mkdir -p $path_data && /bin/cp -rf $path_script/pika.conf.template $path_script/conf/pika.conf && qecho "$path_script/conf/pika.conf" | xargs /bin/sed -i "s#{{path_current}}#$path_data#g"
      fi
      ;;
   'cron')
      qecho "ready to install pika cron task:/etc/cron.d/pika.sh"
      echo "*/1 * * * * root sh $path_script/run-app.sh start" > /etc/cron.d/pika.sh && qecho "success to install cron task."
      ;;
   'start')
      qecho "it's ready to start op...."
      qecho "$app_process"
      qecho "pika process:$pikaPID, rsync process:$rsyncPID"
      if [ -d /proc/$pikaPID ]; then
         if [ -d /proc/$rsyncPID ]; then
            qecho "the service is health."
            exit 1
         fi
      fi
      qecho "the service has stop,ready to clean and restart"
      if [ -d /proc/$rsyncPID ]; then
         kill -9 $rsyncPID && qecho "success to kill rsync process:$rsyncPID"
      fi
      if [ -d /proc/$pikaPID ]; then
         kill -9 $pikaPID && qecho "success to kill pika process:$pikaPID"
      fi
      rm -f $path_data/dbsync/rsync/slash_rsync.pid
      rm -f $path_data/pika.pid
      cd $path_script  
      nohup $path_script/bin/$name -c $path_script/conf/${name}.conf > $path_data/info.txt 2>&1 &
      qecho "success to restart $name"
      cd $path_current
      qecho 'success to start.'
      ;;
   'stop')
      qecho "it's ready to check process..."
      qecho "$app_process"
      if [ -d /proc/$rsyncPID ]; then
         kill -9 $rsyncPID && qecho "success to kill rsync process:$rsyncPID"
      fi
      if [ -d /proc/$pikaPID ]; then
         kill -9 $pikaPID && qecho "success to kill pika process:$pikaPID"
      fi
      rm -f $path_data/dbsync/rsync/slash_rsync.pid
      rm -f $path_data/pika.pid
      qecho 'success to kill.'
      ;;
   *)
      basename=`basename "$0"`
      qecho "Usage: $basename  {install|cron|start|stop}  [ server options ]"
      exit 1
      ;;
esac
exit 1
