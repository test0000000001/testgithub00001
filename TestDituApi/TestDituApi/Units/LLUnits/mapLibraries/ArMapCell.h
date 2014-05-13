//
//  ArMapCell.h
//  VideoShare
//
//  Created by dongsheng xu on 12-12-13.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"

@interface ArMapCell : UIView{

    UIImageView *backgroundImageView;
}

@property (strong, nonatomic) UIImageView* imageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) FXLabel *nicknameLabel;
@property (nonatomic, strong) UIImageView* sexView;
@property (nonatomic, strong) UILabel *videoUploadTime;
@property (nonatomic, strong) UIView  *textContentView;
@property (nonatomic, strong)UIImageView* bofangImageView;

@end
