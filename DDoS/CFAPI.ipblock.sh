#!/bin/bash 

   function GetSysCPU 
 {
   CpuIdle=`vmstat 1 5 |sed -n '3,$p' | awk '{x = x + $15} END {print x/5}' | awk -F. '{print $1}'` 
   CpuNum=`echo "100-$CpuIdle" | bc` 
   echo $CpuNum 
 }
   cpu=`GetSysCPU` 
   max=60
if [ $cpu -gt $max ];
   then 
   maxrequest=60
   else 
   maxrequest=240
   #/home/cfcache.pure.sh;
fi

> /home/tnt.log; #清除拉取的日志
#> /home/tnt.conf;

iaccess= #源日志
maxtimes=1 #提取最近N分钟的请求至临时日志

function define()
{
    #引入参数环节
    ori_log_path="/home/wwwlogs/limbopro.xyz/access."${iaccess}"log" #原始日志存放位置
    tmp_log_path="/home/tnt.log" #生成的临时日志存放位置
    date_stamp=`date -d "-"$maxtimes"min" +%Y:%H:%M:%S` #引入时间范围参数
    day_stamp=`date +%d` #日期
}

function gather()
{
    #awk -F '[/ "\[]' -vnstamp="$date_stamp" -vdstamp="$day_stamp" '$7>=nstamp && $5==dstamp' ${ori_log_path} > ${tmp_log_path}; #根据时间范围从原始日志处读取并写入临时日志
    awk -F '[/ "[]' -vnstamp="$date_stamp" -vdstamp="$day_stamp" '$7>=nstamp && $5==dstamp' ${ori_log_path} > ${tmp_log_path}; #根据时间范围从原始日志处读取并写入临时日志
    log_num=`cat ${tmp_log_path} | wc -l`; #计算时间范围内的网络请求次数
    request_time=`awk '{print $(NF-1)}' ${tmp_log_path} | awk '{sum+=$1}END{print sum}'`; #请求时间
    ave_request_time=`echo | awk "{print ${request_time}/${log_num}}" `; #平均请求时间
    ipcounts=$(awk '{print $1}' $tmp_log_path | sort -n | uniq | wc -l); #计算IP数量
    date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R")
    echo "${date}" "网站最近"${maxtimes}"分钟总请求数为 ${log_num}" 次
}

function output()
{
date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R") #无所事事
}

function main()
{
    define
    gather
    output
}
## 拉取日志结束
main

## 拉黑开始
date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R")
blockip=/home/tnt.conf #黑名单存储位置
echocf=/home/echo.cf.ddos.conf #Cloudflare 黑名单收集

##记录每次操作

for ip in $(awk '{cnt[$1]++;}END{for(i in cnt){printf("%s\t%s\n", cnt[i], i);}}' ${tmp_log_path} | awk '{if($1>'$maxrequest') print $2}') 
do 
date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R")
echo "${date}" "deny ${ip};" >> /home/tnt.bak
echo "deny ${ip};" >> $blockip #加入黑名单套餐
echo "${ip}" >> $echocf
done


##提交IP黑名单数据至 Cloudflare
##block, challenge, whitelist, js_challenge
##Cloudflare 配置文件

CFEMAIL="这里填写Cloudflare邮箱📮" #Email 
CFAPIKEY="这里填写APIKEY" #API token Cloudflare 控制面板-你的域名-右下角-API 可找到
ZONESID="这里填写ZONESID" #Zone ID Cloudflare 控制面板-你的域名-右下角-API 可找到
IPADDR=$(</home/echo.cf.ddos.conf)

for IPADDR in ${IPADDR[@]}; do
echo $IPADDR
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONESID/firewall/access_rules/rules" \
  -H "X-Auth-Email: $CFEMAIL" \
  -H "X-Auth-Key: $CFAPIKEY" \
  -H "Content-Type: application/json" \
  --data '{"mode":"block","configuration":{"target":"ip","value":"'$IPADDR'"},"notes":"limbo-auto-block ${tnt}"}'
done

> /home/echo.cf.ddos.conf

## 参考 https://www.9sep.org/cloudflare-batch-firewall-blacklist
## 完整 https://limbopro.xyz/archives/6949.html
