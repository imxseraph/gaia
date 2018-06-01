---
title: HTML 中固定 footer 的方法
date: 2017-01-02 20:55:43
categories:
  - 经验分享
tags:
  - Html
---
有时在 Html 中我们需要固定底部的版权信息等内容，期望的展示方式是页面撑满浏览器，最下方是 footer 的内容。

```html
<div class="main">
  <div class="content">
    ...
  </div>
  <footer>版权所有</footer>
</div>
```

如到所示，我们希望的是`footer`永远占据页面的最下方，而`content`内容则填满页面的其他部分。

## 想当然的方法

想当然的方法去实现，是直接将`div.main`部分的`height`设置为`100%`，这样可以直接撑满页面，虽然在内容少的时候确实达到了我们想要的效果，但弊端也十分明显——在页面内容多于一页的时候，内容会展示不全，因为设置了固定的`height`，所以内容并不会将`div.main`进一步撑开。所以这样是不行的。

## 使用`min-height`

Html 中可以使用`min-height`来指定内容高度。根据这个思路我们可以将`div.conent`的`min-height`设置为`80%`，同时将`footer`的`min-height`设置为`20%`。

然而这个解决方案看起来很完美，实际上用起来的时候还是会有问题，原因如下：

一个元素如果要指定`min-height`，那么它的父元素必须指定`height`，指定`min-height`也无济于事。也就是说`div.main`必须指定`height`这一属性。然而还是那个`height`不能自动变大的问题。

## 最终方案——使用`position`

那么最终的解决方案应该怎样呢？答案是使用`position`

先给出最终的Html和CSS代码：

```html
<div class="main">
  <div class="content">
    ...
  </div>
  <footer>版权所有</footer>
</div>
```

```css
div.main {
  min-height: 100%;
  position: relative;
  padding-bottom: 10rem;
}

footer {
  height: 10rem;
  position: absolute;
  bottom: 0;
}
```

首先将`div.main`的最小高度设置为100%，随后将其位置指定为`relative`；随后指定`footer`的位置为`absolute`，这样`footer`会相对于上一个位置被指定为`relative`的元素进行布局，随后`bottom: 0;`将`footer`设置在了`div.main`的最下方。

当然不要忘记了`div.main`需要有一个`padding-bottom`，大小等于`footer`的高度，这样内容才不会错位。

到此我们就实现了最完美的固定`footer`的样式。

