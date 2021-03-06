# 金山云短视频编辑SDK KSYMediaEditorKit

## 阅读对象
本文档面向所有使用[金山云短视频SDK][KSYMediaEditorKit]的开发、测试人员等, 要求读者具有一定的iOS编程开发经验，并且要求读者具备阅读[wiki][wiki]的习惯。

|![svod_1.png](https://raw.githubusercontent.com/wiki/ksvc/KSYMediaEditorKit_iOS/images/svod_1.png)|![svod_2.png](https://raw.githubusercontent.com/wiki/ksvc/KSYMediaEditorKit_iOS/images/svod_2.png)|![svod_3.png](https://raw.githubusercontent.com/wiki/ksvc/KSYMediaEditorKit_iOS/images/svod_3.png)|

|![svod_4.png](https://raw.githubusercontent.com/wiki/ksvc/KSYMediaEditorKit_iOS/images/svod_4.png)|![svod_5.png](https://raw.githubusercontent.com/wiki/ksvc/KSYMediaEditorKit_iOS/images/svod_5.png)|



## 一. 功能特性
[KSYMediaEditorKit][KSYMediaEditorKit]是金山云提供的短视频编辑SDK，该SDK依赖[推流播放融合iOS端sdk][libksygpulive]版本,目前主要有以下功能：

* [x] 短视频录制
* [x] 录制/导入视频预览编辑
* [x] 录制实时美颜，滤镜
* [x] 录制变声、混音、背景音
* [x] 断点续拍、回删、多段合成
* [x] 编辑添加滤镜
* [x] 编辑添加水印
* [x] 编辑添加背景音
* [x] 编辑添加贴纸、字幕
* [x] 编辑添加音效、场景
* [x] 编辑文件合成，支持VideoToolbox、libx264、H.265编码
* [x] 编辑支持视频的时间段裁剪预览
* [x] 编辑支持BGM的时间段裁剪预览
* [x] 编辑支持倍速播放预览
* [x] 合成支持输出GIF
* [x] 合成文件上传KS3
* [x] 上传后文件预览播放 
* [x] 视频画面编辑支持任意分辨率裁剪/填充模式（裁剪任意视频区间）
* [x] 多视频文件导入，任意分辨率裁剪/填充模式视频拼接

demo 下载地址：https://github.com/ksvc/KSYMediaEditorKit_iOS/releases

### 1.1 整体结构框图

![architecture](https://raw.githubusercontent.com/wiki/ksvc/KSYMediaEditorKit_iOS/images/shortVideo.png)
 
详细说明请见[wiki][wiki]

## 1.2 关于SDK费用
[KSYMediaEditorKit][KSYMediaEditorKit]是一款免费的短视频编辑SDK，录制、编辑和播放功能都免费提供，可以用于商业集成和使用。

License说明请见[wiki][license]

### 1.2.1 鉴权
短视频SDK涉及两个鉴权，区别如下：
* [SDK鉴权][SDKAuth]免费，但是是必需的
* KS3鉴权涉及费用，但是是可选择不用的

#### 1.2.1.1 SDK鉴权
使用[KSYMediaEditorKit短视频编辑SDK][KSYMediaEditorKit]前需要注册金山云帐号，SDK需要使用开发者帐号鉴权。请[在此注册][ksyun]开发者帐号。

SDK鉴权本身不会引入付费。

为了开始开发用于SDK鉴权所需要的鉴权串，提供了服务器端鉴权需要的代码。

请见[SDK鉴权说明][SDKAuth]

#### 1.2.1.2 KS3鉴权
使用[KSYMediaEditorKit短视频编辑SDK][KSYMediaEditorKit]将合成的短视频上传至[ks3][ks3]存储时，需要满足ks3的鉴权要求。

如果您的APP不使用[金山云的对象存储服务][ks3]或者使用其他家云存储提供的存储或者CDN服务，上传阶段置null即可。

如果使用[金山云对象存储][ks3]需要开通商务帐号（涉及付费业务），请直接联系金山云商务。

### 1.2.2 付费
[KSYMediaEditorKit][KSYMediaEditorKit]可以免费使用。涉及付费的包括：
* 动态贴纸（可以不集成，如果需要集成需要向第三方供应商付费）
* 云存储（可以不集成）
* 点播CDN（可以不集成）

涉及的云存储和CDN，具体费用请参考[金山云官网][ksyun]

## 二. SDK集成方法介绍   
### 2.1 系统要求 
2.1 系统要求    
* 最低支持iOS版本：iOS 8.0
* 最低支持iPhone型号：iPhone 4
* 支持CPU架构： armv7,armv7s,arm64(和i386,x86_64模拟器)
* 含有i386和x86_64模拟器版本的库文件，录制功能无法在模拟器上工作，合成、播放功能完全支持模拟器。

### 2.2 集成方式
#### 2.2.1 cocoaPods集成方式
``` objc
pod 'KSYMediaEditorKit', '~> 1.2.0.1'
pod 'Ks3SDK', '~> 1.7.2'
```

#### 2.2.2.2 从[oschina](http://git.oschina.net/ksvc/ksymediaeditorkit_ios) clone
为了加速国内访问，[oschina](http://git.oschina.net/ksvc/ksymediaeditorkit_ios)有[KSYMediaEditorKit][KSYMediaEditorKit]完整镜像，请在podfile中修改库地址
```
https://git.oschina.net/ksvc/ksymediaeditorkit_ios.git
```

### 2.3 GPUImage依赖

请参考官方cocoapods提供的[GPUImage][GPUImage]，当前我们测试通过的版本是[0.1.7][GPUImage]

### 2.4 开始运行demo工程
#### 2.4.1 使用Cocoapod的的方式来运行demo 
demo 目录中已经有一个Podfile, 指定了本地开发版的pod    
在demo目录下执行如下命令, 即可开始编译运行demo  
```
$ pod install
$ open demo.xcworkspace
```

注意:
1. 更新pod之后, 需要打开 xcwrokspace, 而不是xcodeproj


## 四. 反馈与建议
### 4.1 反馈模板  

| 类型    | 描述|
| :---: | :---:| 
|SDK名称|KSYMediaEditorKit_iOS|
|SDK版本| v1.1.0|
|设备型号| iphone7  |
|OS版本| iOS 10 |
|问题描述| 描述问题出现的现象  |
|操作描述| 描述经过如何操作出现上述问题                     |
|额外附件| 文本形式控制台log、crash报告、其他辅助信息（界面截屏或录像等） |

### 4.2 联系方式
* 主页：[金山云](http://www.ksyun.com/)
* 邮箱：<zengfanping@kingsoft.com>
* QQ讨论群：574179720 [视频云技术交流群] 
* Issues:<https://github.com/ksvc/KSYMediaEditorKit_iOS/issues>

<a href="http://www.ksyun.com/"><img src="https://raw.githubusercontent.com/wiki/ksvc/KSYLive_Android/images/logo.png" border="0" alt="金山云计算" /></a>


[ksyun]:https://v.ksyun.com
[license]:https://github.com/ksvc/KSYMediaEditorKit_iOS/wiki/license
[wiki]:https://github.com/ksvc/KSYMediaEditorKit_iOS/wiki
[KSYMediaEditorKit]:https://github.com/ksvc/KSYMediaEditorKit_iOS
[GPUImage]:https://github.com/BradLarson/GPUImage/releases/tag/0.1.7
[libksygpulive]:https://github.com/ksvc/KSYLive_iOS
[ks3]:https://www.ksyun.com/proservice/storage_service
[SDKAuth]:https://github.com/ksvc/KSYMediaEditorKit_iOS/wiki/SDKAuth
