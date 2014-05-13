

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMBufferQueue.h>
#include "effects_define.h"
#import <OpenAL/alc.h>

#include "mp4box.h"
#import "PhotoEngine.h"

#define WRITE_SMALL_FILE
//#define WRITE_BIG_FILE

//#define USE_ADAPTOR_WRITE
//#define ADD_VIDEO_ADAPT

#define MIN_FRAMEDURATION 30
#define MAX_FRAMEDURATION 30

#define MIN_FRAMEDURATION_COMMON 15
#define MAX_FRAMEDURATION_COMMON 15

//#define USE_FACE_RECO           //人脸识别开关
//#define REMOVE_BK               //取消背景


enum en_CamaraDefinition{
    DEF_HEIGHT = 0,     //高清录像
    DEF_COMMON,         //普清录像
    DEF_PHOTO,          //高清照相
    DEF_PHOTO_COMMON    //普清照相
};

typedef enum {
    v_show_modle_unknow = 0,
    v_show_modle_16p9,      //不普满屏等比例显示。
    v_show_modle_4p3        //铺满屏等比例显示。
}en_VideoShowModle;


/*
#define ADD_EFFECTS_BEGIN { \
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);\
    dispatch_async(aQueue, ^{

#define ADD_EFFECTS_END });}\
*/

//error define.
//由于不想多加一个头文件  所以错误代码就先定义到这个地方。

@class EffectsControllor;

@protocol RosyWriterVideoProcessorDelegate;

@interface RosyWriterVideoProcessor : NSObject <
                AVCaptureAudioDataOutputSampleBufferDelegate,
                AVCaptureVideoDataOutputSampleBufferDelegate,
                PhotoEngineDelegate>
{  
    id <RosyWriterVideoProcessorDelegate> delegate;
	
	NSMutableArray *previousSecondTimestamps;
	Float64 videoFrameRate;
	CMVideoDimensions videoDimensions;
	CMVideoCodecType videoType;

	AVCaptureSession *captureSession;
	AVCaptureConnection *audioConnection;
	AVCaptureConnection *videoConnection;
	CMBufferQueueRef previewBufferQueue;
    
    AVCaptureDevice *VideoDevice;
    AVCaptureDeviceInput *videoInput;
    AVCaptureVideoDataOutput *videooutput;
    AVCaptureAudioDataOutput *audiooutput;
	
	NSURL *movieURL;
	AVAssetWriter *assetWriter;
	AVAssetWriterInput *assetWriterAudioIn;
	AVAssetWriterInput *assetWriterVideoIn;
	dispatch_queue_t movieWritingQueue;
    int startAngleOffset;
#ifdef USE_ADAPTOR_WRITE 
    AVAssetWriterInputPixelBufferAdaptor *smallAdaptor;
#endif    
    
	AVCaptureVideoOrientation referenceOrientation;
	AVCaptureVideoOrientation videoOrientation;
    AVCaptureVideoOrientation recodeReferenceOrientation;
    
	// Only accessed on movie writing queue
    BOOL readyToRecordAudio; 
    BOOL readyToRecordVideo;
	BOOL recordingWillBeStarted;
	BOOL recordingWillBeStopped;

	BOOL recording;
    
    BOOL mbupload;
#ifdef WRITE_BIG_FILE   
    //to write big file.
    NSURL *bigmovieURL;
	AVAssetWriter *bigassetWriter;
	AVAssetWriterInput *bigassetWriterAudioIn;
	AVAssetWriterInput *bigassetWriterVideoIn;
	dispatch_queue_t bigmovieWritingQueue;
    //big file write.
    BOOL bigreadyToRecordAudio; 
    BOOL bigreadyToRecordVideo;
	BOOL bigrecordingWillBeStarted;
	BOOL bigrecordingWillBeStopped;
    BOOL bigrecording;
#ifdef USE_ADAPTOR_WRITE    
    AVAssetWriterInputPixelBufferAdaptor *bigAdaptor;
#endif
#endif
    
#ifdef USE_FACE_RECO
    //Face recognition
    CIDetector *faceDetector;
    BOOL isUsingFrontFacingCamera;
    NSArray *FeatureList;
    BOOL detecting;
    
    //test face recognition...
    AV_EF   faceeffects;
    unsigned char* imagedata;
    int faceimagewidth;
    int faceimageheight;
    NSArray *tFeatureList;
    //********
#endif
    
#ifdef REMOVE_BK
    BOOL SuctionRGBing;
    BOOL UseRemovBK;
    CGPoint SuctionPt;
    RGBAOGJ RGBSuctioned;
#endif
    
@protected    
    //about effects.
    pthread_mutex_t efluck;
    AV_EF curreffects;
    AV_EF tempeffects;
    BOOL isAdding;
    AV_EF zoomeffects;
    bool effectwork;
    //以后的特效操作都用该对象来实现。
    EffectsControllor  *_meffectscontroller;
    
    
    //audio effects.
    AV_EF audioeffects;
    pthread_mutex_t Aefluck;
    dispatch_queue_t audioLoadingQueue;
    //d
    ALCcontext* mContext;
	ALCdevice* mDevice;
	NSUInteger sourceID;
	NSUInteger bufferID;
    
    //write small file.
    NSString *strDate;
    NSString *_strPath;
    uint32_t fileinterval;
    long     lasttime;
    int filenum;
    
    //merge small file.
    isoFile* misoFile;
    
    
    //witch savetoCameraRoll.
    BOOL _mSaveCameraRoll;
    
    //witch restart recode.
    BOOL _mbReStartRecode;
    
    //vitch come to back.
    BOOL _mbComeToBack;
    
    //make photo.
    PhotoEngine* _mPhotoEngine;
}

@property (readwrite, assign) id <RosyWriterVideoProcessorDelegate> delegate;

@property (readonly) Float64 videoFrameRate;
@property (readonly) CMVideoDimensions videoDimensions;
@property (readonly) CMVideoCodecType videoType;

@property (nonatomic, retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic, retain) AVCaptureSession *captureSession;

@property (nonatomic, retain) NSURL *movieURL;
@property (nonatomic, retain) NSString *strDate;
@property (nonatomic, retain) NSString *strPath;

@property (nonatomic, readwrite) uint32_t fileinterval;

@property (readwrite, getter = effectIsWork) bool effectwork;

@property (nonatomic, retain) EffectsControllor *meffectscontroller;


#ifdef WRITE_BIG_FILE
@property (nonatomic, retain) NSURL *bigmovieURL;
#ifdef USE_ADAPTOR_WRITE 
@property (nonatomic, retain) AVAssetWriterInputPixelBufferAdaptor *bigAdaptor;
#endif
#endif

#ifdef USE_ADAPTOR_WRITE
@property (nonatomic, retain) AVAssetWriterInputPixelBufferAdaptor *smallAdaptor;
#endif

@property (readwrite) AVCaptureVideoOrientation referenceOrientation;
@property (readwrite) AVCaptureVideoOrientation recodeReferenceOrientation;

//about face.
@property (nonatomic, retain) NSArray *FeatureList;



@property (readwrite) BOOL SaveCameraRoll;

@property (readwrite) BOOL mbComeToBack;

@property (nonatomic, retain) PhotoEngine* mPhotoEngine;

@property (readonly) int mCamaraDefinition;

@property (nonatomic,assign) id deviceConnectedObserver;
@property (nonatomic,assign) id deviceDisconnectedObserver;

- (CGAffineTransform)transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)orientation;

- (void)showError:(NSError *)error title:(NSString*)str;

- (void) setupAndStartCaptureSession;
- (void) stopAndTearDownCaptureSession;

- (void) setSessionDefinition:(int)def;


//set video show modle.
- (void) setVideoShowModle:(en_VideoShowModle)nmodle;
- (en_VideoShowModle) getVideoShowModle;

- (BOOL) captureSessionIsRun;

- (AVCaptureVideoPreviewLayer*) getPreviewLayer;

- (void) startRecording;
- (void) startRecording:(BOOL)bupload fileID:(NSString*)sID;
- (void) startRecording:(BOOL)bupload fileID:(NSString *)sID filePath:(NSString*) path;
- (void) pauseRecode;       //暂停写入文件
- (void) resumeRecode;      //恢复暂停
- (void) stopRecording;
- (void) stopRecordingForRestart;   //当需要重新拍摄时使用，将会不拷贝视频到本地相册里边了。
- (void) takePicture:(NSString*)filepath;


- (BOOL) isPaused;

- (void) pauseCaptureSession; // Pausing while a recording is in progress will cause the recording to be stopped and saved.
- (void) resumeCaptureSession;

- (void)swapFrontAndBackCameras;
- (int)getCameraPosition;           //-1:error  1:front  2:back
- (BOOL)setTorch;
- (BOOL)haseTorch;

//对焦
- (void)setFocusPoint:(CGPoint)point preview:(UIView*)previewView;

- (BOOL)isRecodingSmallOrBig;

/**
 名称：getCurrVideoAngle
 功能：获取当前视频旋转角度。
 **/
- (int)getCurrVideoAngle;

@property(readonly, getter=isRecording) BOOL recording;

@end


@interface RosyWriterVideoProcessor(effects)

- (void) CurrEffectsLock;
- (void) CurrEffectsUnlock;

/**
 @函数名：AddEffectsBegin|AddEffects: effects:|SubmitEffect
 @用法说明：1.当添加新特效链时：首先调用AddEffectsBegin
            然后调用AddEffects: effects:给新特效链上添加特效 
            最后用SubmitEffect函数使添加的特效链生效。
          2.如果没有调用AddEffectsBegin而调用AddEffects: effects:特效将被添加到当前特效链上。
 @ntype：特效种类  如：KEF_TYPE_GRAY
 @effects：特效信息指针。在添加特效时根据ntype来设置有用的值。
 **/

- (int) AddEffectsBegin;
- (int) InitEffects:(AV_EF)pef effectstype:(int)ntype;
- (int) InitEffectsWithFile:(AV_EF)pef FileName:(const char*)filename;
- (int) AddEffects:(const AV_EF)pef;
- (int) AddEffects:(const AV_EF)pef Index:(int)nindex;
- (int) AddEffectsInFrontWithTag:(const AV_EF)pef Tag:(int)ntag;
- (int) AddEffectsInBackWithTag:(const AV_EF)pef Tag:(int)ntag;

- (int) SubmitEffects;

/**
 @函数名：RemoveEffectsUseType：Index
 @功能：移除当前特效链上的特效。
 @ntype：特效种类  如：KEF_TYPE_GRAY
 @nindex：特效索引值。
 **/
- (int) RemoveEffectsUseType:(int)ntype Index:(int)nindex;
- (int) RemoveEffectsUseTag:(int)ntag;

/**
 @函数名：SwitchFrame:Data:Index:
 @说明：该函数用来切换相框和动画效果的图片。
 @ntype：特效种类
 @Data：图片信息。本来想让只穿图片数据  但是考虑到位置和大小问题  所以只能传进来一个av_ef了。
 @Index：该参数用来表示该特效在链表中的位置。【同类特效的位置】
 **/

- (int) SwitchValue:(const AV_EF)pef Index:(int)nindex;
- (int) SwitchvalueUseTag:(const AV_EF)pef Tag:(int)ntag;
- (int) ReplaceEffectsWithTag:(const AV_EF)pef Tag:(int)ntag;

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

- (int) PressAVFromMp4:(NSString*)filename;
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



#ifdef REMOVE_BK
//吸取颜色用吸取的颜色删除背景
- (void) SuctionColorWithPoint:(const CGPoint &)pt;
- (void) StopRemovBk;
#endif


@end




@protocol RosyWriterVideoProcessorDelegate <NSObject>
@required
- (void)pixelBufferReadyForDisplay:(CVPixelBufferRef)pixelBuffer;	// This method is always called on the main thread.
//about media file make.
- (void)recordingWillStart;
- (void)recordingDidStart;
- (void)recordingWillStop;
- (void)recordingDidStop;

//about open camera.
- (void)captureSessionStopped:(BOOL)isComeBack;
- (void)captureSessionDidStart:(BOOL)isComeBack;

//if pause successed callback.
- (void)recordingDidPause;

- (void)SmallFileFinish:(NSString*) filename Time:(NSString*)strTime RotaAngle:(int)angle;
- (void)BigFileFinsh:(NSString*) filename Time:(NSString*)strTime RotaAngle:(int)angle;

- (void)SubmitFinish;

//swapFrontAndBackCameras callback
- (void)DidSwapFrontCameras;
- (void)DidSwapBackCameras;

//about photo mode。
- (void)UseDefaultPreview;
- (void)UseGLPreview;
- (void)SetDefaultPreview;

//set Definition done.
- (void)SetDefinitionFinish:(int)currDefi;

//for commonly take picture.
- (void)takePictureFinish:(NSString*)filepath;
- (void)takePictureFailed;

//for set Focus Point.
- (void) captureManagerDeviceConfigurationChanged:(RosyWriterVideoProcessor *)VideoProcessor;
- (void) focusModeDidChange:(AVCaptureFocusMode)nMode;
@end
