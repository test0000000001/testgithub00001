//
//  APP_PositionModel.h
//  VideoShare
//
//  Created by qin on 13-5-29.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APP_PositionModel : NSObject
{
    NSString* _position;
    NSString* _citycode;  //城市编码
    NSString* _latitude;
    NSString* _longitude;
    NSString* _myhorizontalAccuracy;
    NSMutableArray*  _aroundBuinessList; //商圈列表
}

@property(nonatomic,strong)NSString* citycode;
@property(nonatomic,strong)NSString* position;
@property(nonatomic,strong)NSString* latitude;
@property(nonatomic,strong)NSString* longitude;
@property(nonatomic,strong)NSString* myhorizontalAccuracy;
@property(nonatomic,strong)NSMutableArray*  aroundBuinessList;
-(void)clean;
@end
