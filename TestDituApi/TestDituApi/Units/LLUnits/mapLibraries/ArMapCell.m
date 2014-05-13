//
//  ArMapCell.m
//  VideoShare
//
//  Created by dongsheng xu on 12-12-13.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "ArMapCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"

@implementation ArMapCell

@synthesize imageView=_imageView;
@synthesize contentLabel = _contentLabel;
@synthesize nicknameLabel=_nicknameLabel;
@synthesize sexView=_sexView;
@synthesize videoUploadTime=_videoUploadTime;
@synthesize textContentView=_textContentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        backgroundImageView.image = [Tools createImageWithColor:[UIColor clearColor]];
        [self addSubview:backgroundImageView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        _imageView.layer.cornerRadius = 2.0;
        [self addSubview:_imageView];
        
        self.bofangImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3_diaryDetails_play_1"]];
        // bofangImageView.frame = CGRectMake(0, 0, 22, 26);
        self.bofangImageView.contentMode = UIViewContentModeCenter;
        [self.imageView addSubview:self.bofangImageView];
        self.bofangImageView.hidden = YES;
        
        self.textContentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.textContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textContentView];
        
        self.nicknameLabel = [[FXLabel alloc] initWithFrame:CGRectZero];
        //self.nicknameLabel.font = [UIFont systemFontOfSize:11];
        self.nicknameLabel.textAlignment = UITextAlignmentLeft;
        self.nicknameLabel.backgroundColor = [UIColor redColor];
        self.nicknameLabel.textColor = [UIColor whiteColor];
        [self.textContentView addSubview:self.nicknameLabel];
        
        UIFont *labelFont = [UIFont boldSystemFontOfSize:15];
        [Tools setFXLabelShadowText:self.nicknameLabel labelText:@"" labelFont:labelFont];
        
        self.sexView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.textContentView addSubview:self.sexView];
        
        self.videoUploadTime = [[UILabel alloc] initWithFrame:CGRectZero];
        self.videoUploadTime.font = [UIFont systemFontOfSize:11];
        self.videoUploadTime.textAlignment = UITextAlignmentLeft;
        self.videoUploadTime.backgroundColor = [UIColor clearColor];
        self.videoUploadTime.textColor = [UIColor whiteColor];
        [self.textContentView addSubview:self.videoUploadTime];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:11];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = UITextAlignmentLeft;
        [_contentLabel setTextColor:HEXCOLOR(0xA0A0A0)];
        _contentLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.textContentView addSubview:_contentLabel];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    backgroundImageView.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height);
    _imageView.frame = CGRectMake(4,7,75,75);
    
    self.bofangImageView.frame = CGRectMake((_imageView.frame.size.width - 22)/2, (_imageView.frame.size.height - 26)/2, 22, 26);
    
    self.textContentView.frame = CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width + 9, 0, self.frame.size.width - _imageView.frame.size.width - 9, self.frame.size.height - 15);
    
    CGSize nicknameLabelSize = CGSizeZero;
    nicknameLabelSize = [_nicknameLabel.text sizeWithFont:_nicknameLabel.font constrainedToSize:CGSizeMake(110, INT_MAX) lineBreakMode:_nicknameLabel.lineBreakMode];
    
    CGSize videoUploadTimeLabelSize = CGSizeZero;
    videoUploadTimeLabelSize = [_videoUploadTime.text sizeWithFont:_videoUploadTime.font constrainedToSize:CGSizeMake(self.bounds.size.width-16, INT_MAX) lineBreakMode:_videoUploadTime.lineBreakMode];
    
    self.nicknameLabel.frame   = CGRectMake(2, 0, nicknameLabelSize.width, 36);
    self.sexView.frame  = CGRectMake(self.nicknameLabel.frame.origin.x + self.nicknameLabel.frame.size.width + 8, 12, 11, 14);
    self.videoUploadTime.frame = CGRectMake(self.textContentView.frame.size.width - 9 - videoUploadTimeLabelSize.width, 12, MIN(videoUploadTimeLabelSize.width, self.textContentView.frame.size.width - self.nicknameLabel.frame.size.width - self.sexView.frame.size.width - 9),videoUploadTimeLabelSize.height);

    UIView* textImageView = [self viewWithTag:222];
    if (textImageView) {
        textImageView.frame = CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width + 2, self.sexView.frame.origin.y + self.sexView.frame.size.height + 2,self.textContentView.frame.size.width,MIN(textImageView.frame.size.height,self.textContentView.frame.size.height - self.sexView.frame.size.height - 6));
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
