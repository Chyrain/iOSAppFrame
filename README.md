# iOSAppFrame
A App frame for iOS rapid development


## 生成*.appiconset

[https://github.com/Nonchalant/AppIcon](https://github.com/Nonchalant/AppIcon)

## 配置.pch
	
在PROJRCT -> Build Settings -> Prefix Header -> $(SRCROOT)/iOSAppFrame/PrefixHeader.pch

> 其中iOSAppFrame为当前Target名

## 页面结构修改

修改对应的Storeboard名称，并在`RootTabBarController.m`的方法`initCutomBar`修改对应Storyboard的代码。
