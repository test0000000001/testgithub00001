//
//  XVideoWriterManager.h
//  EfAVWriter
//
//  Created by xi penggang on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "RosyWriterVideoProcessor.h"
#import "VideoPreviewController.h"

@interface XVideoWriterManager : NSObject<RosyWriterVideoProcessorDelegate,
                                        PhotoEngineDelegate,
                                    VideoPreviewControllerDelegate>
{
    id <RosyWriterVideoProcessorDelegate> delegate;
    RosyWriterVideoProcessor *videoProcessor;
    VideoPreviewController* _mpreviewController;
    
    BOOL _mbDraw;
}

@property (readwrite, assign) id <RosyWriterVideoProcessorDelegate> delegate;

@property (nonatomic, retain) RosyWriterVideoProcessor *videoProcessor;
@property (nonatomic, retain) VideoPreviewController* mpreviewController;
@property (readwrite) BOOL mbDraw;


- (id)initWithProcessorDelegate:(id)idelegate;
//- (id)initWithProcessorDelegateAndFrame:(id)idelegate Frame:(CGRect)rt;

- (void)SetViewRect:(CGRect)rt;

- (void)StartRecodeVidoe:(UIView*)parent;


@end


@interface XVideoWriterManager(CarmaraCtl)
//camare.
//the new function for open and close camare.
- (void)OpenCamara:(UIView*)parent;
- (void)CloseCamara;
- (BOOL)CamaraIsRun;

//set preset.
- (void)SetCamaraDefinition:(int)def;
- (int)GetCamaraDefinition;

//set video show modle.
- (void)setVideoShowModle:(en_VideoShowModle)nmodle general:(BOOL)isgeneral;
- (en_VideoShowModle)getVideoShowModle;

//set camara position.
- (void)swapFrontAndBackCameras;
- (int)getCameraPosition;           //-1:error  1:front  2:back
//set camara torch.
- (BOOL)setTorch;
- (BOOL)haseTorch;

//get currment video size.
- (CGSize)GetCurrVideoSize;

- (void)SetFocusPoint:(CGPoint)point;
@end

@interface XVideoWriterManager(MakeMediaFile)
//make media file.
//the new function for recode/stop/pause write media file.
//start/stop.
- (void) startRecording:(BOOL)bupload fileID:(NSString*)sID;
- (void) startRecording:(BOOL)bupload fileID:(NSString *)sID filePath:(NSString*) path;
- (void) stopRecording;
- (void) stopRecordingForRestart;   //当需要重新拍摄时使用，将会不拷贝视频到本地相册里边了。
- (BOOL) isRecording;

//pause/recove.
- (void) pauseRecode;       //暂停写入文件
- (void) recoveRecode;      //恢复暂停
- (BOOL) isPause;
@end



@interface XVideoWriterManager(takePicture)

- (void)takePicture:(NSString*)filepath;
- (void)takePicturePanoramic:(NSString*)filepath;

@end


@interface XVideoWriterManager(UIElementCtl)

- (void)setAccelermeter:(BOOL)bshow;
- (void)setGrid:(BOOL)bshow;
- (BOOL)isAccelermeter;
- (BOOL)isGrid;

@end

