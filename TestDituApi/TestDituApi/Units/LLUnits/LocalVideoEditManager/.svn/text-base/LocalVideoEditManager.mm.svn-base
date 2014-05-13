//
//  LocalVideoEditManager.m
//  VideoShare
//
//  Created by xu dongsheng on 13-3-29.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LocalVideoEditManager.h"
#import "Global.h"
#import "DebugLog.h"
#import "UIViewAdditions.h"

#import "XAVPlayer.h"
#import "EfAVWriter.h"
#import "EffectsControllor.h"
#import "ToolsUnite.h"
#import "mp4box.h"
#import <AVFoundation/AVFoundation.h>


#define FRAME_COUNT_SAVED 5
#define DEFAULT_MOSAIC_FRAME_WIDTH 100
#define DEFAULT_MOSAIC_FRAME_HEIGHT 100

@implementation LocalVideoEditManager
@synthesize mavplayer=_mavplayer;
@synthesize previewModel=_previewModel;
@synthesize playUrl=_playUrl;
@synthesize effectDic=_effectDic;

+ (LocalVideoEditManager*) LocalVideoEditManagerForAvPlayer:(XAVPlayer *)mavplayer playUrl:(NSString*)playUrl{
    LocalVideoEditManager* lvm = [[LocalVideoEditManager alloc]init];
    lvm ->_playUrl = playUrl;
    if(mavplayer){//音视频的
        lvm ->_mavplayer = mavplayer;
    }else{//图片
        lvm->_imageToAddEffect = [UIImage imageWithContentsOfFile:playUrl];
    }
    return lvm;
}

-(void)setEditingImage:(UIImage*)imageEditing{
    self.imageToAddEffect = imageEditing;
}

-(void)getPreviewFromeVideoAsyn:(void (^)(void))getPreviewSuccessBlock
{
    #if !(TARGET_IPHONE_SIMULATOR)
    if(!_previewModel){
       self.previewModel = [[PreviewData alloc]init];
       if ([[NSFileManager defaultManager]fileExistsAtPath:self.playUrl]) {
                    double dt = [_mavplayer gettotaltime]/FRAME_COUNT_SAVED;
                    for (double i=0; i<FRAME_COUNT_SAVED; i++){
                        double timePos = i*dt;
                       // UIImage* image = [_mavplayer getImageFromMediaWithTime:timePos];
                        UIImage *coverImage= [_mavplayer getImageFromMediaWithTime:timePos];
                       // UIImage* image  = [ToolsUnite ChangeImageDirection:coverImage];
                        UIImage* image = coverImage;
                        if(image)
                        {
                            PreviewCell* cell = [_previewModel.list objectAtIndex:i];
                            cell.videoimage = image;
                        }
                    }
                   getPreviewSuccessBlock();
            }
    } else{
       getPreviewSuccessBlock();
    }
#endif
    }

#pragma mark - videoCut methods
+(BOOL)videoCutByStartEnd:(NSString*) sourceVideoPath savedVideoPath:(NSString*) savedVideoPath start:(float)start end:(float)end{
    if([@"" isEqualToString:UN_NIL(sourceVideoPath)] || [@"" isEqualToString:UN_NIL(savedVideoPath)]){
        return NO;
    }
#if !(TARGET_IPHONE_SIMULATOR)   
   XIF_RET result =  ifx_split([sourceVideoPath UTF8String], [savedVideoPath UTF8String], start, end);
    if(result == ISO_FILE_OK){
        return YES;
    }else{
        return NO;
    }
#endif
    return NO;
}

#pragma mark - videoCut methods
+(BOOL)videoCutByChoosedDeleteStartEnd:(NSString*) sourceVideoPath savedVideoPath:(NSString*) savedVideoPath deleteStart:(float)deleteStart deleteEnd:(float)deleteEnd
     videoDuration:(float)videoDuration{
#if !(TARGET_IPHONE_SIMULATOR)
    if([@"" isEqualToString:UN_NIL(sourceVideoPath)] || [@"" isEqualToString:UN_NIL(savedVideoPath)]){
        return NO;
    }
    NSString* firstPartOutfile=[[[sourceVideoPath stringByDeletingPathExtension]stringByAppendingFormat:@"_1"]stringByAppendingPathExtension:[sourceVideoPath pathExtension]];
    NSString* secondPartOutfile=[[[sourceVideoPath stringByDeletingPathExtension]stringByAppendingFormat:@"_2"]stringByAppendingPathExtension:[sourceVideoPath pathExtension]];
    
     XIF_RET firstPartCutResult =  ifx_split([sourceVideoPath UTF8String], [firstPartOutfile UTF8String], 0, deleteStart);
    if(firstPartCutResult == ISO_FILE_OK){
        XIF_RET secondPartCutResult =  ifx_split([sourceVideoPath UTF8String], [secondPartOutfile UTF8String], deleteEnd, videoDuration);
        if(secondPartCutResult == ISO_FILE_OK){
            isoFile *outFile = ifx_open([savedVideoPath UTF8String]);
           //对视频进行合并
            XIF_RET videoPartAppendFirstPartResult =  ifx_append(outFile, [firstPartOutfile UTF8String]);
            XIF_RET videoPartAppendSecondPartResult =  ifx_append(outFile, [secondPartOutfile UTF8String]);
            ifx_stop(outFile);
            //删除临时文件
            if ([[NSFileManager defaultManager ]fileExistsAtPath:firstPartOutfile]) {
                [[NSFileManager defaultManager] removeItemAtPath:firstPartOutfile error:nil];
            }
            
            if ([[NSFileManager defaultManager ]fileExistsAtPath:secondPartOutfile]) {
                [[NSFileManager defaultManager] removeItemAtPath:secondPartOutfile error:nil];
            }
            if(videoPartAppendFirstPartResult == ISO_FILE_OK && videoPartAppendSecondPartResult == ISO_FILE_OK){
                return YES;
            }else{
                return NO;
            }
        }
    }
#endif
    return NO;
}

- (void)startAddEffectsAndSaveToMp4:(NSString*)inFile Out:(NSString*)OutFile{
    #if !(TARGET_IPHONE_SIMULATOR) 
    [_mavplayer StartAddEffectsAndSaveToMp4:inFile Out:OutFile];
    #endif
}

- (UIImage*)addEffectsToImage:(NSString*)name
{
UIImage *imageHasAddEffect = nil;
#if !(TARGET_IPHONE_SIMULATOR)
    int tag = 0;
    for (NSString* key in [_effectDic allKeys]) {
        NSString* value = [_effectDic objectForKey:key];
        if ([value isEqualToString:name]) {
            tag = [key intValue];
        }
    }
    EffectsControllor* tEffects = [[EffectsControllor alloc] init];
    if(![name isEqualToString:@"正常"])
    {
        // ”左右折叠特效跟上下折叠特效“ 90度  跟270的视频特效是正确的。   0度跟180度是反的。
        if([@"左右折叠" isEqualToString:name] || [@"上下折叠" isEqualToString: name]){
            if(self.imageToAddEffect.imageOrientation == UIImageOrientationUp || self.imageToAddEffect.imageOrientation == UIImageOrientationDown){
                if([@"左右折叠" isEqualToString: name]){
                  name = @"上下折叠";
                }else{
                  name = @"左右折叠";
                }
            }
        }
        NSString* resourcePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],[name stringByAppendingPathExtension:@"cfg"]];
        if (tEffects) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
                //define effect object.
                //clean all effects in the list.
                [tEffects CleanEffects];
                AV_EF tef = [tEffects CreateEffectWithFile:resourcePath];
                tef->ntag = 0;
                tef->tablerect.width = self.imageToAddEffect.size.width;
                tef->tablerect.height = self.imageToAddEffect.size.height;
                
                if(self.imageToAddEffect.imageOrientation == UIImageOrientationRight
                   || self.imageToAddEffect.imageOrientation == UIImageOrientationLeft){   //90
                    tef->tablerect.width += tef->tablerect.height;
                    tef->tablerect.height = tef->tablerect.width - tef->tablerect.height;
                    tef->tablerect.width = tef->tablerect.width - tef->tablerect.height;
                }
                
                [tEffects AddEffect:tef];
                
                //process image.
                imageHasAddEffect = [tEffects processImage:self.imageToAddEffect];
            }
        }
    }
    else
    {
        //[tEffects RemoveEffectsUseTag:0];
    }
#endif
   return imageHasAddEffect;
}

- (UIImage*)addEffectsToImage:(UIImage*)imageToAddEffect effectName:(NSString*)effectName
{
UIImage *imageHasAddEffect = imageToAddEffect;
#if !(TARGET_IPHONE_SIMULATOR)
    int tag = 0;
    for (NSString* key in [_effectDic allKeys]) {
        NSString* value = [_effectDic objectForKey:key];
        if ([value isEqualToString:effectName]) {
            tag = [key intValue];
        }
    }
    EffectsControllor* tEffects = [[EffectsControllor alloc] init];
    if(![effectName isEqualToString:@"正常"])
    {
        NSString* resourcePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],[effectName stringByAppendingPathExtension:@"cfg"]];
        if (tEffects) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
                //define effect object.
                //clean all effects in the list.
                [tEffects CleanEffects];
                AV_EF tef = [tEffects CreateEffectWithFile:resourcePath];
                tef->ntag = 0;
                tef->tablerect.width = imageToAddEffect.size.width;
                tef->tablerect.height = imageToAddEffect.size.height;
                
                if(imageToAddEffect.imageOrientation == UIImageOrientationRight
                   || imageToAddEffect.imageOrientation == UIImageOrientationLeft){   //90
                    tef->tablerect.width += tef->tablerect.height;
                    tef->tablerect.height = tef->tablerect.width - tef->tablerect.height;
                    tef->tablerect.width = tef->tablerect.width - tef->tablerect.height;
                }
                
                [tEffects AddEffect:tef];
                
                //process image.
                imageHasAddEffect = [tEffects processImage:imageToAddEffect];
            }
        }
    }
    else
    {
        //[tEffects RemoveEffectsUseTag:0];
    }
#endif
 return imageHasAddEffect;
}

-(void)addSoundBackground:(NSString*)name{
#if !(TARGET_IPHONE_SIMULATOR)
    if(![name isEqualToString:@"原声"]){
        NSString* strrfileName = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
        tagVEFFECTSSETS* p = [self.mavplayer.meffectscontroller CreateEffectWithType:KEF_TYPE_ADD_MUSIC];
        //memcpy(p->efstream.filename, [strrfileName UTF8String], strrfileName.length);
        sprintf(p->efstream.filename, "%s", [strrfileName UTF8String]);
        p->efstream.Channels = self.mavplayer.getchannel;
        p->efstream.BitsPerChannel = self.mavplayer.getbitsperchannel;
        p->efstream.SampleRate = self.mavplayer.getsamplerote;
        p->efstream.percent = 0.5;
        p->ntag = SOUND_BACKGROUND_EFFECT_LEVEL;
        if ([_mavplayer.meffectscontroller GetIndexUseTag:SOUND_BACKGROUND_EFFECT_LEVEL] > -1)
        {
            [_mavplayer.meffectscontroller ReplaceEffectWithTag:p Tag:SOUND_BACKGROUND_EFFECT_LEVEL];
        }else
        {
           [self.mavplayer.meffectscontroller AddEffect:p];
        }
    } else
    {
        [_mavplayer.meffectscontroller RemoveEffectUseTag:SOUND_BACKGROUND_EFFECT_LEVEL];
    }

#endif
}

- (void)changeSoundBackgroundSonndPercent:(double)soundPercent{
    [self.mavplayer.meffectscontroller SetBackgroundPercentWithTag:SOUND_BACKGROUND_EFFECT_LEVEL percent:soundPercent];
}

- (void)changeEffects_type:(NSString*)name
{
#if !(TARGET_IPHONE_SIMULATOR)
    int tag = 0;
    EffectsControllor* p = _mavplayer.meffectscontroller;
    if (!p) {
        NSLog(@"the effects controllor is null...");
        return;
    }
    for (NSString* key in [_effectDic allKeys]) {
        NSString* value = [_effectDic objectForKey:key];
        if ([value isEqualToString:name]) {
            tag = [key intValue];
        }
    }
    if(![name isEqualToString:@"正常"])
    {
        
        // ”左右折叠特效跟上下折叠特效“ 90度  跟270的视频特效是正确的。   0度跟180度是反的。
        if([@"左右折叠" isEqualToString:name] || [@"上下折叠" isEqualToString: name]){
            if(self.imageToAddEffect.imageOrientation == UIImageOrientationUp || self.imageToAddEffect.imageOrientation == UIImageOrientationDown){
                if([@"左右折叠" isEqualToString: name]){
                    name = @"上下折叠";
                }else{
                    name = @"左右折叠";
                }
            }
        }
        
        NSString* resourcePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],[name stringByAppendingPathExtension:@"cfg"]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
                
                //define effect object.
                
                AV_EF tef = [p CreateEffectWithFile:resourcePath];
                if (tef) {
                    tef->ntag = VIDEO_OR_PIC_EFFECT_LEVEL;

                    tef->tablerect.width = [_mavplayer getwidth];
                    tef->tablerect.height = [_mavplayer getheight];
                    
                    if ([p GetIndexUseTag:VIDEO_OR_PIC_EFFECT_LEVEL] > -1)
                    {
                        [p ReplaceEffectWithTag:tef Tag:VIDEO_OR_PIC_EFFECT_LEVEL];
                    }else
                    {
                        //[_mavplayer.meffectscontroller AddEffectsInFrontWithTag:&tef Tag:1];
                        [p AddEffect:tef];
                    }
                }

            }
    }
    else
    {
        [p RemoveEffectUseTag:VIDEO_OR_PIC_EFFECT_LEVEL];
    }
#endif
}

-(void)addEffectDicObject:(NSString*)name
{
    [_effectDic setObject:name forKey:[NSString stringWithFormat:@"%d",[[_effectDic allKeys] count]]];
}

-(void)addSoundBackgroundDicObject:(NSString*)name
{
    [self.soundBackgroundDic setObject:name forKey:[NSString stringWithFormat:@"%d",[[self.soundBackgroundDic allKeys] count]]];
}

-(void)addSoundBeautifyEffectDicObject:(NSString*)name
{
    [self.soundBeautifyEffectDic setObject:name forKey:[NSString stringWithFormat:@"%d",[[self.soundBeautifyEffectDic allKeys] count]]];
}


-(void)initEffectDic
{
    self.effectDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    [self addEffectDicObject:@"正常"];
    [self addEffectDicObject:@"漫画"];
    [self addEffectDicObject:@"旧报纸"];
    [self addEffectDicObject:@"水彩画"];
    [self addEffectDicObject:@"黑白"];
    [self addEffectDicObject:@"彩色底板"];
    [self addEffectDicObject:@"淡雅光"];
    [self addEffectDicObject:@"怀旧系"];
    [self addEffectDicObject:@"哥特风"];
    [self addEffectDicObject:@"萌葱"];
    [self addEffectDicObject:@"暮色悠然"];
    [self addEffectDicObject:@"瑟瑟金风"];
    [self addEffectDicObject:@"视丹如绿"];
    [self addEffectDicObject:@"绿荫素素"];
    [self addEffectDicObject:@"炫紫迷情"];
    [self addEffectDicObject:@"凸镜"];
    [self addEffectDicObject:@"凹镜"];
    [self addEffectDicObject:@"扭曲"];
    [self addEffectDicObject:@"时光隧道"];
    [self addEffectDicObject:@"上下折叠"];
    [self addEffectDicObject:@"左右折叠"];
}

-(void)initSoundBackgroundDic
{
    self.soundBackgroundDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    [self addSoundBackgroundDicObject:@"迪曲"];
    [self addSoundBackgroundDicObject:@"电子"];
    [self addSoundBackgroundDicObject:@"电子钢琴"];
    [self addSoundBackgroundDicObject:@"抒情钢琴"];
}

-(void)initSoundBeautifyEffectDic
{
    self.soundBeautifyEffectDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    [self addSoundBeautifyEffectDicObject:@"低频"];
    [self addSoundBeautifyEffectDicObject:@"汤姆猫"];
}

@end
