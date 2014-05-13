//
//  EffectsControllor.h
//  EfAVWriter
//
//  Created by xi penggang on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMBufferQueue.h>
#include "effects_define.h"
#import <OpenAL/alc.h>

/*
#ifndef ADD_EFFECTS_BEGIN
#define ADD_EFFECTS_BEGIN { \
dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);\
dispatch_async(aQueue, ^{
#endif


#ifndef ADD_EFFECTS_END
#define ADD_EFFECTS_END });}
#endif
*/


//if the effect list has changed.
@protocol EffectsControlDelegate <NSObject>
@optional
- (void) EffectsChanged;
@end


@interface EffectsControllor : NSObject{
    
@protected
    id<EffectsControlDelegate> _mdelegate;
    //about effects.
    pthread_mutex_t efluck;
    AV_EF curreffects;
    AV_EF tempeffects;
    BOOL isAdding;
    AV_EF zoomeffects;
    
    //audio effects.
    AV_EF audioeffects;
    pthread_mutex_t Aefluck;
    dispatch_queue_t audioLoadingQueue;
    
    
    //audio play;
    ALCcontext* mContext;
	ALCdevice* mDevice;
	NSUInteger sourceID;
	NSUInteger bufferID;
    
    //在对象创建的时候初始化一些创建时费事的特效 在使用的时候直接拷贝过去就行了
    AV_EF mefTwirl;
    AV_EF mefPinch;
    AV_EF mefPouch;
    AV_EF mefFlash;
}

@property (readwrite, assign) id <EffectsControlDelegate> mdelegate;

- (void)processPixelBuffer: (CVImageBufferRef)pixelBuffer;
- (void)processPixelBuffer: (unsigned char*)data w:(int)width h:(int)height;
- (void)processAudioBuffer: (unsigned char*) data size:(int)nsize;
- (void)processAudioBuffer:
        (unsigned char *)data
        size:(int)nsize
        dstsize:(int*)ndstsize;

- (UIImage*)processImage:(UIImage*)image;

@end


@interface EffectsControllor(CallExtern)
/**
 @函数名：AddEffectsBegin|AddEffects: effects:|SubmitEffect
 @用法说明：1.当添加新特效链时：首先调用AddEffectsBegin
 然后调用AddEffects: effects:给新特效链上添加特效 
 最后用SubmitEffect函数使添加的特效链生效。
 2.如果没有调用AddEffectsBegin而调用AddEffects: effects:特效将被添加到当前特效链上。
 @ntype：特效种类  如：KEF_TYPE_GRAY
 @effects：特效信息指针。在添加特效时根据ntype来设置有用的值。
 **/
/*
- (int) AddEffectsBegin;
- (int) InitEffects:(AV_EF)pef effectstype:(int)ntype;
- (int) InitEffectsWithFile:(AV_EF)pef FileName:(const char*)filename;
- (int) AddEffects:(const AV_EF)pef;
- (int) AddEffects:(const AV_EF)pef Index:(int)nindex;
- (int) AddEffectsInFrontWithTag:(const AV_EF)pef Tag:(int)ntag;
- (int) AddEffectsInBackWithTag:(const AV_EF)pef Tag:(int)ntag;

- (int) SubmitEffects;
*/
//new effecte function.
//create and insert effect.
- (AV_EF) CreateEffectWithFile:(NSString*)filename;
- (AV_EF) CreateEffectWithType:(uint32_t)ntype;
- (int) AddEffect:(const AV_EF)pef;
- (int) AddEffectInFrontWithTag:(const AV_EF)pef Tag:(int)ntag;
- (int) AddEffectInBackWithTag:(const AV_EF)pef Tag:(int)ntag;

//remove and space effect.
- (int) RemoveEffectUseTag:(int)ntag;
- (int) ReplaceEffectWithTag:(const AV_EF)pef Tag:(int)ntag;

//reset effects.  重新设置特效链上的所有特效
//该函数使用size来重置一些需要对照表的特效
- (void) ResetEffectsWithSize:(CGSize)size;

/**
 @函数名：CreateSpareEffects:h:
 @作用：创建预置特效。由于扭曲等特效的创建需要比较长的时间所
 以最好是在创建对象的时候先创建出相关特效在使用的时候直接拷贝就行了。
 @width:图像宽。
 @height:图像高。
 **/
- (void) CreateSpareEffects:(int)width h:(int)height;

/**
 @函数名：GetSpareEffect：type
 @作用：获取预置特效。
 @pef ：想要被填充的特效指针。
 @ntype：特效类型
 **/
- (BOOL) GetSpareEffect:(AV_EF)pef type:(int)ntype; 


/**
 @函数名：RemoveEffectsUseType：Index
 @功能：移除当前特效链上的特效。
 @ntype：特效种类  如：KEF_TYPE_GRAY
 @nindex：特效索引值。
 **/
//- (int) RemoveEffectsUseType:(int)ntype Index:(int)nindex;
//- (int) RemoveEffectsUseTag:(int)ntag;

/**
 @函数名：SwitchFrame:Data:Index:
 @说明：该函数用来切换相框和动画效果的图片。
 @ntype：特效种类
 @Data：图片信息。本来想让只穿图片数据  但是考虑到位置和大小问题  所以只能传进来一个av_ef了。
 @Index：该参数用来表示该特效在链表中的位置。【同类特效的位置】
 **/

//- (int) SwitchValue:(const AV_EF)pef Index:(int)nindex;
//- (int) SwitchvalueUseTag:(const AV_EF)pef Tag:(int)ntag;
//- (int) ReplaceEffectsWithTag:(const AV_EF)pef Tag:(int)ntag;

/**
 @函数名：CleanEffects
 @说明：取消当前所有特效。
 **/
- (int) CleanEffects;

/**
 @函数名：SetZoomFactor
 @说明：数字调焦。
 @factor:焦距倍数  1.0-5.0
 **/
- (int) SetZoomFactor:(float)factor;

/**
 @函数名：GetZoomFactor
 @说明：获取数字焦距大小
 **/
- (float) GetZoomFactor;

/**
 @SetAudioEffectsFromCaf
 @说明：从caf文件设置音频
 @filename：文件路径。
 **/
- (int) SetAudioEffectsFromCaf:(NSString*)filename;
- (int) SetAudioEffectsFromMp4:(NSString*)filename;

//- (int) PressAVFromMp4:(NSString*)filename;
/**
 @ReStartAudioEffects
 @说明：重新开始上一个声音特效
 **/
- (int) StartAudioEffects;


/**
 @GetIndexUseTag
 @说明：通过tag值获取该特效在当前特效链里的索引值。
 **/
- (int) GetIndexUseTag:(int)tag;
@end

@interface EffectsControllor(AudioEffecte)
/**
 @SetPlayPos
 @说明：设置播放进度
 @param：pos  进度    //秒数
 @注：主要设置配音配乐特效的进度
 **/
- (void) SetPlayPos:(double)pos;

/**
 @CheckAudioEffect
 @说明：该函数主要是检测音频特效开启和关闭
 **/
- (void) CheckAudioEffect:(double)CurrTime;

/**
 @SetBackgroundPercentWithTag
 @说明：当配音/配乐等特效时设置背景音频在音频融合时的占比。
 **/
- (void) SetBackgroundPercentWithTag:(int)ntag percent:(double)per;

/**
 @SetAudioVolumeWithTag
 @说明：特效处理时设置音量的大小。现在用于声音的美化上。
 **/
- (void) SetAudioVolumeWithTag:(int)ntag volume:(float)fv;

@end


//提供了马赛克的专用设置接口。
@interface EffectsControllor(ResetEffect)

/**
 @ResetMosaicWithTag  重新设置马赛克特效。
 @param ntag    特效tag
 @param nsize   马赛克粒度。
 @param rt  马赛克区域。
 **/
- (void) ResetMosaicWithTag:(int)ntag griansize:(int)nsize mrect:(CGRect)rt;
@end



