//
//  LocalVideoEditManager.h
//  VideoShare
//
//  Created by xu dongsheng on 13-3-29.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreviewData.h"
#import "MediaPlayer/MediaPlayer.h"
#import "SPUserResizableView.h"
#import "XPlayerDelegate.h"

//特效层级定义
typedef enum
{
   VIDEO_OR_PIC_EFFECT_LEVEL,//视频画面特效，图片特效层级
   SOUND_BACKGROUND_EFFECT_LEVEL,//配乐特效层级
   SOUND_BEAUTIFY_EFFECT_LEVEL  //美化声音特效层级
} EFFECT_LEVEL;

@class XAVPlayer;

@interface LocalVideoEditManager : NSObject<XAVPlayerManagerDelegate, SPUserResizableViewDelegate>{
    float _mosaicFrameWidth;
    float _mosaicFrameHeight;
}

@property (strong, nonatomic) NSString *playUrl;
@property(nonatomic,strong)PreviewData* previewModel;
@property(nonatomic,strong)XAVPlayer *mavplayer;
@property(nonatomic,strong)UIImage *imageToAddEffect;
@property(nonatomic,strong)NSMutableDictionary* effectDic;
@property(nonatomic,strong)NSMutableDictionary* soundBackgroundDic;
@property(nonatomic,strong)NSMutableDictionary* soundBeautifyEffectDic;

/** Creates and returns a new instance with the specified configuration. */
+ (LocalVideoEditManager*) LocalVideoEditManagerForAvPlayer:(XAVPlayer *)mavplayer playUrl:(NSString*)playUrl;

-(void)initEffectDic;
-(void)initSoundBackgroundDic;
-(void)initSoundBeautifyEffectDic;

-(void)getPreviewFromeVideoAsyn:(void (^)(void))getPreviewSuccessBlock;
+ (BOOL) videoCutByStartEnd:(NSString*) sourceVideoPath savedVideoPath:(NSString*) savedVideoPath start:(float)start end:(float)end;

+(BOOL)videoCutByChoosedDeleteStartEnd:(NSString*) sourceVideoPath savedVideoPath:(NSString*) savedVideoPath deleteStart:(float)deleteStart deleteEnd:(float)deleteEnd
                         videoDuration:(float)videoDuration;
//仅当图片编辑时候有效
-(void)setEditingImage:(UIImage*)imageEditing;

//特效保存
- (void)startAddEffectsAndSaveToMp4:(NSString*)inFile Out:(NSString*)OutFile;
//增加视频音频特效
- (void)changeEffects_type:(NSString*)name;
//增加图片特效，用于图片编辑时候加特效
- (UIImage*)addEffectsToImage:(NSString*)name;

//给指定图片加特效（工具方法）
- (UIImage*)addEffectsToImage:(UIImage*)imageToAddEffect effectName:(NSString*)effectName;
//配乐
-(void)addSoundBackground:(NSString*)name;

//更改配乐音量
- (void)changeSoundBackgroundSonndPercent:(double)soundPercent;
@end
