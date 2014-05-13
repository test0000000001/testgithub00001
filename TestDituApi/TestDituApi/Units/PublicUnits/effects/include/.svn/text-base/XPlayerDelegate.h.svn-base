//
//  XPlayerDelegate.h
//  EfAVWriter
//
//  Created by xi penggang on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef EfAVWriter_XPlayerDelegate_h
#define EfAVWriter_XPlayerDelegate_h

enum play_status
{
    STATUS_OPENED = 0,
    STATUS_PALYING,
    STATUS_STOP,
    STATUS_PAUSE,
};

typedef enum {
    TAG_PROGRESS_BAR = 1000,        //进度条
    TAG_BTN_START,                  //播放按钮
    TAG_BTN_PAUSE,                  //暂停按钮
    TAG_BTN_FULL,                   //全屏按钮
    TAG_BTN_NORMAL,                 //退出全屏按钮
    TAG_LABLE_PROGRESS              //进度文本显示
}en_element_tag;

@protocol XPlayDelegate<NSObject>

@optional
- (void) VideoDataReady:(CVPixelBufferRef)pixelBuffer;
- (void) AudioDataReady:(unsigned char*)data Size:(int)nsize;
- (void) AudioDataReady:(unsigned char *)data Size:(int)nsize dstSize:(int*)ndst;

//- (void) VideoWrite:(CVPixelBufferRef)pixelBuffer;
//- (void) AudioWrite:(unsigned char*)data Size:(int)nsize;

- (void) PlayerFinish;
- (void) PlayerDoingCurrTime:(double)currtime;

//save media.
//- (void) SaveingCurrTime:(double)currtime;

@end

@protocol ffmediawriterDelegate <NSObject>

@optional


- (void) VideoWrite:(CVPixelBufferRef)pixelBuffer;
- (void) VideoWrite:(unsigned char*)data Width:(int)nwidth Height:(int)nheight;
- (void) AudioWrite:(unsigned char*)data Size:(int)nsize;

- (void) SaveingCurrTime:(double)currtime;
- (void) SaveFinish;

@end

@protocol ImageIndexsDelegate <NSObject>

@optional

- (void) IndexedImage:(UIImage*)image;

@end




@protocol XAVPlayerManagerDelegate <NSObject>

@optional
//aboute media play.
- (void) PlayerFinish;
- (void) PlayerDoingCurrTime:(double)currtime;

//about play control.
- (void) RectChanged;

//aboute media write.
- (void) WriteFinish:(id)player;
- (void) SaveingCurrTime:(double)currtime owner:(id)player;
//use test.
- (void) SaveingCurrData:(unsigned char*)data width:(int)nwidth height:(int)nheight;
@end


//播放时控制按钮所用的相关协议
@protocol PlayControlDelegate <NSObject>

@optional
//暂停
- (bool) Pause;
//播放
- (void) Play;
//跳转
- (void) Seek:(double)percent;

//全屏
- (void) toFull;
//普通
- (void) toNormal;

@end


#endif
