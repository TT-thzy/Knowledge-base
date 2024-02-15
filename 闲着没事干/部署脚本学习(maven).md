## 部署脚本学习

```shell
#切换到项目路径
cd /data/admin/code/{projectName}	 

echo '---当前分支---'
	#列出本地已经存在的分支，并且在当前分支的前面用"*"标记
git branch					


echo '---拉取最新更新---'
#拉取远程仓库master分支代码合并至本地仓库master分支
git pull origin master				

#本地install并打包跳过test
mvn clean install -DskipTests -U		

#复制jar包至启动目录
cp /data/admin/code/mizar-major/mizar-major-boot/target/{projectName}.jar /data/admin/target/{projectName}

echo '开始启动';

#kill原有进程
pid=$(jps -l | grep mizar-major | awk '{print $1}');
if [ -n "$pid" ] ;then
    kill -9 $pid;
    echo "killed $pid port:8094"		#注意端口号
else echo "pid not exist"
fi


echo '睡眠10s';
sleep 10s;


echo '启动java服务...'
#启动
nohup java -server -Xss1M -Xms3G -Xmx3G \			#配置jvm
-XX:+UseG1GC \
-XX:+UseNUMA \
-XX:+UseCompressedOops \
-XX:+AlwaysPreTouch \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=mizar_heap.hprof \
-XX:-OmitStackTraceInFastThrow \
-Dcom.sun.management.jmxremote=true \
-Dcom.sun.management.jmxremote.port=1079 \
-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.ssl=false \
-Dfile.encoding=utf-8 \
-Djute.maxbuffer=5242880 \
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=10004 \
-jar \
/data/admin/target/{projectName}.jar \	#jar包地址
-Dserver.port=8094 \	#启动端口
-Plifecycle=INSTALL \	#公司框架自带要求
--spring.profiles.active=pre > /data/admin/target/{projectName}/out.log 2>&1 &		#环境与日志输出目录

tail -100f /data/admin/target/{projectName}/out.log	#实时查看日志
```