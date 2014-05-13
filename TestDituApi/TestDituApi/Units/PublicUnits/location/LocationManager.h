//
//  LocationManager.h
//  VideoShare
//
//  Created by zhongchuan on 12-8-30.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import "BMapKit.h"
//#define APP_BAIDUSEARCH		[LocationManager defaultLM].search

#define GRAB_POS_TO_STREET_LEVEL @"grab_pos_to_street_level"
/**
 isSuccess  是否成功获取经纬度
 */
typedef   void (^DidGpsBlock)(BOOL isSuccess,double latitude,double longitude, double horizontalAccuracy);

@interface LocationManager : NSObject

//@property (nonatomic,strong) BMKSearch* search;
@property (nonatomic,strong) DidGpsBlock gpsBlock;
@property (nonatomic,strong) NSString* param;
@property (nonatomic, assign) BOOL locationSuccess;
+(LocationManager *)defaultLM;
-(id)init;
-(void)start:(void (^)(BOOL isSuccess,double latitude,double longitude, double horizontalAccuracy))mygpsblock;
-(void)startWithOneOuterParam:(NSString*)param block:(void (^)(BOOL isSuccess,double latitude,double longitude, double horizontalAccuracy))mygpsblock;
-(void)stop;
//-(void)geocoding;
/**
 isSuccess  是否翻转地址
 */
-(void)geocoding:(NSString*)latitudeLongitude block:(void(^)(BOOL isSuccess, NSString* postion, NSMutableArray* businessArray))block;
//add by xudongsheng
-(void)geocoding:(NSString*)currentLatitude currentLongitude:(NSString*)currentLongitude block:(void(^)(BOOL isSuccess, NSString* postion, NSMutableArray* businessArray))block;

//单例销毁
-(void)attemptDealloc;
@end
