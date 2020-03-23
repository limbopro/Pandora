#!/bin/sh
wget --mirror -t 2 -S -N -k https://limbopro.xyz -P /home/wwwroot/typecho/; #做网站镜像
cd /root/hexo/limbopro.github.io; #进入github 仓库本地目录
cp -rf /home/wwwroot/typecho/usr/themes/handsome/assets/* /root/hexo/limbopro.github.io/usr/themes/handsome/assets/ #copy.css
cp -rf /home/wwwroot/typecho/limbopro.xyz/* /root/hexo/limbopro.github.io/ #copy.html #html 上传
cp -rf /home/wwwroot/typecho/usr/uploads/* /root/hexo/limbopro.github.io/usr/uploads/ #copy.resource.static
cp -rf /home/wwwroot/typecho/usr/themes/handsome/assets/* /root/hexo/limbopro.github.io/usr/themes/handsome/assets/ #copy.css
cp -rf /home/wwwroot/typecho/search.html.mirror /root/hexo/limbopro.github.io/search.html #更换搜索UID
#cp -rf /root/hexo/limbopro/CNAME /root/hexo/limbopro/public/ #copy.CNAME #同步CNAME文件以使得 github.io 绑定域名
rm -rf /root/hexo/limbopro.github.io/CNAME #删除CNAME文件以使得 github.io 取消域名绑定
cd /root/hexo/limbopro.github.io #再次进入
git add . #提交所以新增
git commit -m "fucking update mirror" #提交
git push origin master #PUSH到源仓库
#cd /root/hexo/limbopro/
#hexo d
