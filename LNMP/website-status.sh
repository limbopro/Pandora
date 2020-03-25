#!/bin/bash
date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R")
limbocorrect=200 #返回状态码为200即能联通
imbocorrect=403 #返回状态码为403即访问被禁止
status=$(curl -I -m 10 -o /dev/null -s -w %{http_code} https://limbopro.xyz) #赋值返回状态码为status

##博客状态判断

if [ ${status} -eq $limbocorrect -o ${status} -eq $imbocorrect ]; #如果返回状态为200或返回状态为403则
then
echo "网站连接中..." #网站联通中
else
lnmp restart; #重启lnmp服务
fi

## 脚本中大于小于等于表述方式 https://blog.csdn.net/xiaofei125145/article/details/40187031
## curl 取得HTTP返回的状态码 https://blog.csdn.net/u013690521/article/details/52598731
