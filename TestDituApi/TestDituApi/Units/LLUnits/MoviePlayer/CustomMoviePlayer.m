//
//  CustomMoviePlayer.m
//  
//
//  Created by apple on 12-4-17.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "CustomMoviePlayer.h"
#import "Global.h"
#import "CustomAlert.h"
//#import "VideoShareAppDelegate.h"
#import "Tools.h"
#import "UIViewAdditions.h"
#import "MBProgressHUD.h"
#import "UISliderEx.h"
#import <QuartzCore/QuartzCore.h>
#import "effects_define.h"

#define PLAY_BUTTON_WIDTH 49
#define PLAY_BUTTON_HEIGHT 49
#define ZOOM_BUTTON_WIDTH 49
#define ZOOM_BUTTON_HEIGHT 49
#define TIME_BG_WIDTH 77.5
#define TIME_BG_HEIGHT 14.5

@interface CustomMoviePlayer()<MBProgressHUDDelegate>
@property (nonatomic,strong) UIButton* playButton;
@property (nonatomic,strong) NSString* videoURL;
@property (nonatomic,strong) NSString* videoID;
@property (nonatomic,strong) MPMoviePlayerController* player;
@property (nonatomic,strong) MBProgressHUD* HUD;
@property (nonatomic,strong) UISliderEx* slider;
@property (nonatomic,strong) UIImageView* sliderBG;
//@property (nonatomic,strong) UIButton* zoomButton;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int delayhideFlag;
@property (nonatomic,strong) UIImageView* timeBG;
@property (nonatomic,strong) UILabel* timeLabel;
@property (nonatomic,assign) int autoPlayAfterInit;
@property (nonatomic,assign) int fullScreenAfterInit;
@end

@implementation CustomMoviePlayer
@synthesize baseView =_baseView;
@synthesize playButton=_playButton;
@synthesize videoURL=_videoURL;
@synthesize videoID=_videoID;
@synthesize player=_player;
@synthesize HUD=_HUD;
@synthesize slider = _slider;
@synthesize sliderBG=_sliderBG;
@synthesize zoomButton=_zoomButton;
@synthesize timer=_timer;
@synthesize delayhideFlag;
@synthesize superView=_superView;
@synthesize timeBG=_timeBG;
@synthesize timeLabel=_timeLabel;
@synthesize playerType;
@synthesize myDelegate = _myDelegate;
@synthesize autoPlayAfterInit;
@synthesize fullScreenAfterInit;
//层级关系
//superview
//        |baseview
//                |playview-----button-----slider-----timeBG
//                        |touchview                       |timeLabel

//static CustomMoviePlayer* singleCustomMoviePlayer=nil;
//
//+(CustomMoviePlayer *)fetchSingleCustomMoviePlayer
//{
//    static dispatch_once_t singleCustomMoviePlayerFlag;
//    dispatch_once(&singleCustomMoviePlayerFlag, ^{
//        if (singleCustomMoviePlayer==nil) {
//            singleCustomMoviePlayer=[[CustomMoviePlayer alloc] init:@"":@""];
//        }
//    });
//    return singleCustomMoviePlayer;
//}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_HUD removeFromSuperview];
    _HUD.delegate = nil;
	self.HUD = nil;
}

-(id)init:(NSString*)videoURL:(NSString*)videoid:(int)autoPlay:(int)fullScreen
{
    if (self = [super init]) {
        self.baseView = [[UIView alloc]initWithFrame:CGRectZero];
        self.playButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_1"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_2"] forState:UIControlStateHighlighted];

        _sliderBG = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sliderBG.image = [[UIImage imageNamed:@"jindu_1"]stretchableImageWithLeftCapWidth:9 topCapHeight :0];
        [_baseView addSubview:_sliderBG];
        
        self.slider = [[UISliderEx alloc]initWithFrame:CGRectZero];
        _slider.minimumValue = 0.0;//下限
        _slider.maximumValue = 100.0;//上限
        _slider.value = 0;
        [_slider setThumbImage:[UIImage imageNamed:@"jindu_4"] forState: UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"jindu_4"] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.continuous = YES ;
        
        [_slider setMaximumTrackImage:[UIImage imageNamed:@"jindu_2"]forState:UIControlStateNormal];
        [_slider setMinimumTrackImage:[[UIImage imageNamed:@"jindu_3"]stretchableImageWithLeftCapWidth:9 topCapHeight :0] forState:UIControlStateNormal];
        [_baseView addSubview:_slider];
        [_baseView addSubview:_playButton];
        
        self.zoomButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_zoomButton addTarget:self action:@selector(zoomButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_zoomButton setBackgroundImage:[UIImage imageNamed:@"quanping_1"] forState:UIControlStateNormal];
        [_zoomButton setBackgroundImage:[UIImage imageNamed:@"quanping_2"] forState:UIControlStateHighlighted];
        [_baseView addSubview:_zoomButton];
        
        self.timeBG = [[UIImageView alloc] initWithFrame:CGRectZero];
        _timeBG.image = [UIImage imageNamed:@"time_kuang"];
        [_baseView addSubview:_timeBG];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = UITextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"00:00/00:00";
        [_timeBG addSubview:_timeLabel];
        
        
        _videoURL = videoURL;
        _videoID = videoid;
        [self initPlayer:autoPlay:fullScreen];
        
        [_baseView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

-(void)reSet:(NSString*)url:(NSString*)videoid:(int)autoPlay:(int)fullScreen
{
    [self terminateVideo];
    _videoURL = url;
    _videoID = videoid;
    [self initPlayer:autoPlay:fullScreen];
}

-(void)initPlayer:(int)autoPlay:(int)fullScreen
{
    if (!STR_IS_NIL(_videoURL)) {
        [self showWaiting];
        NSURL *URL=nil;
        if ([_videoURL rangeOfString:@"http://"].location!=NSNotFound||[_videoURL rangeOfString:@"https://"].location!=NSNotFound)
        {
            URL = [[NSURL alloc] initWithString:[Tools makeLogString:[_videoURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]] :_videoID]];
        }
        else {
            URL = [NSURL fileURLWithPath:[_videoURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]]];
        }
        if(URL)
        {
            self.player = [[MPMoviePlayerController alloc] initWithContentURL:URL];
            _player.movieSourceType = MPMovieSourceTypeFile;
            if
                (
                 [_player respondsToSelector:@selector(view)] &&
                 [_player respondsToSelector:@selector(setFullscreen:animated:)] &&
                 [_player respondsToSelector:@selector(setControlStyle:)]
                 )
            {
                [_player setControlStyle:MPMovieControlStyleNone];
                [_player.view setFrame:_baseView.bounds];
                [_baseView insertSubview:_player.view atIndex:0];
                [_player.view setHidden:YES];
                [self showAllControls];
                [_player play];
                autoPlayAfterInit = autoPlay;
                fullScreenAfterInit = fullScreen;
                
                UIView* touchView = [[UIView alloc]initWithFrame:_player.view.bounds];
                touchView.tag = 1;
                [_player.view addSubview:touchView];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
                [touchView addGestureRecognizer:singleTap];
            }
            
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(mPMoviePlayerPlaybackDidFinish:)
             name:MPMoviePlayerPlaybackDidFinishNotification
             object:_player];
            
            if (IOS_VERSION < 6.0) {
                [[NSNotificationCenter defaultCenter]
                 addObserver:self
                 selector:@selector(mPMovieDurationAvailable:)
                 name:MPMovieDurationAvailableNotification
                 object:_player];
            }
            else
            {
                [[NSNotificationCenter defaultCenter]
                 addObserver:self
                 selector:@selector(mPMoviePlayerReadyForDisplayDidChange:)
                 name:MPMoviePlayerReadyForDisplayDidChangeNotification
                 object:_player];
            }
            
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(mPMoviePlayerPlaybackStateDidChange:)
             name:MPMoviePlayerPlaybackStateDidChangeNotification
             object:_player];
            
        }
        else {
            CustomAlert* dialog = [[CustomAlert alloc] init];
            [dialog setDelegate:self];
            [dialog setTitle:@""];
            [dialog setMessage:@"正在发布,请稍后刷新页面重试"];
            [dialog addButtonWithTitle:@"是"];
            [dialog show];
        }
    }
}

-(void)playButtonPressed
{
    if (_playButton.selected == NO) {
        if (_player.duration <= 0) {
            CustomAlert* dialog = [[CustomAlert alloc] init];
            [dialog setDelegate:self];
            [dialog setTitle:@""];
            [dialog setMessage:@"网络异常"];
            [dialog addButtonWithTitle:@"是"];
            [dialog show];
        }
        else
        {
            [_player play];
        }
    }
    else
    {
        [self pausePlayer];
    }
}

-(void)zoomButtonPressed
{
    if (_zoomButton.selected == NO) {
        if (_player.duration <= 0) {
            CustomAlert* dialog = [[CustomAlert alloc] init];
            [dialog setDelegate:self];
            [dialog setTitle:@""];
            [dialog setMessage:@"网络异常"];
            [dialog addButtonWithTitle:@"是"];
            [dialog show];
        }
        else
        {
            [_player.view setHidden:NO];
            [self changeZoomButtonState:1];
            self.superView = _baseView.superview;
            UIWindow* keyWindow = [Tools getKeyWindow];
            [_baseView setFrame:keyWindow.bounds];
            [keyWindow addSubview:_baseView];
        }
    }
    else
    {
        [self changeZoomButtonState:0];
        if (_superView) {
            [_baseView setFrame:_superView.bounds];
            [_superView addSubview:_baseView];
        }
        if (fullScreenAfterInit) {
            [self releasePlayer];
        }
    }

}

//5.0
-(void)mPMovieDurationAvailable:(NSNotification *)notification
{
    MPMoviePlayerController *theMovie = (MPMoviePlayerController*)[notification object];
    if (theMovie == _player) {
        [self pausePlayer];
        if (autoPlayAfterInit) {
            [_player play];
        }
        autoPlayAfterInit = 0;
        if (fullScreenAfterInit) {
            [self zoomButtonPressed];
        }
        [self hideWaiting];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [_player.view setHidden:NO];
        });
        _slider.value = 0;
        _slider.maximumValue=_player.duration;
        [self setTimeText];
    }
}

//6.0
-(void)mPMoviePlayerReadyForDisplayDidChange:(NSNotification *)notification
{
    MPMoviePlayerController *theMovie = (MPMoviePlayerController*)[notification object];
    if (theMovie == _player) {
        [self pausePlayer];
        if (autoPlayAfterInit) {
            [_player play];
        }
        autoPlayAfterInit = 0;
        if (fullScreenAfterInit) {
            [self zoomButtonPressed];
        }
        [self hideWaiting];
        [_player.view setHidden:NO];
        
        _slider.value = 0;
        _slider.maximumValue=_player.duration;
        [self setTimeText];
    }

}

- (void) mPMoviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    MPMoviePlayerController *theMovie = (MPMoviePlayerController*)[notification object];
    if (theMovie == _player) {
        if (_zoomButton.selected == YES) {
            [self zoomButtonPressed];
        }
        if (_player.duration > 0) {//地址不可用时候，值为零
            [self terminateVideo];
            [self initPlayer:0:0];
//            [_player setCurrentPlaybackTime:0];
//            [_player pause];
//            _slider.value = 0;
//            [self setTimeText];

        }
    }
}

-(void)mPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerController *theMovie = (MPMoviePlayerController*)[notification object];
    if (theMovie == _player) {
        if ([_player playbackState] == MPMoviePlaybackStatePlaying) {//正在播放
            if (playerType == PLAYER_DEFAULT)
            {
                _playButton.hidden = YES;
            }
            [self changePlayButtonState:1];
            [self startTimer];
        }
        else if ([_player playbackState] == MPMoviePlaybackStateStopped)//已停止
        {
            [self changePlayButtonState:0];
            [self stopTimer];
        }
        else if ([_player playbackState] == MPMoviePlaybackStatePaused)//已暂停
        {
            [self changePlayButtonState:0];
            [self stopTimer];
        }
        else if ([_player playbackState] == MPMoviePlaybackStateInterrupted)//已中断
        {
            [self changePlayButtonState:0];
            [self stopTimer];
        }
        else if ([_player playbackState] == MPMoviePlaybackStateSeekingForward || [_player playbackState] == MPMoviePlaybackStateSeekingBackward)//正在快退快进
        {
        }
        else//其他
        {
            //[_playButton setHidden:NO];
        }
    }
}

- (void) terminateVideo
{
    [_player pause];
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_player && [_player respondsToSelector:@selector(view)])
    {
        [_player setControlStyle:MPMovieControlStyleNone];
        [[_player view] removeFromSuperview];
    }
    self.player = nil;
}

-(void)showWaiting
{
    if (!_HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:_baseView];
        [_baseView addSubview:_HUD];
        _HUD.delegate = self;
        [_HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}
- (void)myTask
{
    // Do something usefull in here instead of sleeping ...
    sleep(10);
}

-(void)hideWaiting
{
    if (_HUD) {
        [self hudWasHidden:_HUD];
    }
}

- (void) sliderValueChanged:(id)sender{
    UISlider* control = (UISlider*)sender;
    if(control == _slider){
        [_player setCurrentPlaybackTime:_slider.value];
        [self setTimeText];
    }
}

-(void)changePlayButtonState:(int)state
{
    if (state==0) {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_1"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_2"] forState:UIControlStateHighlighted];
        _playButton.selected = NO;
        [self cancelDelayHide];
    }
    else
    {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause_1"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause_2"] forState:UIControlStateHighlighted];
        _playButton.selected = YES;
    }

}

-(void)changeZoomButtonState:(int)state
{
    if (state==0) {
        [_zoomButton setBackgroundImage:[UIImage imageNamed:@"quanping_1"] forState:UIControlStateNormal];
        [_zoomButton setBackgroundImage:[UIImage imageNamed:@"quanping_2"] forState:UIControlStateHighlighted];
        _zoomButton.selected = NO;
    }
    else
    {
        [_zoomButton setBackgroundImage:[UIImage imageNamed:@"suoxiao_1"] forState:UIControlStateNormal];
        [_zoomButton setBackgroundImage:[UIImage imageNamed:@"suoxiao_2"] forState:UIControlStateHighlighted];
        _zoomButton.selected = YES;
    }
    
}

-(void)startTimer
{
    [self stopTimer];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(handlePlaybackTime) userInfo:nil repeats:YES];
}

-(void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        self.timer=nil;
    }
}

-(void)handlePlaybackTime
{
    if (_player) {
        if (_slider.state!=UIControlStateHighlighted) {
            int j = [_player currentPlaybackTime];
            [self setTimeText];
            if (j>=_slider.value) {
                _slider.value=j;
                if (_playButton.selected == YES && _zoomButton.hidden == NO && delayhideFlag == 0) {
                    [self doDelayHide];
                }
            }
        }
        else
        {
            [self cancelDelayHide];
        }
    }
}

-(void)pausePlayer
{
    [_player pause];
}

-(void)dealloc
{
    [self releasePlayer];
    [_baseView removeObserver:self forKeyPath:@"frame"];
}

-(void)releasePlayer
{
    [self hideWaiting];
    [self terminateVideo];
    [_baseView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)layoutSubViews
{
    if (playerType != PLAYER_DEFAULT)
    {
        [self changeFrameByType:playerType];
        return;
    }
    [_playButton setFrame:CGRectMake((_baseView.width - PLAY_BUTTON_WIDTH)/2,(_baseView.height - PLAY_BUTTON_HEIGHT)/2, PLAY_BUTTON_WIDTH, PLAY_BUTTON_HEIGHT)];
    [_sliderBG setFrame:CGRectMake(7.5f, _baseView.height-33, _baseView.width-7.5f-ZOOM_BUTTON_WIDTH-5-5, 10)];
    
    [_slider removeFromSuperview];
    float min = _slider.minimumValue;
    float max = _slider.maximumValue;
    float value = _slider.value;
    self.slider = nil;
    
    self.slider = [[UISliderEx alloc]initWithFrame:CGRectMake(7.5f, _baseView.height-33, _baseView.width-7.5f-ZOOM_BUTTON_WIDTH-5-5, 0)];//高度设为0就好
    _slider.center =_sliderBG.center;
    _slider.minimumValue = min;
    _slider.maximumValue = max;
    _slider.value = value;
    [_slider setThumbImage:[UIImage imageNamed:@"jindu_4"] forState: UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"jindu_4"] forState:UIControlStateHighlighted];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.continuous = YES ;
    
    [_slider setMaximumTrackImage:[UIImage imageNamed:@"jindu_2"]forState:UIControlStateNormal];
    [_slider setMinimumTrackImage:[[UIImage imageNamed:@"jindu_3"]stretchableImageWithLeftCapWidth:9 topCapHeight :0] forState:UIControlStateNormal];
    [_baseView addSubview:_slider];
    
    [_zoomButton setFrame:CGRectMake(0,0, ZOOM_BUTTON_WIDTH, ZOOM_BUTTON_HEIGHT)];
    _zoomButton.center = CGPointMake(_baseView.width - 5 - ZOOM_BUTTON_WIDTH/2, _slider.center.y);
    
    [_timeBG setFrame:CGRectMake(22.5, _sliderBG.bottom, TIME_BG_WIDTH, TIME_BG_HEIGHT)];
    [_timeLabel setFrame:_timeBG.bounds];
    
    if (_player && [_player.view superview] == _baseView) {
        [_player.view setFrame:_baseView.bounds];
        UIView* touchView = [_player.view viewWithTag:1];
        if (touchView) {
            [touchView setFrame:_player.view.bounds];
        }
    }
}

-(void)hideAllControls
{
    _playButton.hidden = YES;
    _sliderBG.hidden =YES;
    _slider.hidden = YES;
    _zoomButton.hidden = YES;
    _timeBG.hidden = YES;
}

-(void)showAllControls
{
    _playButton.hidden = NO;
    _sliderBG.hidden = NO;
    _slider.hidden = NO;
    _zoomButton.hidden = NO;
    _timeBG.hidden = NO;
}

-(void)singleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (playerType == PLAYER_DEFAULT)
    {
        if (_zoomButton.hidden == YES) {
            [self showAllControls];
        }
        else
        {
            [self hideAllControls];
        }
    }
    else if (playerType == PLAYER_NETWORK)
    {
        if([self.myDelegate respondsToSelector:@selector(touchInBlankView:)])
        {
            [_myDelegate touchInBlankView:gestureRecognizer];
        }
    }
}

-(void)delayhide
{
    delayhideFlag = 0;
    if (playerType != PLAYER_NETWORK)
    {
        [self hideAllControls];
    }
}

-(void)cancelDelayHide
{
    delayhideFlag = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayhide) object:nil];
}

-(void)doDelayHide
{
    delayhideFlag = 1;
    [self performSelector:@selector(delayhide) withObject:nil afterDelay:3.0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        [self layoutSubViews];
    }
}

-(void)setTimeText
{
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",(int)_slider.value/60,(int)_slider.value%60,(int)_player.duration/60,(int)_player.duration%60];
}


- (void) changeFrameByType:(PLAY_TYPE ) type
{
    if (type == PLAYER_NETWORK)
    {
        float playBtnWidth = _playButton.frame.size.width;
        [_sliderBG setFrame:CGRectMake(playBtnWidth, _baseView.height-33, _baseView.width-7.5f-playBtnWidth-ZOOM_BUTTON_WIDTH-5-5, 10)];
        
        [_slider removeFromSuperview];
        float min = _slider.minimumValue;
        float max = _slider.maximumValue;
        float value = _slider.value;
        self.slider = nil;
//        if(!self.slider){
            self.slider = [[UISliderEx alloc]initWithFrame:CGRectMake(playBtnWidth, _baseView.height-33, _baseView.width-7.5f-playBtnWidth -ZOOM_BUTTON_WIDTH-5-5, 0)];//高度设为0就好
//        }else{
//            self.slider.frame = CGRectMake(playBtnWidth, _baseView.height-33, _baseView.width-7.5f-playBtnWidth -ZOOM_BUTTON_WIDTH-5-5, 0);
//        }
        _slider.center =_sliderBG.center;
        _slider.minimumValue = min;
        _slider.maximumValue = max;
        _slider.value = value;
        [_slider setThumbImage:[UIImage imageNamed:@"jindu_4"] forState: UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"jindu_4"] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.continuous = YES ;
        
        [_slider setMaximumTrackImage:[UIImage imageNamed:@"jindu_2"]forState:UIControlStateNormal];
        [_slider setMinimumTrackImage:[[UIImage imageNamed:@"jindu_3"]stretchableImageWithLeftCapWidth:9 topCapHeight :0] forState:UIControlStateNormal];
        [_baseView addSubview:_slider];
        
//        [_zoomButton setFrame:CGRectMake(0,0, ZOOM_BUTTON_WIDTH, ZOOM_BUTTON_HEIGHT)];
        _zoomButton.center = CGPointMake(_baseView.width - 5 - ZOOM_BUTTON_WIDTH/2, _slider.center.y);
        
        [_playButton setCenter:CGPointMake(playBtnWidth/2, _slider.center.y)];

        [_timeBG setFrame:CGRectMake(22.5 + playBtnWidth, _sliderBG.bottom, TIME_BG_WIDTH, TIME_BG_HEIGHT)];
        [_timeLabel setFrame:_timeBG.bounds];
        
        if (_player && [_player.view superview] == _baseView) {
            [_player.view setFrame:_baseView.bounds];
            UIView* touchView = [_player.view viewWithTag:1];
            if (touchView) {
                [touchView setFrame:_player.view.bounds];
            }
        }
    }
}

/**
 * 功能：默认是一种界面模式，其他得界面调整根据type来定
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-16
 */
-(void) setPlayerType:(PLAY_TYPE ) type
{
    playerType = type;
    if (type == PLAYER_DEFAULT)
    {
        return;
    }
    else
    {
        CGRect pRect = self.playButton.frame;
        pRect.origin = CGPointMake(0, self.zoomButton.frame.origin.y);
        self.playButton.frame = pRect;
        
        CGRect sRect = self.slider.frame;
        sRect.origin.x = sRect.origin.x + pRect.size.width;
        sRect.size.width = sRect.size.width - pRect.size.width;
        self.slider.frame = sRect;
        
        CGRect sBgRect = self.sliderBG.frame;
        sBgRect.origin.x = sBgRect.origin.x + pRect.size.width;
        sBgRect.size.width = sBgRect.size.width - pRect.size.width;
        self.sliderBG.frame = sBgRect;
        
        CGRect timeBgRect = self.timeBG.frame;
        timeBgRect.origin.x = timeBgRect.origin.x + pRect.size.width;
        self.timeBG.frame = timeBgRect;
    }
}



/**
 * 功能：放大缩小的动画
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-16
 */
-(void) setPlayerViewRect:(CGRect) newFrame
{
    [UIView beginAnimations:@"newFrame" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    self.baseView.frame = newFrame;
    [UIView commitAnimations];
}

- (void) animationDidStart:(CAAnimation *)anim
{
    if ([self.myDelegate respondsToSelector:@selector(animationStart)])
    {
        [self.myDelegate animationStart];
    }
}
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.myDelegate respondsToSelector:@selector(animationDidStop)])
    {
        [self.myDelegate animationDidStop];
    }
}
/**
 * 功能：暂停播放
 * 参数：isPlay: YES 执行播放功能   no: 执行暂停功能
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-16
 */
-(void)playOrPause:(BOOL) isPlay
{
    if (isPlay)
    {
        [self.player play];
    }
    else
    {
        [self.player pause];
    }
}
/**
 * 功能：快进到指定时刻播放
 * 参数：time: 指定时刻
 * 返回值：空
 
 * 创建者：xudongsheng
 * 创建日期：2013-04-16
 */
-(void)seek:(double)time{
    self.player.currentPlaybackTime = time;
}


@end
