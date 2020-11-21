---
title: Scrapy在Windows下的坑爹安装
date: 2020-11-21 19:45:26
categories:
  - 学习笔记
  - Python
tags:
  - Scrapy
  - 
---

今天要装一个Scrapy来爬点内容，因为连到VPS上去搞有点麻烦，就说本地装一个吧。加速开启，然后很easy的pip3 install scrapy，本来等它装好，结果一看powershell里，居然报红字了。

刚开始还以为是不是这东西需要管理员权限，开了个管理员窗口还是装不上，仔细看看错误，发现了这么一段

```
error: Microsoft Visual C++ 14.0 is required. Get it with "Build Tools for Visual Studio": https://visualstudio.microsoft.com/downloads
```

这意思是少东西呗，那咱也别废话，既然给了链接就打开看看得了。看报错应该就是少一个c++编译器而已。

好家伙，打开这网页懵逼了。这不是一个完整的VS2019么？？这东西好久之前用过，大概有个15G差不多，难道我就装个Scrapy就要这么大动干戈么。

{% asset_img vs2019-website.png %}

这东西装上我估摸着最多用一次。所以还是不要装这种有的没得了。

去StackOverflow上看大佬们怎么整，结果也只是给了一个什么说明都没有的vc++2005的包。觉得有点不靠谱。

最后去微软那边找了很久，找到了这个页面。https://visualstudio.microsoft.com/zh-hans/visual-cpp-build-tools/

看起来很科学啊！！只是单独安装工具而已。实际下来以后还下载了大概1.5G的内容，感觉比之前的15G已经强多了。

装好这个重启以后终于能正常安装Scrapy了。