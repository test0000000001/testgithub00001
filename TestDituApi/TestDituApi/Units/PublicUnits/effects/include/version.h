//
//  version.h
//  effectslib
//
//  Created by penggang xi on 7/7/13.
//
//

/**  ios
 3.0.19 修改项目：1.解决了关闭采集后mediaservice依然存在的问题。
 3.0.20 修改项目：1.修正照片加特效时跟预览颜色有差别问题。
                2.注意：takePictureFinish回调函数的优先级被降低了，
                    减少在照相回调里边因为操作过得多而引起的无输出图片问题。
                    如果以前在该函数中操作的界面显示问题的请添加主函数调用相关代码，
                    否则可能无法正常显示。
 3.0.21 修改项目：1.解决了iphone4有时候拍照无照片返回问题。
 3.0.22 修改项目：1.处理了一下iphone4普清拍摄的时候返回时间过程的问题，现修改到可接受范围了。
 3.0.23 修改项目：1.在编辑也快速点击录制按钮是奔溃的问题。
                2.itouch5 16g没有拍摄画面问题。
 3.0.24 修改项目：1.修改了倒计时拍照是有可能不返回照片的问题。
 3.0.25 修改项目：1.修改了高清录像模式下16：9   4：3切换时有残影的问题。
 3.0.26 修改项目：1.重新检查修改了出现残影的可能性。
                2.提供了图片缩放的函数。（解决当持续拍摄高清图片时加载到内存中的数据过大而造成在没有任何错误提示的情况下奔溃问题。）建议前端人员凡是从图片文件加载的图像都用该函数，或者类似方法处理。
 3.0.27 修改项目：1.修改了当图片转方向时图像压缩质量过大导致图片占用空间太多的问题。
 3.0.28 修改项目：1.提供了获取文件总时间的接口。
 3.0.28 修改项目：1.提供了获取文件总时间的接口。
                2.添加了点击屏幕对焦功能
 3.0.29 修改项目：1.修改了来电拒接后不打开摄像头的bug。
                2.添加了简单的对焦动画。
 3.0.30 修改项目：1.修改了播放器背景。
                2.修改了5.1.1返回日记页后进入拍摄页面图像不动的问题。
 3.0.31 修改项目：1.修改了bug 5139  bug 5177  二次加特效保存成文件后画面有问题的bug。
 3.0.32 修改项目：1.修改了bug 4068  uiimage旋转方向函数改变色值序的问题。
 3.0.33 修改项目：1.修改了bug 5146 第一次进客户端是打开摄像头比较费时的问题。
 3.0.34 修改项目：1.修改了bug 3785 不停暂停时出现未知错误的问题。
 3.0.35 修改项目：1.修改了bug 5203 iphone4 暂停的问题。
 **/


#ifndef effectslib_version_h
#define effectslib_version_h

#if(defined(ANDROID))
static const char lib_effect_version[] = "3.0.2";
#endif

#if(!TARGET_IPHONE_SIMULATOR)
#if(TARGET_IPHONE_SIMULATOR | TARGET_OS_IPHONE)
static const char lib_effect_version[] = "3.0.35";
#endif

static const int showversion = 0;
#endif
#endif
