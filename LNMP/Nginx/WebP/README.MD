部署 Webp 新世代图片格式，压缩图片大小，加快网页加载速度。

## 转换 PNG/JPEG 图片为 WEBP
```
echo "===== Converting images into WebP .webp ====="
years=$(date "+%Y")
month=$(date "+%m")
day=$(date "+%d")

echo "$years年$month月$day日"

for x in `find /home/wwwroot/typecho/usr/uploads/$years/$month/* -type f \( -iname \*.jpeg -o -iname \*.jpg -o -iname \*.JPG -o -iname \*.png \)`
do cwebp -quiet -q 75 ${x} -o ${x}.webp;
echo "Converted $x to ${x}.webp"
done
```

## Nginx 配置文件
```
## Webp 图片切换
        location ~ .*\.(gif|jpg|jpeg|png)$ {
        add_header Cache-Control "public, no-transform";
        add_header Vary "Accept-Encoding";
        try_files $uri$webp_suffix $uri =404;
        expires max;
        access_log off;
        }
```

