#!/bin/bash
# Usage:
#   bash <(curl -s https://raw.githubusercontent.com/mixool/script/master/wget.sh)
##  wget --no-check-certificate https://raw.githubusercontent.com/mixool/script/master/wget.sh && chmod +x wget.sh && ./wget.sh
### Total download depends on MBlimit, precision depends on url, speed depends on Url, change them if necessary.
MBlimit=1024
url=http://gxiami.alicdn.com/xiami-desktop/update/XiamiMac-01311741.dmg
Url=http://download.alicdn.com/dingtalk-desktop/mac_dmg/Release/DingTalk_v4.6.13.1.dmg
UA="Mozilla/5.0 (Linux; Android 9; Nokia X6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Mobile Safari/537.36"
#url=http://partner.iread.wo.com.cn/wonderfulapp/10118/apps/yuexianghui.apk
#Url=http://iread.wo.com.cn/download/channelclient/113/624/woreader_28000000.apk
#############################################################################################################

if grep '^[1-9][0-9]*$' <<< "$1" >/dev/null;then  
MBlimit=$(awk 'BEGIN{printf "%.f\n",('$1'*1024*1024)}')
else
MBlimit=$(awk 'BEGIN{printf "%.f\n",('$MBlimit'*1024*1024)}')
fi

length=$(wget --spider -U "$UA" $url -SO- /dev/null 2>&1 | grep -oE "Content-Length: [0-9]+" | grep -oE "[0-9]+")
Length=$(wget --spider -U "$UA" $Url -SO- /dev/null 2>&1 | grep -oE "Content-Length: [0-9]+" | grep -oE "[0-9]+")
t=$(awk 'BEGIN{printf int('$MBlimit'%'$Length'/'$length')}')
T=$(awk 'BEGIN{printf int('$MBlimit'/'$Length')}')
FMB=$(awk 'BEGIN{printf "%.2f\n",(('$MBlimit'-('$MBlimit'%'$Length'%'$length'))/1024/1024)}')
FGB=$(awk 'BEGIN{printf "%.3f\n",(('$MBlimit'-('$MBlimit'%'$Length'%'$length'))/1024/1024/1024)}')

echo $(date) Mission $(awk 'BEGIN{printf "%.f\n",('$MBlimit'/1024/1024)}') MB. Starting...
timer_start=`date "+%Y-%m-%d %H:%M:%S"`

if [ "$t" -gt 0 ]; then
	echo $(date) $(echo $url | awk -F"/" '{print $NF}') - $(awk 'BEGIN{printf "%.1f\n",('$length'/1024/1024)}') MB will be downloaded $t times...
	for((i = 1; i <= t; i++))
	do
		s=$(wget -U "$UA" -SO- $url 2>&1 >/dev/null | grep -E "written to stdout" | awk -F"[written]" '{print $1}')
		echo $s $i - $(awk 'BEGIN{printf "%.1f\n",('$i'*'$length'/1024/1024)}') MB
	done
fi

if [ "$T" -gt 0 ]; then
	echo $(date) $(echo $Url | awk -F"/" '{print $NF}') - $(awk 'BEGIN{printf "%.1f\n",('$Length'/1024/1024)}') MB will be downloaded $T times...
	for((j = 1; j <= T; j++))
	do
		S=$(wget -U "$UA" -SO- $Url 2>&1 >/dev/null | grep -E "written to stdout" | awk -F"[written]" '{print $1}')
		echo $S $j - $(awk 'BEGIN{printf "%.1f\n",('$j'*'$Length'/1024/1024)}') MB
	done
fi

timer_end=`date "+%Y-%m-%d %H:%M:%S"`
duration=`echo $(($(date +%s -d "${timer_end}") - $(date +%s -d "${timer_start}"))) | awk '{t=split("60 s 60 m 24 h 999 d",a);for(n=1;n<t;n+=2){if($1==0)break;s=$1%a[n]a[n+1]s;$1=int($1/a[n])}print s}'`

echo $(date) Mission $(awk 'BEGIN{printf "%.f\n",('$MBlimit'/1024/1024)}') MB. Accomplished $FMB MB \($FGB GB\) in $duration. Thanks! 
