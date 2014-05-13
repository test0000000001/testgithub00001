//
//  MBProgressSyncMidView.m
//  VideoShare
//
//  Created by zc on 13-7-29.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "MBProgressSyncMidView.h"

@implementation MBProgressSyncMidView
@synthesize deleage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {// Initialization code
        
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    [deleage midViewtouched];
    return nil;
}

@end
