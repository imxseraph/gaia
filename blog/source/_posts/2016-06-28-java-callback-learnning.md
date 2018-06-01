---
title: Java callback 回调学习
date: 2016-06-28 22:42:59
categories:
  - 学习笔记
  - Java
tags:
  - Java
  - callback
  - 回调
---

最近接触了一些前端 JavaScript 方面的东西，觉得 JS 最方便的地方便是各种回调函数，无论是 Ajax 还是与用户的前端交互，都是通过回调函数的形式实现的。于是乎来到 Java 中搜索了一下有关回调的相关内容，结果发现还真的有。查了很多文章，总算是弄清楚了 Java 中回调的使用方法，然而大部分讲解都没有说到其实际的用途，于是便再次进行记录，也是给自己一个备忘。

## 什么是回调

接触过 JS 或者做过服务端接口的人应该都会对回调十分熟悉。按我的理解，假设有 A 和 B 两个模块，A 调用 B 来执行某一个功能，这个功能执行可能会花费一些时间，而且 A 希望在 B 执行完之后得到通知，那么 B 执行完相关功能之后再对 A 进行通知的这个过程，就叫做回调。通俗来讲就是甲乙两个人，甲需要一把梯子来换灯泡，让乙去拿来，乙把梯子拿来以后需要告诉甲：梯子已经到了，可以换灯泡了。

在 JS 中的回调十分便捷，只要将收到回调后需要执行的方法传入调用的方法中即可，这种回调方式的调用不仅限于 JS，Ruby 中也有类似的语法，然而对于 Java 来说，实现回调虽然有些麻烦，但是仍然有着解决办法。

## Java 中的回调

在 Java 中实现一个回调不像脚本语言那样简洁优雅，但是会有一种更加规范的感觉。

此处还是用之前提到的的 A 和 B，生命这两个模块为两个类，主要归结为以下步骤：

1. 定义一个 Callback 接口，用来指明回调时候需要执行的方法。
2. 让 A 类实现 callback 接口，并且 A 类需要持有一个 B 的实例对象 b（因为只有持有才能调用）。
3. 让 B 类中实现一个参数带有 callback 接口参数的方法 f(Callback callback, Object args)。
4. A 类的实例对象 a 调用 b.f，并且将 a 自身作为 callback 参数传入。
5. b.f 此时可以通过 callback 调用 A 中定义的 Callback 接口中的问题。

乍看下来感觉整个人都不好了，乱七八糟的，其实结合代码的话会看着很简单。此处以刚才说到的甲让乙搬梯子，然后甲用梯子换灯泡的情景，写一个 Demo。

首先是定义接口类，该接口声明了甲需要完成的换灯泡工作：

```java
package io.muxin;

/**
 * 回调接口定义,
 * Created by mxfang on 16/6/29.
 */
public interface Callback {
    /**
     * 换灯泡过程
     */
    void changeBulb();
}
```

其次先定义乙的类，乙的类是提供一个搬梯子的功能，并且在搬好以后通知让他搬梯子的人：

```java
package io.muxin;

/**
 * 这是乙的类
 * Created by mxfang on 16/6/29.
 */
public class Yi {
    /**
     * 去搬梯子, 搬好以后通过回调通知甲
     * @param callback 持有甲的回调
     */
    public void getLadder(Callback callback) {
        System.out.println("乙: 开始去搬梯子");
        try {
            // 搬梯子需要时间
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("乙: 梯子搬来了, 通知甲");
        // 回调甲
        callback.changeBulb();
    }
}
```

 然后定义甲，甲有两个功能，第一是尝试去换灯泡（不确定有没有梯子），发现没梯子的话让乙去搬梯子，第二个功能是正式换灯泡，这个由乙来通知甲进行操作：

```java
package io.muxin;

/**
 * 这是甲的类
 * Created by mxfang on 16/6/29.
 */
public class Jia implements Callback{
    private Yi yi;

    /**
     * 构造函数, 让甲能持有一个乙的实例
     * @param yi 乙的实例
     */
    public Jia(Yi yi) {
        this.yi = yi;
    }

    /**
     * 尝试换灯泡
     */
    public void tryChangeBulb() {
        System.out.println("甲: 没有梯子, 让乙先去搬梯子");
        yi.getLadder(this);
    }


    @Override
    public void changeBulb() {
        System.out.println("甲: 梯子到位, 开始换灯泡啦");
    }
}
```

 最后是测试类：

```java
package io.muxin;

public class Main {

    public static void main(String[] args) {
        // 首先要有一个乙
        Yi yi = new Yi();
        // 然后甲需要持有乙
        Jia jia = new Jia(yi);
        // 让甲尝试换灯泡
        jia.tryChangeBulb();
    }
}
```

运行结果：

```
甲: 没有梯子, 让乙先去搬梯子
乙: 开始去搬梯子
乙: 梯子搬来了, 通知甲
甲: 梯子到位, 开始换灯泡啦

Process finished with exit code 0
```

可以看到整个过程被完整的执行了下来，重点在于乙做一个耗时工作之后能够反向调用一个甲的方法。

这里可能有人会问为何会使用接口，其实效果等价于 B 类也持有了一个 A 类的实例，然后对 A 进行调用。我个人认为此处使用接口的意义在于可以将 B 类做的事情通用化，比如在数据库操作中，A 类可能要执行一个写入操作，然而 B 类需要执行对数据库的连接和打开操作，那么 B 类可能是 MySQL、Redis、Mongodb 等不同数据库的操作实例。

第二个感觉可能的情况是 A 和 B 模块分别属于两个人或者团队编写，通过提前制定好的接口，根据时序来实现功能。

## 拓展

写在这篇文章的最后，Java 的回调并不仅仅用于异步的操作。大家可以跟我一起回想起来 Android 开发的时候，设置一个按钮的动作，setOnClickListener 这个方法，需要传入一个实现了 OnClickListener 接口的类来进行设定，这就是一个同步回调的过程，我之前也没有发觉这是一个回调，直到查阅了相关资料后才恍然大悟。

这次对回调的学习暂且到这里，也算是对回调有了个基本了解，它的思路被用在了 Java 中很多很多地方，比如 Android 和 Hibernate 中都大量使用回调，以后有时间去阅读代码的时候再深入的来学习吧。
