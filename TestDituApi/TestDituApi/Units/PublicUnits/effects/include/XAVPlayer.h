//
//  XAVPlayerManager.h
//  EfAVWriter
//
//  Created by xi penggang on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#import "XPlayerDelegate.h"
#import "EffectsControllor.h"

@class XSourcePlayer;
@class XAVPlayerViewController;
@class ffmediawriter;
@class AudioRecodeController;

@interface XAVPlayer : NSObject
                            <XPlayDelegate,
                            ffmediawriterDelegate,
                            PlayControlDelegate,
                            EffectsControlDelegate>
{
    //about video show.
    XAVPlayerViewController         *mplayviewcontroller;
    //about play file .
    XSourcePlayer                   *mplayer;
    //about effects.
    EffectsControllor               *meffectscontroller;
    //playcallback
    id<XAVPlayerManagerDelegate>    delegate;
    //to write file.
    ffmediawriter                   *mffwriter;
    BOOL                            mwriteing;
    
    //EffectManager
    double                          _mDubStartTime;          //配音开始时间。
    NSString                        *_mDubFile;   //配音数据保存文件。
    AudioRecodeController           *_mDubAudioRecoder;
    
    //full screem.
    BOOL                            _mFullScreem;
    CGRect                          _mRtNormal;
}

@property (readwrite, assign) id<XAVPlayerManagerDelegate> delegate;
@property (nonatomic, retain) XAVPlayerViewController *mplayviewcontroller;
@property (nonatomic, retain) XSourcePlayer *mplayer;
@property (nonatomic, retain) EffectsControllor *meffectscontroller;
@property (nonatomic, retain) ffmediawriter *mffwriter;

//full screem.
@property (readwrite, getter = isFullScreem) BOOL mFullScreem;
@property (readwrite) CGRect mRtNormal;

- (id) initWithConfig:(NSString*)cfgfile;


@end


//视频播放相关
@interface XAVPlayer(videoshow)
- (void)SetViewRect:(CGRect)rt Animation:(BOOL)bA;

- (UIView*)GetGlView;
- (void)SetVideoFull:(int)ntype;

//show currment video to view
- (void)ShowCurrVideo;
@end

//播放相关控制操作。
@interface XAVPlayer(playercontrollor)

//play control functions.
- (int)open:(NSString*)filename;
- (void)play;
- (void)stop;
- (void)pause;
- (void)seek:(double)pos;
- (void)seekwithper:(float)fper;

- (IBAction)playbtnevent:(id)sender;

@end

//播放界面元素相关控制操作。
@interface XAVPlayer(playerUIelement)
//hide the player control component。
- (void)HideCtlView:(BOOL)bHide;

//设置play backgroud。
- (void) setPlayBackgroud:(UIImage*)image;
- (void) setPlayBackgroudHidden;

//change play control.
- (void)SetCtrlElementView:(UIView*)elementview Tag:(en_element_tag)etag;
- (UIView*)GetCtrlElementViewWhithTag:(en_element_tag)etag;
@end

//播放时获取媒体的相关信息
@interface XAVPlayer(getmediainfo)
//get medio info.
- (int)getplaystatus;

- (double)gettotaltime;
- (double)gettcurrtime;
//video
- (int)getwidth;
- (int)getheight;

- (int)getvideodirection;

- (UIImage*)getImageFromMediaWithTime:(double)pos;


//audio
- (int)getchannel;
- (int)getsamplerote;
- (int)getbitsperchannel;
@end


//特效管理相关操作
//manage the effect.
@interface XAVPlayer(EffectManager)
//初始化特效
//有些特效需要根据视频方向来调整一下
- (int) InitEffects:(AV_EF)pef effectstype:(int)ntype;

//配音特效相关
/**
 @名称：Dub_Start
 @功能：配音操作开始。
 @注：该函数将记录开始配音时间  以及打开录音模块开始录音。
 **/
- (void) Dub_Start;                                 //开始配音
/**
 @名称：Dub_End
 @功能：配音结束。
 @参数ntag：该参数为该配音特效的唯一标识，主要用来删除等操作的。
 @参数pst：配音所占比例
 @注：该函数将结束配音操作。1.结束录音。2.添加配乐特效给特效列表。
 **/
- (void) Dub_End:(int)ntag persent:(double)pst;                                

@end


@interface XAVPlayer(filewriter)

- (void)StartAddEffectsAndSaveToMp4:(NSString*)inFile Out:(NSString*)OutFile;
- (void)StopSaveToMp4;
//- (void)StartAddEffectsAndSaveToMp4:(NSString*)OutFile;
@end

