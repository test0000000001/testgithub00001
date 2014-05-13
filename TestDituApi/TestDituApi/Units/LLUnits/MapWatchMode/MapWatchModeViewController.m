//
//  MapWatchModeViewController.m
//  VideoShare
//
//  Created by xu dongsheng on 13-6-8.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "MapWatchModeViewController.h"
#import "MapWatchModeModel.h"
#import "VPPMapHelper.h"
#import "MKMapView+ZoomLevel.h"
#import "SpaceCollectionViewCell.h"
#import "Tools.h"
#import "ImageCacheManager.h"

#define TileInitialTag    10000
#define kDuration 1  // 动画持续时间(秒)


@interface MapWatchModeViewController ()

@property (nonatomic, strong) MapWatchModeModel* mapWatchModeModel;
@property(nonatomic, strong) VPPMapHelper *mh;
@property(nonatomic, strong) NSMutableArray *mapAnnotations;
@property(nonatomic,strong)  NSMutableArray *diarysArray;//要播放的日记数组
@property(nonatomic, assign) int timerCount;
@property(nonatomic, assign) int footMoveCounter;
@property(nonatomic, assign) int originZoomLevel;
@property(nonatomic, assign) int nextDiaryIndexToPlay;
@property(nonatomic, strong) NSMutableArray *locationCoordinateArray;
@property(nonatomic, assign) double lineK; //两个经纬度之间的斜率
@property(nonatomic, assign) BOOL isCurDiaryScreenXBigger;
@property(nonatomic, assign) BOOL isCurDiaryScreenYBigger;
@property(nonatomic, strong) NSTimer *changeMapSizeAlphaTimer;
@property(nonatomic, strong) NSTimer *footMoveTimer;
@property(nonatomic, strong) NSArray *soundRecordViewImages;
@property(nonatomic, strong) NSArray *locPinImages;
@property(nonatomic, strong) DiaryData *preDiary; //前一条日记
@property(nonatomic, strong) DiaryData *curDiary;//当前播放的日记
@property(nonatomic, assign) double xDt;
@property(nonatomic, assign) float footScreenX;//小脚丫在屏幕的x坐标
@property(nonatomic, assign) float footScreenY;//小脚丫在屏幕的Y坐标
@property(nonatomic, strong) UIImageView *footImageView;//小脚丫
@property(nonatomic, strong) UIImageView *fullScreenImageView;//主附件为图片时候,全屏imageView
@property(nonatomic, strong) JohnClockView* johnClockView;//钟表控件

@property(nonatomic, assign) BOOL isCurDiaryPlayStop;//是否停止播放当前日记
@property(nonatomic, assign) BOOL moveToNextPosFinish;

@property(nonatomic, strong) UIView *netVideoPlayerView;

//附件
@property(nonatomic, strong) NSMutableArray *attachs;

@property(nonatomic, assign) CELL_DISPLAY_STYLE diaryStyle;

@end

@implementation MapWatchModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _diarysArray = [NSMutableArray new];
        self.mapWatchModeModel = [[MapWatchModeModel alloc]init];
        self.locationCoordinateArray = [NSMutableArray new];
        self.isCurDiaryScreenXBigger = NO;
        self.isCurDiaryScreenYBigger = NO;
        self.soundRecordViewImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"3_shengyin1"],[UIImage imageNamed:@"3_shengyin2"],[UIImage imageNamed:@"3_shengyin3"], nil];
        self.locPinImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"3_diliweizhiicon1"],[UIImage imageNamed:@"3_diliweizhiicon2"],[UIImage imageNamed:@"3_diliweizhiicon3"], nil];
        
        self.audioView.hidden = YES;
        self.videoView.hidden = YES;
        self.textDescView.hidden = YES;
        self.soundRecordView.hidden = YES;
        self.isCurDiaryPlayStop = NO;
        self.diaryPosView.hidden = YES;
    }
    return self;
}

-(void)addDiaryArray:(NSMutableArray *)diarysArray startIndexToPlay:(int)startIndexToPlay{
    self.startIndexToPlay = startIndexToPlay;
    if(self.diarysArray && [self.diarysArray count] > 0){
        [self.diarysArray removeAllObjects];
    }
    if(diarysArray && [diarysArray count] > 0){
        int firstValidDiaryIndex = -1;
        //进行过滤去掉没有经纬度的
        for(int i = 0; i < [diarysArray count]; i++){
            DiaryData *diaryData = [diarysArray objectAtIndex:i];
            if([Tools locationIsValid:diaryData.d_latitude longitudeStr:diaryData.d_longitude]){
                [self.diarysArray addObject:diaryData];
                if(firstValidDiaryIndex == -1){
                    firstValidDiaryIndex = i;
                }
            }else{
                if(i == self.startIndexToPlay){//忽略当前开始播放索引
                    if(self.startIndexToPlay < [diarysArray count] - 1){
                        self.startIndexToPlay = self.startIndexToPlay + 1;
                    }else{
                        if(firstValidDiaryIndex != -1){
                            self.startIndexToPlay = firstValidDiaryIndex;
                        }
                    }
                }
            }
        }
        if(self.startIndexToPlay == startIndexToPlay){
            DiaryData* startDiary = [diarysArray objectAtIndex:startIndexToPlay];
            self.startIndexToPlay = [self.diarysArray indexOfObject:startDiary];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //全屏显示
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    // 状态栏动画持续时间
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    // 基础动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    // 修改状态栏的方向及view的方向进而强制旋转屏幕
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    self.navigationController.view.transform = CGAffineTransformIdentity;
    self.navigationController.view.transform = CGAffineTransformMakeRotation( - M_PI / 2);
    self.navigationController.view.bounds = CGRectMake(self.navigationController.view.bounds.origin.x, self.navigationController.view.bounds.origin.y, self.navigationController.view.width, self.navigationController.view.height);
    NSLog(@"%f",self.navigationController.view.width);
    [UIView commitAnimations];
    if(self.diarysArray && [self.diarysArray count] > 0){
        self.nextDiaryIndexToPlay = self.startIndexToPlay + 1;
        self.curDiary = [self.diarysArray objectAtIndex:self.startIndexToPlay];
        [self initViews];
        
        //判断日记类型,确定展示形式，展示完成后，去展示下一个日记
        [self addMapAnnotationByDiary:self.curDiary];
        [self updateViewByDiaryStyle:self.curDiary];
    }else{
        self.userHeadView.hidden = YES;
        self.diaryPosView.hidden = YES;
    }
//    [self.mapWatchModeModel getDiaryArrayByUserid:@"" mainBlock:^(NSMutableArray *diaryArray) {
//        [self.diarysArray addObjectsFromArray:diaryArray];
//        self.nextDiaryIndexToPlay = 1;
//        self.curDiary = [self.diarysArray objectAtIndex:0];
//        //判断日记类型,确定展示形式，展示完成后，去展示下一个日记
//        [self addMapAnnotationByDiary:self.curDiary];
//        [self updateViewByDiaryStyle:self.curDiary];
//    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //输出口释放

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self releaseLastPlayDiaryResource];
    [self.audioPlayer stop];
}


//3秒钟后，全屏播放视频
-(void)fullscreenPlayVideo:(DiaryData*)diaryData{
    [self updateNetVideoPlayerByVideoUrl:[Tools parseVideoPlayUrl:diaryData attachLevel:1]];
    self.bottomControlBar.hidden = YES;
    //[self.view bringSubviewToFront:self.bottomControlBar];
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.clockView];
    [self.view bringSubviewToFront:self.diaryPosView];
    
    [self changeViewOriginByNewXY:self.userHeadView coorX:4 coorY:204];
    if(self.diaryStyle == VIDEO_HAS_ONE_AUXILIARY_VOICE_ATTACH){//有：主附件，语音辅附件
       [self changeViewOriginByNewXY:self.soundRecordView coorX:self.userHeadView.right + 4 coorY:self.userHeadView.top];
    }else if(self.diaryStyle == VIDEO_HAS_ONE_AUXILIARY_WORDS_ATTACH){  //有：主附件，文字辅附件
        [self changeViewOriginByNewXY:self.textDescView coorX:self.userHeadView.right + 4 coorY:self.userHeadView.top];
        [self.textDescLabel setText:[Tools parseTextDescByAttachLevel:diaryData attachLevel:0]];
    }else if(self.diaryStyle == VIDEO_HAS_TWO_AUXILIARY_ATTACH){//有：主附件，语音辅附件，文字辅附件
        [self changeViewOriginByNewXY:self.soundRecordView coorX:self.userHeadView.right + 4 coorY:self.userHeadView.top];
        [self changeViewOriginByNewXY:self.textDescView coorX:self.soundRecordView.right + 4 coorY:self.soundRecordView.top];
        [self.textDescLabel setText:[Tools parseTextDescByAttachLevel:diaryData attachLevel:0]];
    }
}

-(void)fullscreenSeeImage:(DiaryData*)diaryData{
    
    NSString *imageUrl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
    [self resetFullScreenImageView:imageUrl];
    
    //[self.view bringSubviewToFront:self.bottomControlBar];
    self.bottomControlBar.hidden = YES;
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.clockView];
    [self.view bringSubviewToFront:self.diaryPosView];
    
    if(self.diaryStyle == IMAGE_HAS_ONE_AUXILIARY_VOICE_ATTACH){//有：主附件，语音辅附件      
    [self changeViewOriginByNewXY:self.userHeadView coorX:self.view.left + 20 coorY:self.bottomControlBar.top - self.userHeadView.height];
    [self changeViewOriginByNewXY:self.soundRecordView coorX:self.view.left + 35  coorY:self.userHeadView.bottom];
    
    }else if(self.diaryStyle == IMAGE_HAS_ONE_AUXILIARY_WORDS_ATTACH){//有：主附件，文字辅附件
        [self changeViewOriginByNewXY:self.userHeadView coorX:self.view.left + 20 coorY:self.bottomControlBar.top - self.userHeadView.height];
        [self changeViewOriginByNewXY:self.textDescView coorX:self.view.left + 15  coorY:self.userHeadView.bottom + 3];
    
    }else if(self.diaryStyle == IMAGE_HAS_TWO_AUXILIARY_ATTACH){//有：主附件，语音辅附件，文字辅附件
        [self changeViewOriginByNewXY:self.userHeadView coorX:self.view.left + 20 coorY:self.bottomControlBar.top - self.userHeadView.height];
        [self changeViewOriginByNewXY:self.textDescView coorX:self.userHeadView.right + 2  coorY:self.userHeadView.top];
        [self changeViewOriginByNewXY:self.soundRecordView
                                coorX:self.userHeadView.center.x  coorY:self.userHeadView.bottom];
    
    }
    //播放完视频后播放下一条日记
    [self performSelector:@selector(toPlayNextDiary:) withObject:[NSNumber numberWithInt:self.nextDiaryIndexToPlay] afterDelay:3.0];
}

//当日记的主附件是”视频“时，更新视频视图
-(void)updateVideoView:(DiaryData*)diaryData{
    self.videoView.hidden = NO;
    self.textDescView.hidden = YES;
    self.userHeadView.hidden = YES;
    self.audioView.hidden = YES;
    self.soundRecordView.hidden = YES;
    self.imageAttachView.hidden = YES;
    
    
    [self.videoCoverImageView setImage:[UIImage imageNamed:@"3_tankuang_moren"]];
    NSString *imageUrl = [Tools parseVideoCover:diaryData];
    if (![imageUrl isEqualToString:@""] && !STR_IS_NIL(imageUrl)) {
        if ([imageUrl hasPrefix:@"http://"]) {
            [ImageCacheManager setImageToImage:imageUrl imageView:self.videoCoverImageView];
        } else {
            [self.videoCoverImageView setImage:[UIImage imageWithContentsOfFile:imageUrl]];
        }
    }
    self.attachs = diaryData.d_attachsArray;
    NSString* videoShootTime =  [Tools dateFormat:VIDEO_SHOOT_TIME_FORMAT timeMilli:[NSNumber numberWithDouble:[diaryData.d_diarytimemilli doubleValue]]];
    [self.videoShootTime setText:videoShootTime];
    [self performSelector:@selector(fullscreenPlayVideo:) withObject:diaryData afterDelay:3.0];
}

-(void)resetFullScreenImageView:(NSString*)imageUrl{
    if(!self.fullScreenImageView){
        self.fullScreenImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        
        [self.fullScreenImageView setImage:[UIImage imageNamed:@"3_tankuang_moren"]];
        if (![imageUrl isEqualToString:@""] && !STR_IS_NIL(imageUrl)) {
            if ([imageUrl hasPrefix:@"http://"]) {
                [ImageCacheManager setImageToImage:imageUrl imageView:self.fullScreenImageView];
            } else {
                [self.fullScreenImageView setImage:[UIImage imageWithContentsOfFile:imageUrl]];
            }
        }
        [self.view addSubview:self.fullScreenImageView];
    }else{
        self.fullScreenImageView.hidden = NO;
       [ImageCacheManager setImageToImage:imageUrl imageView:self.fullScreenImageView];
    }
}

-(void)updateImageAttachView:(DiaryData*)diaryData{
    self.userHeadView.hidden = YES;
    self.audioView.hidden = YES;
    self.videoView.hidden = YES;
    self.textDescView.hidden = YES;
    self.soundRecordView.hidden = YES;
    self.imageAttachView.hidden = NO;
    
    [self.imageView setImage:[UIImage imageNamed:@"3_tankuang_moren"]];
    NSString *imageUrl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
    if (![imageUrl isEqualToString:@""] && !STR_IS_NIL(imageUrl)) {
        if ([imageUrl hasPrefix:@"http://"]) {
            [ImageCacheManager setImageToImage:imageUrl imageView:self.imageView];
        } else {
            [self.imageView setImage:[UIImage imageWithContentsOfFile:imageUrl]];
        }
    }
    self.attachs = diaryData.d_attachsArray;
    NSString* imageShootTime =  [Tools dateFormat:VIDEO_SHOOT_TIME_FORMAT timeMilli:[NSNumber numberWithDouble:[diaryData.d_diarytimemilli doubleValue]]];
    [self.imageShootTime setText:imageShootTime];
    
    [self performSelector:@selector(fullscreenSeeImage:) withObject:diaryData afterDelay:3.0];
}

-(void)setAudioPlayerUrlAndPlay:(NSString*)audioPlayerUrl{
    [self.audioPlayer setURL:[Tools convertUrlStrToNSURL:audioPlayerUrl]];
    [self.audioPlayer play];
}

-(void)changeViewOriginByNewXY:(UIView*)view coorX:(CGFloat)coorX coorY:(CGFloat)coorY{
    if(view.hidden){
        view.hidden = NO;
    }
    UIView* viewParent = [view superview];
    [viewParent bringSubviewToFront:view];
    
    CGRect frame = view.frame;
    frame.origin.x = coorX;
    frame.origin.y = coorY;
    view.frame = frame;
}

-(void)setUserHeadViewCenterInScreen{
  [self changeViewOriginByNewXY:self.userHeadView coorX:(self.navigationController.view.height - 56)/2 + 4 coorY:(self.view.height - 66)/2 - 30];
}

-(void)updateViewByDiaryStyle:(DiaryData*)diaryData{
    self.diaryStyle = [Tools getCollentionDiaryDisplayStyle:diaryData];
    switch (self.diaryStyle) {
        case VIDEO_NO_AUXILIARY_ATTACH:   //只有主附件，没有辅附件
        {
            [self updateVideoView:diaryData];
            break;
        }
        case VIDEO_HAS_ONE_AUXILIARY_VOICE_ATTACH://有：主附件，语音辅附件
        { 
            [self updateVideoView:diaryData];
            self.soundRecordView.hidden = NO;
            NSURL *voiceFileUrl =  [Tools convertUrlStrToNSURL:[Tools parsingAudioUrlByAttachLevel:diaryData attachLevel:1]];
            [self.soundRecordVoiceBtn setVoiceURL:voiceFileUrl];
            
            break;
        }   
        case VIDEO_HAS_ONE_AUXILIARY_WORDS_ATTACH: //有：主附件，文字辅附件
        {
            [self updateVideoView:diaryData];
            break;
        }
        case VIDEO_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
        {
            [self updateVideoView:diaryData];
            break;
        }
        case AUDIO_NO_AUXILIARY_ATTACH://只有主附件，没有辅附件
        {
            self.userHeadView.hidden = NO;
            self.audioView.hidden = NO;
            self.videoView.hidden = YES;
            self.textDescView.hidden = YES;
            self.soundRecordView.hidden = YES;
            self.imageAttachView.hidden = YES;
            
            [self setUserHeadViewCenterInScreen];
            [self setAudioPlayerUrlAndPlay:[Tools parsingAudioUrlByAttachLevel:diaryData attachLevel:1]];
            [self changeViewOriginByNewXY:self.audioView coorX:self.userHeadView.left coorY:self.userHeadView.bottom + 5];
            
            break;
        }
        case AUDIO_NO_MAIN_ATTACH://无主附件，有两个辅附件
        {
            self.userHeadView.hidden = NO;
            self.audioView.hidden = YES;
            self.videoView.hidden = YES;
            self.textDescView.hidden = NO;
            self.soundRecordView.hidden = NO;
            self.imageAttachView.hidden = YES;
            
            [self setUserHeadViewCenterInScreen];
            
            [self changeViewOriginByNewXY:self.soundRecordView coorX:self.userHeadView.left - 15 coorY:self.userHeadView.bottom + 4];
            
            [self changeViewOriginByNewXY:self.textDescView coorX:self.soundRecordView.left - 5 -self.textDescView.width coorY:self.soundRecordView.top];
            
            NSURL *voiceFileUrl =  [Tools convertUrlStrToNSURL:[Tools parsingAudioUrlByAttachLevel:diaryData attachLevel:0]];
            [self.soundRecordVoiceBtn setVoiceURL:voiceFileUrl];
            [self.textDescLabel setText:[Tools parseTextDescByAttachLevel:diaryData attachLevel:0]];
            break;
        }
        case AUDIO_HAS_ONE_AUXILIARY_WORDS_ATTACH://有：主附件，文字辅附件
        {
            self.userHeadView.hidden = NO;
            self.audioView.hidden = NO;
            self.videoView.hidden = YES;
            self.textDescView.hidden = YES;
            self.soundRecordView.hidden = YES;
            self.imageAttachView.hidden = YES;
            
            [self setUserHeadViewCenterInScreen];
            [self setAudioPlayerUrlAndPlay:[Tools parsingAudioUrlByAttachLevel:diaryData attachLevel:1]];
            
            [self changeViewOriginByNewXY:self.audioView coorX:self.userHeadView.left coorY:self.userHeadView.bottom + 5];
            
            [self changeViewOriginByNewXY:self.textDescView coorX:self.userHeadView.left - 5 -self.textDescView.width coorY:self.userHeadView.top];
            [self.textDescLabel setText:[Tools parseTextDescByAttachLevel:diaryData attachLevel:0]];
            
            break;
        }
        case AUDIO_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
            
        {
            self.userHeadView.hidden = NO;
            self.audioView.hidden = NO;
            self.videoView.hidden = YES;
            self.textDescView.hidden = NO;
            self.soundRecordView.hidden = NO;
            self.imageAttachView.hidden = YES;
            
            [self setUserHeadViewCenterInScreen];
            [self setAudioPlayerUrlAndPlay:[Tools parsingAudioUrlByAttachLevel:diaryData attachLevel:1]];
            
            [self changeViewOriginByNewXY:self.audioView coorX:self.userHeadView.origin.x - 5 - self.audioView.width coorY:self.userHeadView.origin.y + 9];
            
            [self changeViewOriginByNewXY:self.soundRecordView coorX:self.userHeadView.left - 5 coorY:self.userHeadView.bottom + 4];
            
            [self changeViewOriginByNewXY:self.textDescView coorX:self.soundRecordView.left - 5- self.textDescView.width coorY:self.soundRecordView.top];
            NSURL *voiceFileUrl =  [Tools convertUrlStrToNSURL:[Tools parsingAudioUrlByAttachLevel:diaryData attachLevel:0]];
            [self.soundRecordVoiceBtn setVoiceURL:voiceFileUrl];
            [self.textDescLabel setText:[Tools parseTextDescByAttachLevel:diaryData attachLevel:0]];
            break;
        }
            
        case IMAGE_NO_AUXILIARY_ATTACH://只有主附件，没有辅附件
        {
          
            [self updateImageAttachView:diaryData];
            break;
        }
            
        case IMAGE_HAS_ONE_AUXILIARY_VOICE_ATTACH://有：主附件，语音辅附件
        {
            
            [self updateImageAttachView:diaryData];
            break;
        }
            
        case IMAGE_HAS_ONE_AUXILIARY_WORDS_ATTACH://有：主附件，文字辅附件
            
        {
            [self updateImageAttachView:diaryData];
            break;
        }
            
        case IMAGE_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
            
        {
            [self updateImageAttachView:diaryData];
            break;
        }
        
        case AUXILIARY_ATTACH_WORDS: //只有文字
        {
            self.userHeadView.hidden = NO;
            self.audioView.hidden = YES;
            self.videoView.hidden = YES;
            self.textDescView.hidden = NO;
            self.soundRecordView.hidden = YES;
            self.imageAttachView.hidden = YES;
            [self setUserHeadViewCenterInScreen];
            [self changeViewOriginByNewXY:self.textDescView coorX:self.userHeadView.left - 5 - self.textDescView.width coorY:self.userHeadView.top];
            
            break;
        }
            
        case AUXILIARY_ATTACH_VOICE: //只有语音
            
        {
            self.userHeadView.hidden = NO;
            self.audioView.hidden = YES;
            self.videoView.hidden = YES;
            self.textDescView.hidden = YES;
            self.soundRecordView.hidden = NO;
            self.imageAttachView.hidden = YES;
            [self setUserHeadViewCenterInScreen];
            NSURL *voiceFileUrl =  [Tools convertUrlStrToNSURL:[Tools parsingAudioUrlByAttachLevel:diaryData attachLevel:0]];
            [self.soundRecordVoiceBtn setVoiceURL:voiceFileUrl];
            [self changeViewOriginByNewXY:self.soundRecordView coorX:self.userHeadView.left - 10 coorY:self.userHeadView.bottom + 2];
            
            break;
        }
            
        case AUXILIARY_ATTACH_WORDS_AND_VOICE:
            
        {
            self.userHeadView.hidden = NO;
            self.audioView.hidden = YES;
            self.videoView.hidden = YES;
            self.textDescView.hidden = NO;
            self.soundRecordView.hidden = NO;
            self.imageAttachView.hidden = YES;
            [self setUserHeadViewCenterInScreen];
            [self changeViewOriginByNewXY:self.soundRecordView coorX:self.userHeadView.left - 10 coorY:self.userHeadView.bottom];
            [self changeViewOriginByNewXY:self.textDescView coorX:self.soundRecordView.left - 5 - self.textDescView.width coorY:self.soundRecordView.top];
            
            NSURL *voiceFileUrl =  [Tools convertUrlStrToNSURL:[Tools parsingAudioUrlByAttachLevel:diaryData attachLevel:0]];
            [self.soundRecordVoiceBtn setVoiceURL:voiceFileUrl];
            break;
        }
            
        default:
            break;
    }

}

- (MKCoordinateRegion) regionAccordingToCenterAndOneBorderLocation:(CLLocationCoordinate2D)mapCenter mapBorderLocation:(CLLocationCoordinate2D)mapBorderLocation{
  MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
  region.center.latitude = mapCenter.latitude;
  region.center.longitude = mapCenter.longitude;
  CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:mapCenter.latitude longitude:mapCenter.longitude];
  CLLocation *borderLocation = [[CLLocation alloc] initWithLatitude:mapBorderLocation.latitude longitude:mapBorderLocation.longitude];
  CLLocationDistance dist = [borderLocation distanceFromLocation:centerLocation];
  region.span.latitudeDelta = dist / 111319.5 * 1.2; // magic number !! :) 1.2
  region.span.longitudeDelta = 0.0;
  return region;
}

- (MKCoordinateRegion) regionAccordingToCenterLocation:(CLLocationCoordinate2D)mapCenter {
    return [self regionAccordingToCenterLocation:mapCenter latitudeDelta:1.2];
}

- (MKCoordinateRegion) regionAccordingToCenterLocation:(CLLocationCoordinate2D)mapCenter latitudeDelta:(CLLocationDegrees)latitudeDelta{
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = mapCenter.latitude;
    region.center.longitude = mapCenter.longitude;
    if(latitudeDelta < 0){
        region.span.latitudeDelta = 1.2; // magic number !! :) 1.2
    }else{
        region.span.latitudeDelta = latitudeDelta; // magic number !! :) 1.2
    }
    region.span.longitudeDelta = 0.0;
    return region;
}

-(void)playViewTransiAnimis:(UIView*)targetView isFromLeft:(BOOL)isFromLeft{
    CGRect targetViewFrame = targetView.frame;
    if(isFromLeft){
        targetView.frame = CGRectMake(0 - targetView.right, targetView.top, targetView.width, targetView.height);
        [UIView animateWithDuration:kDuration
                         animations:^{
                             targetView.frame = CGRectMake(targetViewFrame.origin.x, targetViewFrame.origin.y, targetView.width, targetView.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }else{
        targetView.frame = CGRectMake(self.view.width + targetView.width, targetView.top, targetView.width, targetView.height);
        [UIView animateWithDuration:kDuration
                         animations:^{
                             targetView.frame = CGRectMake(targetViewFrame.origin.x, targetViewFrame.origin.y, targetView.width, targetView.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];
    
    }

}

-(void)playStartAnim:(NSString*)posToShow{
     CGAffineTransform originTransform = CGAffineTransformMakeScale(0, 0);
    [self.userHeadView setTransform:originTransform];
    [UIView animateWithDuration:kDuration animations:^{
        CGAffineTransform newTransform = CGAffineTransformMakeScale(1.0, 1.0);
        [self.userHeadView setTransform:newTransform];
    }
   completion:^(BOOL finished){
        self.diaryPosView.hidden = NO;
        self.clockView.hidden = NO;
        self.locationLabel.text = posToShow;
        [self playViewTransiAnimis:self.diaryPosView isFromLeft:NO];
        [Tools setImageViewCombineAnimation:self.locPinImageView iamges:self.locPinImages animationDuration:3.0 animationRepeatCount:1];
        [self playViewTransiAnimis:self.clockView isFromLeft:YES];
    }];
}

-(void)addMapAnnotationByDiary:(DiaryData*)diaryData{
    if(!STR_IS_NIL(diaryData.d_latitude) && !STR_IS_NIL(diaryData.d_longitude)){
    CLLocationCoordinate2D centerLocation =   CLLocationCoordinate2DMake([diaryData.d_latitude doubleValue], [diaryData.d_longitude doubleValue]);
    [self.mapView setRegion:[self regionAccordingToCenterLocation:centerLocation] animated:YES];
     //头像慢慢出现，时间闹钟从昨边平移出来，位置从左边平移过来
    [self playStartAnim:diaryData.d_position];
    }
}

-(void)initViews{
    NSDate *diaryDate = [NSDate dateWithTimeIntervalSince1970:[self.curDiary.d_diarytimemilli doubleValue]/1000];
    self.johnClockView = [[JohnClockView alloc]initWithFrame:self.clockView.bounds withType:CLOCK_TYPE_DIARY initialDate:diaryDate];
    [self.clockView addSubview:self.johnClockView];
    [self initMapViewProperties];
    
    self.userHeadView.frame = CGRectMake((self.navigationController.view.height - 56)/2 + 4,(self.view.height - 66)/2 - 30,56,66);
    self.userHeadImageView.clipsToBounds = YES;
    self.userHeadImageView.layer.cornerRadius = 22.0f;
    if(STR_IS_NIL(self.curDiary.d_headimageurl)){
        [self.userHeadImageView setImage:[UIImage imageNamed:@"3_tankuang_moren"]];
    }else{
        [ImageCacheManager setImageToImage:self.curDiary.d_headimageurl imageView:self.userHeadImageView];
    }
    NSURL *voiceFileUrl = [NSURL URLWithString:[Tools parsingAudioUrlByAttachLevel:nil attachLevel:1]];
    self.soundRecordVoiceBtn = [[JohnVoiceButton alloc] initWithFrame:self.soundRecordView.bounds withDuration:0 voiceURL:voiceFileUrl withType:VOICE_BUTTON_FOR_EDIT_PAGE];
    [self.soundRecordView addSubview:self.soundRecordVoiceBtn];
    
    self.audioPlayer = [[MiniPlayer alloc]initWithDelegate:self];
    self.audioPlayer.frame = self.audioView.bounds;
    [self.audioView addSubview:self.audioPlayer];
    
    self.videoView.frame = CGRectMake((self.navigationController.view.height - 61)/2 + 4,(self.view.height - 60)/2 - 30,61,60);
    self.diaryPosView.hidden = YES;
    self.clockView.hidden = YES;
}

//初始化系统播放器，能播放网络视频
-(void)updateNetVideoPlayerByVideoUrl:(NSString*)videoUrl{
    NSURL *URL=nil;
    if ([videoUrl rangeOfString:@"http://"].location!=NSNotFound||[videoUrl rangeOfString:@"https://"].location!=NSNotFound)
    {
        URL = [NSURL URLWithString:videoUrl];
    }
    else {
        URL = [NSURL fileURLWithPath:videoUrl];
    }
    if(!self.netVideoPlayerView){
        self.netVideoPlayerView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.netVideoPlayerView.userInteractionEnabled = YES;
        self.videoPlayer = [[JohnMoviePlayer alloc] initWithFrame:self.netVideoPlayerView.bounds withContentURL:URL withAutoPlay:YES];
        self.videoPlayer.delegate = self;
        [self.netVideoPlayerView addSubview: self.videoPlayer];
        [self.videoPlayer startPlaying];
        [self.view addSubview:self.netVideoPlayerView];
    }else{
        [self.videoPlayer setContentURL:URL];
        [self.videoPlayer startPlaying];
    }
    self.netVideoPlayerView.hidden = NO;
}

// 播放状态改变了
// 如果你是多个控件共用一个player来播放可能多个媒体文件，那么应使用通知。如果你是一个控件单独持有一个播放器，应用代理方式。
#pragma mark JohnMoviePlayerDelegate methods
- (void)johnMoviePlayer:(JohnMoviePlayer *)player didChangeStateTo:(JOHN_MOVIE_STATE)state{
    switch (state) {
        case JOHN_MOVIE_STATE_FINISHED:
            //播放完视频后播放下一条日记
            [self performSelector:@selector(toPlayNextDiary:) withObject:[NSNumber numberWithInt:self.nextDiaryIndexToPlay] afterDelay:0];
            break;
            
        default:
            break;
    }
}

-(void)initMapViewProperties{
    self.timerCount = 0;
    self.footMoveCounter = 0;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    //self.mapView.alpha = 0.4;
    self.mapView.userInteractionEnabled = YES;
}

-(void)doMapAnima{
   // int animOriginZoomlevel = (self.originZoomLevel - 4 > 1) ? (self.originZoomLevel - 4) : 1;
   // [self.mapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:animOriginZoomlevel animated:YES];
    
    //地图视野慢慢拉近，透明度改变，然后用户头像浮出，钟表，位置视图出现
//    [UIView beginAnimations:@"changeMapViewAlpha" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:3.0];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(onMapAlphaChangeFinish)];
//    self.mapView.alpha = 1.0;
//    [UIView commitAnimations];
  //  self.diaryPosView.hidden = YES;
  //  [self toPlayNextDiary:self.nextDiaryIndexToPlay];
   // self.timerCount = 1;
    //self.changeMapSizeAlphaTimer = [NSTimer scheduledTimerWithTimeInterval:(0.2) target:self selector:@selector(onChangeMapZoomlevelTimerWhenEnter) userInfo:nil repeats:YES];

    //播放第二条日记时，地图渐渐远去，透明度改变，然后小脚丫走路
    

    
    /*从第一个日记视野动画变为第二个日记的视野，
     1.先算出两个地图中心点的直线距离d
     2.让小脚丫在指定的时间内动画移动d，地图的中心点也在指定时间内移动d，人头像不动
     */
    
    
    
    
    
    
    
  //播完后，小脚丫又走起来
}

-(void)toPlayNextDiary:(NSNumber*)nextDiaryIndexToPlayNumber{
    int nextDiaryIndexToPlay = [nextDiaryIndexToPlayNumber intValue];
    
    if(self.isCurDiaryPlayStop){
        [self releaseLastPlayDiaryResource];
        return;
    }
    if(self.netVideoPlayerView && self.netVideoPlayerView.hidden == NO){
        self.netVideoPlayerView.hidden = YES;
        //停止播放器资源
        [self.videoPlayer pausePlaying];
    }
    
//    if(self.userHeadView.hidden == NO){
//        self.userHeadView.hidden = YES;
//    }
    
    if(self.fullScreenImageView && self.fullScreenImageView.hidden == NO){
        self.fullScreenImageView.hidden = YES;
    }
    self.bottomControlBar.hidden = NO;
    self.audioView.hidden = YES;
    
    self.moveToNextPosFinish = NO;
    if(self.diarysArray && [self.diarysArray count] > 0 && nextDiaryIndexToPlay < [self.diarysArray count]){
        self.nextDiaryIndexToPlay++;//改变下一条日记指针
        
        if(self.nextDiaryIndexToPlay == [self.diarysArray count]){//循环播放
            self.nextDiaryIndexToPlay = 1;
        }
        
         NSLog(@"toPlayNextDiary, self.nextDiaryIndexToPlay is %d", self.nextDiaryIndexToPlay);
        //播放下一条日记
        self.preDiary = [self.diarysArray objectAtIndex:nextDiaryIndexToPlay - 1];
        self.curDiary = [self.diarysArray objectAtIndex:nextDiaryIndexToPlay];
        
        CLLocationCoordinate2D mapCenter =   CLLocationCoordinate2DMake([self.preDiary.d_latitude doubleValue], [self.preDiary.d_longitude doubleValue]);
        CLLocationCoordinate2D oneBorderLocation =   CLLocationCoordinate2DMake([self.curDiary.d_latitude doubleValue], [self.curDiary.d_longitude doubleValue]);
        [self.mapView setRegion:[self regionAccordingToCenterAndOneBorderLocation:mapCenter mapBorderLocation:oneBorderLocation] animated:YES];
        
        CLLocationCoordinate2D diaryCoor =   CLLocationCoordinate2DMake([self.preDiary.d_latitude doubleValue], [self.preDiary.d_longitude doubleValue]);
        [self.mapView setCenterCoordinate:diaryCoor animated:YES];
                
        [self performSelector:@selector(startFootMoveAnni:) withObject:[NSNumber numberWithInt:nextDiaryIndexToPlay] afterDelay:3.0];
    }
}

-(void)startFootMoveAnni:(NSNumber*)nextDiaryIndexToPlayNumber{
    if(self.isCurDiaryPlayStop){
        [self releaseLastPlayDiaryResource];
        return;
    }
    //两个中心点的距离l,平分X轴，然后求得y坐标，等分10等份
    if(self.locationCoordinateArray && [self.locationCoordinateArray count] > 0){
        [self.locationCoordinateArray removeAllObjects];
    }
    CLLocationCoordinate2D preDiaryLocationCoor2D = CLLocationCoordinate2DMake([self.preDiary.d_latitude doubleValue], [self.preDiary.d_longitude doubleValue]);
    CLLocationCoordinate2D diaryLocationCoor2D = CLLocationCoordinate2DMake([self.curDiary.d_latitude doubleValue], [self.curDiary.d_longitude doubleValue]);
    
    CGPoint preDiaryPoint = [self.mapView convertCoordinate:preDiaryLocationCoor2D toPointToView:self.mapView];
    CGPoint diaryPoint = [self.mapView convertCoordinate:diaryLocationCoor2D toPointToView:self.mapView];
    
    if(diaryPoint.x > preDiaryPoint.x){
        self.isCurDiaryScreenXBigger = YES;
    }
    
    if(diaryPoint.y > preDiaryPoint.y){
       self.isCurDiaryScreenYBigger = YES;
    }
    
    self.lineK = (diaryPoint.y - preDiaryPoint.y)/ (diaryPoint.x - preDiaryPoint.x);
    //沿X轴平分10等份
    int partsToSplit = 20;
    self.xDt = ABS(preDiaryPoint.x - diaryPoint.x)/partsToSplit;
    for(int i = 0 ; i < partsToSplit; i++){
        double tempX = 0;
        if(!self.isCurDiaryScreenXBigger){
            tempX = preDiaryPoint.x - self.xDt*i;
        }else{
            tempX = preDiaryPoint.x + self.xDt*i;
        }
        double tempY = [self getLinePointYByX:self.lineK pointX:tempX knownPointX1:diaryPoint.x knownPointY1:diaryPoint.y];
        CGPoint tempPoint = CGPointMake(tempX, tempY);
        [self.locationCoordinateArray addObject:[NSValue valueWithCGPoint:tempPoint]];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:nextDiaryIndexToPlayNumber forKey:@"curDiaryIndexToPlay"];

    self.footMoveTimer = [NSTimer scheduledTimerWithTimeInterval:(0.2) target:self selector:@selector(onFootMoveTimer:) userInfo:dict repeats:YES];
}

- (void)removeSmoke:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{

}

-(void)onFootMoveTimer:(NSTimer *)timer{
    if(self.isCurDiaryPlayStop){
        [self releaseLastPlayDiaryResource];
        return;
    }
    int curDiaryIndexToPlay = [[[timer userInfo] objectForKey:@"curDiaryIndexToPlay"]intValue];
    //地图向后移动就是地图中心点的改变
    if(self.footMoveCounter < [self.locationCoordinateArray count] && !self.moveToNextPosFinish){
         CGPoint point = [[self.locationCoordinateArray objectAtIndex:self.footMoveCounter] CGPointValue];
        CLLocationCoordinate2D centerCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        double maxLatitude = 0;
        double minLatitude = 0;
        DiaryData* diaryData = [self.diarysArray objectAtIndex:curDiaryIndexToPlay];
        //DiaryData* diaryData = [self.diarysArray objectAtIndex:self.nextDiaryIndexToPlay - 1];
        if(self.isCurDiaryScreenXBigger){
            if(!self.isCurDiaryScreenYBigger){// 北京到沈阳 例如
                maxLatitude = [diaryData.d_latitude doubleValue];
                if(centerCoordinate.latitude <= maxLatitude){
                    [self.mapView setCenterCoordinate:centerCoordinate];
                    
                    //                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3_jiaoya.png"]];
                    //
                    //                self.footScreenX = self.view.center.x - self.xDt*([self.locationCoordinateArray count] - self.footMoveCounter);
                    //                double imageViewFrameX = self.footScreenX;
                    //                double imageViewFrameY = [self getLinePointYByX:self.lineK pointX:self.footScreenX knownPointX1:point.x knownPointY1:point.y];
                    //
                    //                //第一次
                    //                imageView.frame = CGRectMake(imageViewFrameX, imageViewFrameY, 12, 15);
                    //                [self.view addSubview:imageView];
                    //                [UIView beginAnimations:nil context:(__bridge void *)(imageView)];
                    //                [UIView setAnimationDuration:0.2];
                    //                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                    //
                    //                [imageView setAlpha:1.0];
                    //                [UIView setAnimationDelegate:self];
                    //                [UIView setAnimationDidStopSelector:@selector(removeSmoke:finished:context:)];
                    //                [UIView commitAnimations];
                }else{
                    if(self.mapView.centerCoordinate.latitude != maxLatitude){
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([diaryData.d_latitude doubleValue], [diaryData.d_longitude doubleValue]);
                        [self.mapView setCenterCoordinate:coordinate];
                        [self updateViewsByCurDiary:diaryData];
                    }
                }
            }else{//北京--上海
                minLatitude = [diaryData.d_latitude doubleValue];
                if(centerCoordinate.latitude >= minLatitude){
                    [self.mapView setCenterCoordinate:centerCoordinate];
                }else{
                    if(self.mapView.centerCoordinate.latitude != minLatitude){
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([diaryData.d_latitude doubleValue], [diaryData.d_longitude doubleValue]);
                        [self.mapView setCenterCoordinate:coordinate];
                        [self updateViewsByCurDiary:diaryData];
                    }
                }
            }    
        }else{//北京到西安, 沈阳到西安
            if(self.isCurDiaryScreenYBigger){
                minLatitude = [diaryData.d_latitude doubleValue];
                if(centerCoordinate.latitude >= minLatitude){
                    [self.mapView setCenterCoordinate:centerCoordinate];
                }else{
                    if(self.mapView.centerCoordinate.latitude != minLatitude){
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([diaryData.d_latitude doubleValue], [diaryData.d_longitude doubleValue]);
                        [self.mapView setCenterCoordinate:coordinate];
                        [self updateViewsByCurDiary:diaryData];
                    }
                }
            }else{//上海 ---呼和浩特
                maxLatitude = [diaryData.d_latitude doubleValue];
                if(centerCoordinate.latitude <= maxLatitude){
                    [self.mapView setCenterCoordinate:centerCoordinate];
                }else{
                    if(self.mapView.centerCoordinate.latitude != maxLatitude){
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([diaryData.d_latitude doubleValue], [diaryData.d_longitude doubleValue]);
                        [self.mapView setCenterCoordinate:coordinate];
                        [self updateViewsByCurDiary:diaryData];
                    }
                }
            }
        }
        //脚丫动画,从上一个位置到当前位置
        if(self.isCurDiaryScreenXBigger){//北京---沈阳
            //两点之间直线距离
          //  UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3_jiaoya.png"]];
//            self.footScreenX = self.footScreenX - self.footMoveCounter*self.xDt;
//            double imageViewFrameX = self.footScreenX;
//            double imageViewFrameY = [self getLinePointYByX:self.lineK pointX:self.footScreenX knownPointX1:point.x knownPointY1:point.y];
//            
//            //第一次
//            imageView.frame = CGRectMake(imageViewFrameX, imageViewFrameY, 12, 15);
//            [self.view addSubview:imageView];
//            [UIView beginAnimations:nil context:(__bridge void *)(imageView)];
//            [UIView setAnimationDuration:0.2];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//            
//            [imageView setAlpha:1.0];
//            [UIView setAnimationDelegate:self];
//            [UIView setAnimationDidStopSelector:@selector(removeSmoke:finished:context:)];
//            [UIView commitAnimations];
            
        
        }else{ //北京---西安  上海----绍兴
            
             /************************************算法begin**************************************/
       //     CLLocationCoordinate2D curDiaryLocation = CLLocationCoordinate2DMake([self.curDiary.d_latitude doubleValue], [self.curDiary.d_longitude doubleValue]);
//            
//            CLLocationCoordinate2D preDiaryLocation = CLLocationCoordinate2DMake([self.preDiary.d_latitude doubleValue], [self.preDiary.d_longitude doubleValue]);
//            CGPoint preDiaryPoint = [self.mapView convertCoordinate:preDiaryLocation toPointToView:self.mapView];
//            for(int i = 0 ; i < self.footMoveCounter; i++){
//                UIImageView *footImageView = (UIImageView*)[self.view viewWithTag:(TileInitialTag + i)];
//                if(footImageView.origin.x < preDiaryPoint.x){
//
//                    [UIView beginAnimations:nil context:(__bridge void *)(footImageView)];
//                    [UIView setAnimationDuration:0.2];
//                    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//                    if(self.footMoveCounter > 4){
//                        footImageView.alpha = 0.4;
//                    }else{
//                        [footImageView setAlpha:1.0];
//                    }
//                    [UIView commitAnimations];
//                }
//            }
//            UIImageView* footImgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3_jiaoya.png"]];
//            footImgeView.tag = TileInitialTag + self.footMoveCounter ;
//
//            CGPoint curDiaryPoint = [self.mapView convertCoordinate:curDiaryLocation toPointToView:self.mapView];
//            double xlong = self.view.center.x - curDiaryPoint.x;
//        
//            double imageViewFrameX = self.view.center.x + xlong;
//            double imageViewFrameY = [self getLinePointYByX:self.lineK pointX:imageViewFrameX knownPointX1:point.x knownPointY1:point.y];
//            footImgeView.frame = CGRectMake(imageViewFrameX, imageViewFrameY, 12, 15);
//            footImgeView.alpha = 0.0;
//            if(imageViewFrameX < preDiaryPoint.x){
//                footImgeView.alpha =1.0;
//                //footImgeView.hidden = NO;
//            }
//             [self.view addSubview:footImgeView];
            /************************************算法end**************************************/
            
            //原来的坐标改变一下，然后，加一个
//            for(int i = 0 ; i < self.footMoveCounter; i++){
//                UIImageView *footImageView = (UIImageView*)[self.view viewWithTag:(TileInitialTag + i)];
//                
//                double imageViewFrameX = footImageView.origin.x + self.xDt*(i+1);
//                double imageViewFrameY = [self getLinePointYByX:self.lineK pointX:imageViewFrameX knownPointX1:point.x knownPointY1:point.y];
//                footImageView.frame = CGRectMake(imageViewFrameX, imageViewFrameY, 12, 15);
//                [UIView beginAnimations:nil context:(__bridge void *)(footImageView)];
//                [UIView setAnimationDuration:0.2];
//                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//                
//                [footImageView setAlpha:1.0];
//                [UIView setAnimationDelegate:self];
//                [UIView setAnimationDidStopSelector:@selector(removeSmoke:finished:context:)];
//                [UIView commitAnimations];
//            }
//            //增加一个
//            UIImageView * footImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3_jiaoya.png"]];
//            footImageView1.frame = CGRectMake(self.view.center.x, self.view.center.y, 12, 15);
//            footImageView1.tag = TileInitialTag + self.footMoveCounter ;
//            [self.view addSubview:footImageView1];
//            if(!self.footImageView){
//                self.footImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3_jiaoya.png"]];
//                [self.view addSubview:self.footImageView];
//            }

//            CLLocationCoordinate2D preDiaryLocation = CLLocationCoordinate2DMake([self.preDiary.d_latitude doubleValue], [self.preDiary.d_longitude doubleValue]);
//            CGPoint preDiaryPoint = [self.mapView convertCoordinate:preDiaryLocation toPointToView:self.mapView];
//            double imageViewFrameX = preDiaryPoint.x;
//            double imageViewFrameY =  [self getLinePointYByX:self.lineK pointX:imageViewFrameX knownPointX1:point.x knownPointY1:point.y];
//            
//            //第一次
//            self.footImageView.frame = CGRectMake(imageViewFrameX, imageViewFrameY, 12, 15);
           // [self.view addSubview:imageView];
            
//            [UIView beginAnimations:nil context:(__bridge void *)(self.footImageView)];
//            [UIView setAnimationDuration:0.2];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//            
//            [self.footImageView setAlpha:1.0];
//            [UIView setAnimationDelegate:self];
//            [UIView setAnimationDidStopSelector:@selector(removeSmoke:finished:context:)];
//            [UIView commitAnimations];
            
        }
        self.footMoveCounter ++;
//        if(self.footMoveCounter == [self.locationCoordinateArray count]){
//            self.diaryPosView.hidden = NO;
//            [self playViewTransiAnimis:self.diaryPosView isFromLeft:NO];
//        }
        
    }else{
        [self releaseLastPlayDiaryResource];
    }
}

-(void)updateViewsByCurDiary:(DiaryData*)diaryData{
    self.moveToNextPosFinish = YES;
    self.diaryPosView.hidden = NO;
    self.locationLabel.text =diaryData.d_position;
    [self.johnClockView setNextDate:[NSDate dateWithTimeIntervalSince1970:[self.curDiary.d_diarytimemilli doubleValue]/1000]];
    
    [self updateViewByDiaryStyle:self.curDiary];
    
    [self playViewTransiAnimis:self.clockView isFromLeft:YES];
    [self playViewTransiAnimis:self.diaryPosView isFromLeft:NO];
    [Tools setImageViewCombineAnimation:self.locPinImageView iamges:self.locPinImages animationDuration:3.0 animationRepeatCount:1];
}

//已知直线斜率K，及直线上一点x坐标，求直线上Y坐标
-(double)getLinePointYByX:(double)lineK pointX:(double)pointX knownPointX1:(double)knownPointX1 knownPointY1:(double)knownPointY1{
   /*例：点A(x1,y1), B(x2,y2)
    斜率k=(y1-y2)/(x1-x2)
    再带 y-y1=k(x-x1) */
    return lineK*(pointX - knownPointX1) + knownPointY1;
}

//-(void) onChangeMapZoomlevelTimerWhenEnter {
//    //改变2次视野缩放比例,升高到原来个级别
//    int zoomLevel = [self.mapView getZoomLevel];
//    if(self.timerCount <= 4 && zoomLevel < self.originZoomLevel){
//        zoomLevel = zoomLevel + self.timerCount;
//        [self.mapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:zoomLevel animated:YES];
//        self.timerCount ++;
//    }else{
//       //取消定时器
//        [self toPlayNextDiary:self.nextDiaryIndexToPlay];
//        [self.changeMapSizeAlphaTimer invalidate];
//    }
//}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}

- (void) mapView:(MKMapView *)mmapView regionDidChangeAnimated:(BOOL)animated {

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(IBAction)toPreviousDiaryBtnPressed:(id)sender{
  //播放上一个日记
    self.isCurDiaryPlayStop = YES; //停止当前日记播放
    [self releaseLastPlayDiaryResource];
    if(self.nextDiaryIndexToPlay > 1){
        self.nextDiaryIndexToPlay--;
    }
    if(self.nextDiaryIndexToPlay >0 && self.nextDiaryIndexToPlay < [self.diarysArray count]){
        //判断日记类型,确定展示形式，展示完成后，去展示下一个日记
        DiaryData *curDiary = [self.diarysArray objectAtIndex:self.nextDiaryIndexToPlay - 1];
        [self addMapAnnotationByDiary:curDiary];
        [self updateViewByDiaryStyle:curDiary];
        
        //NSLog(@"toPreviousDiaryBtnPressed, self.nextDiaryIndexToPlay is %d", self.nextDiaryIndexToPlay);
        [self performSelector:@selector(toPlayNextDiary:) withObject:[NSNumber numberWithInt:self.nextDiaryIndexToPlay] afterDelay:0.5];
        self.isCurDiaryPlayStop = NO;
    }
}

-(void)releaseLastPlayDiaryResource{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startFootMoveAnni:) object:[NSNumber numberWithInt:self.nextDiaryIndexToPlay]];
    
    self.footMoveCounter = 0;
    self.isCurDiaryScreenYBigger = NO;
    self.isCurDiaryScreenXBigger = NO;
    if ([self.footMoveTimer isValid] || self.footMoveTimer != nil) {
        [self.footMoveTimer invalidate];
        self.self.footMoveTimer = nil;
    }
}

-(IBAction)playDiaryBtnPressed:(id)sender{
    self.isCurDiaryPlayStop = !self.isCurDiaryPlayStop;
    if(self.isCurDiaryPlayStop){
        [self releaseLastPlayDiaryResource];
    }else{
        [self releaseLastPlayDiaryResource];
        [self performSelector:@selector(toPlayNextDiary:) withObject:[NSNumber numberWithInt:self.nextDiaryIndexToPlay] afterDelay:0.5];
    }
}

-(IBAction)toNextDiaryBtnPressed:(id)sender{
    //播放下一个日记
    self.isCurDiaryPlayStop = YES; //停止当前日记播放
    [self releaseLastPlayDiaryResource];
    if(self.nextDiaryIndexToPlay < [self.diarysArray count]){
        self.nextDiaryIndexToPlay++;
        if(self.nextDiaryIndexToPlay == [self.diarysArray count]){
            self.nextDiaryIndexToPlay = 1;
        }
    }
    if(self.nextDiaryIndexToPlay >0 && self.diarysArray && [self.diarysArray count] > 0 && self.nextDiaryIndexToPlay < [self.diarysArray count]){
        //判断日记类型,确定展示形式，展示完成后，去展示下一个日记
        DiaryData *curDiary = [self.diarysArray objectAtIndex:self.nextDiaryIndexToPlay - 1];
        [self addMapAnnotationByDiary:curDiary];
        [self updateViewByDiaryStyle:curDiary];
        
        //NSLog(@"toNextDiaryBtnPressed, self.nextDiaryIndexToPlay is %d", self.nextDiaryIndexToPlay);
        [self performSelector:@selector(toPlayNextDiary:) withObject:[NSNumber numberWithInt:self.nextDiaryIndexToPlay] afterDelay:0.5];
        self.isCurDiaryPlayStop = NO;
    }
}

-(IBAction)backBtnPressed:(id)sender{
    
    [self releaseLastPlayDiaryResource];
    //全屏显示
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    // 修改状态栏的方向及view的方向进而强制旋转屏幕
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    self.navigationController.view.transform = CGAffineTransformIdentity;
    self.navigationController.view.bounds = CGRectMake(self.navigationController.view.bounds.origin.y, self.navigationController.view.bounds.origin.x, self.navigationController.view.height, self.navigationController.view.width);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark MiniPlayerDelegate methods
- (void)miniPlayerDidFinishedPlaying:(MiniPlayer *)player{
    //播放完视频后播放下一条日记
    [self performSelector:@selector(toPlayNextDiary:) withObject:[NSNumber numberWithInt:self.nextDiaryIndexToPlay] afterDelay:3.0];
}

@end
