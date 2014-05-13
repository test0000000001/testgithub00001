//
//  MapWatchModeViewController.h
//  VideoShare
//
//  Created by xu dongsheng on 13-6-8.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JohnClockView.h"
#import "UIViewAdditions.h"
#import "JohnVoiceButton.h"
#import "JohnMoviePlayer.h"
#import "MiniPlayer.h"

#define VIDEO_SHOOT_TIME_FORMAT @"yyyy-MM-dd"


@interface MapWatchModeViewController : UIViewController<MKMapViewDelegate, JohnMoviePlayerDelegate,MiniPlayerDelegate>
//地图
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

//钟表
@property (nonatomic, strong) IBOutlet UIView *clockView;

//位置
@property (nonatomic, strong) IBOutlet UIView *diaryPosView;
@property (nonatomic, strong) IBOutlet  UIImageView *locPinImageView; //观赏模式右边位置大头针
@property (nonatomic, strong) IBOutlet  UILabel *locationLabel; //日记位置信息

//用户头像
@property (nonatomic, strong) IBOutlet UIView *userHeadView;
@property (nonatomic, strong) IBOutlet UIImageView *userHeadImageView;//用户头像

//视频
@property (nonatomic, strong) IBOutlet UIView *videoView;
@property (nonatomic, strong) IBOutlet UIImageView *videoCoverImageView; //视频拍摄时间
@property (nonatomic, strong) IBOutlet UILabel *videoShootTime; //视频拍摄时间
@property (nonatomic, strong) JohnMoviePlayer *videoPlayer;//视频播放器

//音频
@property (nonatomic, strong) IBOutlet UIView *audioView;
@property (nonatomic, strong) MiniPlayer *audioPlayer; //音频播放器

//文字
@property (nonatomic, strong) IBOutlet UIView *textDescView; 
@property (nonatomic, strong) IBOutlet UILabel *textDescLabel; //日记文字描述

//录音
@property (nonatomic, strong) IBOutlet UIView *soundRecordView; 
@property (nonatomic, strong) IBOutlet JohnVoiceButton *soundRecordVoiceBtn; //录音描述播放

//图片附件
@property (nonatomic, strong) IBOutlet UIView *imageAttachView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView; //图片控件
@property (nonatomic, strong) IBOutlet UILabel *imageShootTime; //图片生成时间


//日记播放控制栏
@property (nonatomic, strong) IBOutlet UIView *bottomControlBar;
@property (nonatomic, strong) IBOutlet UIButton *toPreviousBtn;//后退播放上一个按钮
@property (nonatomic, strong) IBOutlet UIButton *toNextBtn;//前进播放下一个按钮
@property (nonatomic, strong) IBOutlet UIButton *playBtn;//播放按钮

@property (nonatomic, strong) IBOutlet UIButton *backBtn; //退出观赏模式按钮

@property (nonatomic, assign) int startIndexToPlay ; //观赏模式起始播放索引

-(void)addDiaryArray:(NSMutableArray *)diarysArray startIndexToPlay:(int)startIndexToPlay;

-(IBAction)toPreviousDiaryBtnPressed:(id)sender;
-(IBAction)playDiaryBtnPressed:(id)sender;
-(IBAction)toNextDiaryBtnPressed:(id)sender;
-(IBAction)backBtnPressed:(id)sender;

@end
