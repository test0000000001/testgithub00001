//
//  UIImageViewZoomIn.m
//  VideoShare
//
//  Created by qin on 13-2-21.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#define kCoverViewTag           12344
#define kImageViewTag           12355
#define kAnimationDuration      0.3f
#define kImageViewWidth         320.0f
#define kBackViewColor          [UIColor blackColor]//[UIColor colorWithWhite:0.000 alpha:1.0f]

#import "UIImageViewZoomIn.h"

@implementation UIImageView (UIImageViewEx)

-(void)hiddenView
{
    UIView *coverView = (UIView *)[[self window] viewWithTag:kCoverViewTag];
    [coverView removeFromSuperview];
}

- (void)hiddenViewAnimation
{
    UIImageView *imageView = (UIImageView *)[[self window] viewWithTag:kImageViewTag];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration]; ////动画时长
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    
    [UIView commitAnimations];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:kAnimationDuration];
}

//自动按原UIImageView等比例调整目标rect
- (CGRect)autoFitFrame
{
    //调整为固定宽，高等比例动态变化
    float width = kImageViewWidth;
    float targetHeight = (width*self.frame.size.height)/self.frame.size.width;
    UIView *coverView = (UIView *)[[self window] viewWithTag:kCoverViewTag];
    coverView.frame = [[UIScreen mainScreen] bounds];
//    NSLog(@"coverView.frame.origin.x %f,coverView.frame.origin.y %f,coverView.frame.size.width %f,coverView.frame.size.height %f",coverView.frame.origin.x
//          , coverView.frame.origin.y, coverView.frame.size.width, coverView.frame.size.height);
//    NSLog(@"coverView.frame.size.width/2 - width/2 %f,coverView.frame.size.height/2 - targetHeight/2 %f",coverView.frame.size.width/2 - width/2, coverView.frame.size.height/2 - targetHeight/2);
    CGRect targetRect = CGRectMake(coverView.frame.size.width/2 - width/2,coverView.frame.size.height/2 - targetHeight/2, width, targetHeight);
    return  targetRect;
}

-(void)imageTab{
    [CmmobiAndUmengClick event:Friends_album_User_avatar]; //埋点
    UIView *coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    NSLog(@"coverView.frame.origin.x %f,coverView.frame.origin.y %f,coverView.frame.size.width %f,coverView.frame.size.height %f",coverView.frame.origin.x
//          , coverView.frame.origin.y, coverView.frame.size.width, coverView.frame.size.height);
    coverView.backgroundColor = kBackViewColor;
    coverView.tag = kCoverViewTag;
    UITapGestureRecognizer *hiddenViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenViewAnimation)];
    [coverView addGestureRecognizer:hiddenViewRecognizer];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.tag = kImageViewTag;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = self.contentMode;
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    
    [coverView addSubview:imageView];
    [[self window] addSubview:coverView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    imageView.frame = [self autoFitFrame];
    [UIView commitAnimations];
}

-(void)addDetailShow
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tabGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTab)];
    [self addGestureRecognizer:tabGestureRecognizer];
}

@end
