//
//  CustomMoviePlayer.h
//  
//
//  Created by apple on 12-4-17.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
typedef enum
{
    PLAYER_DEFAULT = 0,
    PLAYER_NETWORK = 1     // 读取网络视频的播放器
} PLAY_TYPE;

@protocol CustomMoviePlayerDelegate <NSObject>

@optional

/**
 * 功能：动画开始回调
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-17
 */
- (void) animationStart;


/**
 * 功能：动画结束回调
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-17
 */
- (void) animationDidStop;


/**
 * 功能：点击空白区域回调
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-17
 */
- (void) touchInBlankView:(id) sender;

@end

@interface CustomMoviePlayer : NSObject
@property (nonatomic,strong) UIView* baseView;
@property (nonatomic) PLAY_TYPE playerType;
@property (nonatomic,strong) UIButton* zoomButton;
@property (nonatomic,strong) UIView* superView;
@property (nonatomic, assign) id<CustomMoviePlayerDelegate> myDelegate;
-(id)init:(NSString*)videoURL:(NSString*)videoid:(int)autoPlay:(int)fullScreen;
-(void)reSet:(NSString*)url:(NSString*)videoid:(int)autoPlay:(int)fullScreen;
-(void)releasePlayer;

/**
 * 功能：默认是一种界面模式，其他得界面调整根据type来定
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-16
 */
-(void) setPlayerType:(PLAY_TYPE ) type;

/**
 * 功能：放大缩小的动画
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-16
 */
-(void) setPlayerViewRect:(CGRect) newFrame;


/**
 * 功能：隐藏所有内容
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-16
 */
-(void)hideAllControls;

/**
 * 功能：隐藏所有内容
 * 参数：
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-16
 */
-(void)showAllControls;

/**
 * 功能：暂停播放
 * 参数：isPlay: YES 执行播放功能   no: 执行暂停功能
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-04-16
 */
-(void)playOrPause:(BOOL) isPlay;

/**
 * 功能：快进到指定时刻播放
 * 参数：time: 指定时刻
 * 返回值：空
 
 * 创建者：xudongsheng
 * 创建日期：2013-04-16
 */
-(void)seek:(double)time;

-(void)changeZoomButtonState:(int)state;

@end