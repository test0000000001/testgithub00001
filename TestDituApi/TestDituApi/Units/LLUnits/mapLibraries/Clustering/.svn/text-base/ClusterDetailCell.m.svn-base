//
//  ClusterDetailCellCell.m
//  VideoShare
//
//  Created by dongsheng xu on 12-12-18.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "ClusterDetailCell.h"
#import "Tools.h"

#define CELL_IMAGE_VIEW_HEIGHT 75

@implementation ClusterDetailCell

@synthesize videoImageView=_videoImageView;
@synthesize contentLabel = _contentLabel;
@synthesize nicknameLabel=_nicknameLabel;
@synthesize sexView=_sexView;
@synthesize videoUploadTime=_videoUploadTime;
@synthesize textContentView=_textContentView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size
  { self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame=CGRectMake(0, 0, size.width, size.height);
        self.backgroundColor = [UIColor clearColor];
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        backgroundImageView.image = [Tools createImageWithColor:[UIColor clearColor]];
        [self addSubview:backgroundImageView];
        
        self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videoImageView.contentMode=UIViewContentModeScaleAspectFill;
        _videoImageView.clipsToBounds=YES;
        _videoImageView.userInteractionEnabled= YES;
        [backgroundImageView addSubview:_videoImageView];
        
       self.bofangImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3_diaryDetails_play_1"]];
       // bofangImageView.frame = CGRectMake(0, 0, 22, 26);
        self.bofangImageView.contentMode = UIViewContentModeCenter;
        [self.videoImageView addSubview:self.bofangImageView];
        self.bofangImageView.hidden = YES;
        
        self.textContentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.textContentView.backgroundColor = [UIColor clearColor];
        [backgroundImageView addSubview:self.textContentView];
        
        self.nicknameLabel = [[FXLabel alloc] initWithFrame:CGRectZero];
        //self.nicknameLabel.font = [UIFont systemFontOfSize:11];
        self.nicknameLabel.backgroundColor = [UIColor clearColor];
        self.nicknameLabel.textAlignment = UITextAlignmentLeft;
        self.nicknameLabel.textColor = [UIColor whiteColor];
        [self.textContentView addSubview:self.nicknameLabel];
        
        UIFont *labelFont = [UIFont boldSystemFontOfSize:15];
        [Tools setFXLabelShadowText:self.nicknameLabel labelText:@"" labelFont:labelFont];
        
        self.sexView = [[UIImageView alloc] initWithFrame:CGRectZero];

        [self.textContentView addSubview:self.sexView];
        
        self.videoUploadTime = [[UILabel alloc] initWithFrame:CGRectZero];
        self.videoUploadTime.font = [UIFont systemFontOfSize:11];
        self.videoUploadTime.textAlignment = UITextAlignmentLeft;
        self.videoUploadTime.textColor = [UIColor whiteColor];
        self.videoUploadTime.backgroundColor = [UIColor clearColor];
        [self.textContentView addSubview:self.videoUploadTime];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:11];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = UITextAlignmentLeft;
        [_contentLabel setTextColor:HEXCOLOR(0xA0A0A0)];
        
        [self.textContentView addSubview:_contentLabel];
    
        self.cellLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.cellLine.image = [UIImage imageNamed:@"3_tankuang_line"];
        self.cellLine .contentMode=UIViewContentModeScaleAspectFill;
        self.cellLine .clipsToBounds=YES;
        [backgroundImageView addSubview:self.cellLine];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    backgroundImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    _videoImageView.frame = CGRectMake(4,(backgroundImageView.frame.size.height - CELL_IMAGE_VIEW_HEIGHT)/2,CELL_IMAGE_VIEW_HEIGHT,CELL_IMAGE_VIEW_HEIGHT);
    
    self.bofangImageView.frame = CGRectMake((_videoImageView.frame.size.width - 22)/2, (_videoImageView.frame.size.height - 26)/2, 22, 26);

    self.textContentView.frame = CGRectMake(_videoImageView.frame.origin.x + _videoImageView.frame.size.width + 9, 0, self.frame.size.width - _videoImageView.frame.size.width - 9, self.frame.size.height);
    
    CGSize nicknameLabelSize = CGSizeZero;
    nicknameLabelSize = [_nicknameLabel.text sizeWithFont:_nicknameLabel.font constrainedToSize:CGSizeMake(110, INT_MAX) lineBreakMode:_nicknameLabel.lineBreakMode];
    
    CGSize videoUploadTimeLabelSize = CGSizeZero;
    videoUploadTimeLabelSize = [_videoUploadTime.text sizeWithFont:_videoUploadTime.font constrainedToSize:CGSizeMake(self.bounds.size.width-16, INT_MAX) lineBreakMode:_videoUploadTime.lineBreakMode];
    
   // self.nicknameLabel.frame   = CGRectMake(0, 0, nicknameLabelSize.width, nicknameLabelSize.height);
    self.nicknameLabel.frame =  CGRectMake(0, 0, nicknameLabelSize.width, 36);
    self.sexView.frame  = CGRectMake(self.nicknameLabel.frame.origin.x + self.nicknameLabel.frame.size.width + 8, 12, 11, 14);
    
    self.videoUploadTime.frame = CGRectMake(self.textContentView.frame.size.width - 9 - videoUploadTimeLabelSize.width, 12, MIN(videoUploadTimeLabelSize.width, self.textContentView.frame.size.width - self.nicknameLabel.frame.size.width - self.sexView.frame.size.width - 9),videoUploadTimeLabelSize.height);

    UIView* textImageView = [self viewWithTag:222];
    if (textImageView) {
        textImageView.frame = CGRectMake(_videoImageView.frame.origin.x + _videoImageView.frame.size.width + 2, self.sexView.frame.origin.y + self.sexView.frame.size.height + 10,self.textContentView.frame.size.width,MIN(textImageView.frame.size.height,self.textContentView.frame.size.height - self.sexView.frame.size.height - 6));
    }
    self.cellLine.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
