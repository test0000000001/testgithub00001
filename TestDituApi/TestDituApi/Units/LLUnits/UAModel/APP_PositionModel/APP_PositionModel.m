//
//  APP_PositionModel.m
//  VideoShare
//
//  Created by qin on 13-5-29.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "APP_PositionModel.h"

@implementation APP_PositionModel

@synthesize position = _position;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize citycode = _citycode;
@synthesize aroundBuinessList = _aroundBuinessList;
@synthesize myhorizontalAccuracy = _myhorizontalAccuracy;
-(id)init
{
    if(self = [super init])
    {
        self.position = @"";
        self.latitude = @"";
        self.longitude = @"";
        self.citycode = @"";
        self.myhorizontalAccuracy = @"";
        self.aroundBuinessList = [NSMutableArray new];
    }
    return self;
}

-(void)clean
{
    self.position = @"";
    self.latitude = @"";
    self.longitude = @"";
    self.citycode = @"";
    self.myhorizontalAccuracy = @"";
    if(self.aroundBuinessList){
        [self.aroundBuinessList removeAllObjects];
    }
}
@end
