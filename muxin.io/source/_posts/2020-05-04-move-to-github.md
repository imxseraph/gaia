---
title: 源代码迁移到github咯~
date: 2020-05-04 23:34:05
categories:
  - 建站手记
tags:
  - 建站
  - github
  - gitlab
---
其实很早就看到github开放免费的私有仓库了（翻了翻资料是19年初了），但是因为这套gitlab-ci用的很好的，所以没有迁移的动力。

五一终于腾出时间看了一下github上对标的workflow功能，也是蛮有意思的。趁着这个空档，也就一并迁过来了。

为啥会非要私有仓库？那是因为翻墙代码也在上面啊，考虑再三还是把密码啥的写到代码里最好维护，部署起来也方便。但这个要是公开了，蹭我翻墙也就不说了，喝茶去了就搞笑了。。

迁移了四个仓库过来，总共花费了6小时…研究了下workflow有点费劲。顺手也把老掉牙的hexo和next版本升了一下，看起来没啥大问题。

### 几个仓库

{% asset_img gitlab-projects.png %}

#### gaia

这是一个总体的网关，里面包含了一个核心nginx，嵌了多个域名和转发。同时本hexo工程也在里面，主要是考虑到单独拆一个还需要再搞个nginx，麻烦。单纯的配置，就公开了。

#### chronos

这个是闲的没事儿用go写的，本来想实现一个网站登录，但是后来一直没继续写下去，之后会继续在上面搞的。但我最近又觉得Python不错，后面看会不会开个Python的东西出来了，也没啥敏感内容。

#### v2ray

这东西就不说了。就是个翻墙了，迁过来也是私有了。主要是有私有的key之类的东西，这东西也是容器化了。基于v2ray的官方镜像叠了一层配置，主要是可以简单的重新打包来升级。不开放是因为认证key也写在配置文件里，开放了我怕不是我机器要被各位大佬爆掉了。

#### deploy

这玩意儿就是几个简单的docker-compose.yml了，其他几个工程每个的机器上的部署都在这个里面写着。因为我偷懒所以把cloudflare的key也放进去了…所以没法公开。


有相同需求的可以去github上看看参考一下。

后面再开个文章把现在网站的结构记一记好了。

### workflow和gitlab-ci

之前好好研究了一下gitlab-ci的方式，gitlab-ci可以全部基于docker镜像，这个比较方便，我自己封装了好几个私有的image，用来打包、部署等等。

切换到workflow发现思路不太一样，workflow里面有个action的概念，乍看起来也是封装的一系列脚本，基本基于shell，但是不能私有是个问题。毕竟我想把机器的deploy key写进去，还是有私有化的需求的。但是看文档，这东西只能public状态才能用。

两者比起来我还是觉得gitlab-ci好用……可能是用久了，workflow我觉得设计思路挺独特，具体还没发现很好用的地方。

之前还自己部署了一台gitlab-runner来跑ci，这次也懒得弄了，直接薅github的羊毛算了。

### 有点蛋疼的部署

所有的部署镜像都是我在docker hub上的私有仓库，这本身没什么问题，但是gitlab-ci可以在runner里面直接访问到私有仓库，拉到我的私有仓库进行部署，这个在workflow里没法这么干，只能把ssh key写到secrets里面，代码动态的保存下来进行远程deploy。看起来有点不科学，不过先这么用了。

```yaml
- name: Create the key
  run: echo "${{ secrets.PRIVATE_KEY }}" > key && chmod 600 key
- name: Deploy
  run: ssh -i key -o StrictHostKeychecking=no root@muxin.io "cd /mnt/deploy/gaia && docker-compose down --rmi all && docker-compose up -d"
```

没错代码就是这么的妖！话说这个key应该跑完workflow会被删掉吧？？？要是没删掉下一个workflow还能用就gg了。我也没细看，相信不会这么蠢的设计的。

第二个不爽的地方是github里面不能建group，导致我每个项目相同的secrets都要手动配一次，这个感觉也不科学。。

基本初步体验就这样，后面看看有新项目要部署了再仔细研究下。