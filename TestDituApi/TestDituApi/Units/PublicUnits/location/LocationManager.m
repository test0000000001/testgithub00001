//
//  LocationManager.m
//  VideoShare
//
//  Created by zhongchuan on 12-8-30.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "LocationManager.h"

#import "HttpRequest.h"
#import "Global.h"
#import "RequestModel.h"

@interface LocationManager()<CLLocationManagerDelegate> //,BMKGeneralDelegate,BMKSearchDelegate
@property(nonatomic,strong)CLLocationManager *locManager;
//@property (nonatomic,strong) BMKMapManager* mapManager;

@end

@implementation LocationManager
@synthesize locManager=_locManager;
//@synthesize mapManager=_mapManager;
@synthesize param=_param;
//@synthesize search=_search;
@synthesize gpsBlock=_gpsBlock;
@synthesize locationSuccess = _locationSuccess;

static LocationManager *_defaultLoc;
+(LocationManager *)defaultLM
{
    
    @synchronized(_defaultLoc)
    {
        if (!_defaultLoc)
        {
            _defaultLoc=[[self alloc]init];
        }
    }
    return _defaultLoc;
}
-(id)init
{
    if (self=[super init]) {
        self.locManager = [[CLLocationManager alloc] init];
        [_locManager setDelegate:self];
        [_locManager setDesiredAccuracy:kCLLocationAccuracyBest];
        self.locManager.distanceFilter = kCLDistanceFilterNone;
//        // 要使用百度地图，请先启动BaiduMapManager
//        self.mapManager = [[BMKMapManager alloc]init];
////        BOOL ret = [_mapManager start:@"AE1B4BA76350B29E9353A5645A4507F70FFD4071" generalDelegate:self];
////        if (!ret) {
////            NSLog(@"manager start failed!");
////        }
//        self.search = [[BMKSearch alloc]init];
//        self.search.delegate= self;

    }
    return self;
}

-(void)start:(void (^)(BOOL isSuccess,double latitude,double longitude, double horizontalAccuracy))mygpsblock
{
//    BOOL ret = [_mapManager start:@"AE1B4BA76350B29E9353A5645A4507F70FFD4071" generalDelegate:self];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
    self.locationSuccess = NO;
    self.param = @"";
    _gpsBlock = mygpsblock;//^(double latitude,double longitude)
    
    
    if(self.gpsBlock !=nil && [CLLocationManager locationServicesEnabled] == NO){
        self.locationSuccess = YES;
        [self stop];
        self.gpsBlock(NO,0.0,0.0,0.0);
    }else{
        [_locManager startUpdatingLocation];
    }
}

//add by xudongsheng
-(void)startWithOneOuterParam:(NSString*)param block:(void (^)(BOOL isSuccess,double latitude,double longitude, double horizontalAccuracy))mygpsblock
{
    self.param = param;
//    BOOL ret = [_mapManager start:@"AE1B4BA76350B29E9353A5645A4507F70FFD4071" generalDelegate:self];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
    self.locationSuccess = NO;
    _gpsBlock = mygpsblock;//^(double latitude,double longitude)
    [_locManager startUpdatingLocation];
    if(self.gpsBlock !=nil && [CLLocationManager locationServicesEnabled] == NO){
        self.locationSuccess = YES;
        [self stop];
        self.gpsBlock(NO,0.0,0.0,0.0);
    }else{
        [_locManager startUpdatingLocation];
    }
}


-(void)stop
{
    [_locManager stopUpdatingLocation];
}


#pragma mark  -
///**
// *返回网络错误
// *@param iError 错误号
// */
//- (void)onGetNetworkState:(int)iError
//{
//    NSLog(@"baidu map network state error:%d",iError);
////    [self.mapManager stop];
//    [self stopAndNotification];
//}

///**
// *返回授权验证错误
// *@param iError 错误号 : BMKErrorPermissionCheckFailure 验证失败
// */
//- (void)onGetPermissionState:(int)iError
//{
//    NSLog(@"BMKErrorPermissionCheckFailure 验证失败");
////    [self.mapManager stop];
//    [self stopAndNotification];
//}
#pragma mark Location manager
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"newLocation.horizontalAccuracy%f, newLocation.verticalAccuracy%f", newLocation.horizontalAccuracy, newLocation.verticalAccuracy);
    CLLocationCoordinate2D loc = [newLocation coordinate];
    [_locManager stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(loc.latitude,loc.longitude );
    
    //[_search poiMultiSearchNearBy:[[NSArray alloc]initWithObjects:@"大", @"酒店",@"公司",@"村",@"路",@"街道",@"广场",nil] center:coordinate radius:1000 pageIndex:0];
#if (TARGET_IPHONE_SIMULATOR)
    //coordinate = (CLLocationCoordinate2D){39.912123175, 116.489531};
    coordinate = (CLLocationCoordinate2D){39.915101, 116.403981};
#endif
    
//    APP_POSITIONMODEL.latitude = [NSString stringWithFormat:@"%f", loc.latitude];
//    APP_POSITIONMODEL.longitude = [NSString stringWithFormat:@"%f", loc.longitude];
    
    //[_search poiMultiSearchNearBy:[[NSArray alloc]initWithObjects:@"大", @"酒店",@"公司",@"村",@"路",@"街道",@"广场",nil] center:coordinate radius:1000 pageIndex:0];
//    [self.search reverseGeocode:coordinate];
//    [self geocoding:[[NSString alloc] initWithFormat:@"%@,%@",APP_POSITIONMODEL.latitude, APP_POSITIONMODEL.longitude]];
    if(self.gpsBlock !=nil && self.locationSuccess == NO){
        self.locationSuccess = YES;
        [self stop];
        double horizontalAccuracy = newLocation.horizontalAccuracy;
        if(newLocation.horizontalAccuracy <= 0){
            horizontalAccuracy = 0.0;
        }
        self.gpsBlock(YES,coordinate.latitude,coordinate.longitude, horizontalAccuracy);
    }
        
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", [error description]);
//    APP_POSITIONMODEL.latitude = @"";
//    APP_POSITIONMODEL.longitude = @"";
//    APP_POSITIONMODEL.position = @"";
//    if(APP_POSITIONMODEL.aroundBuinessList){
//        [APP_POSITIONMODEL.aroundBuinessList removeAllObjects];
//    }
//    [self stopAndNotification:@"0"];
    if(self.gpsBlock !=nil && self.locationSuccess == NO){
        self.locationSuccess = YES;
        [self stop];
        self.gpsBlock(NO,0.0,0.0,0.0);
    }
        
    return;
}

//- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
//{
// 	if (error == BMKErrorOk) {
//		BMKPoiResult* result = [poiResultList objectAtIndex:0];
//		
//			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:0];
//            APP_POSITIONMODEL.position=poi.address;
//        //NSLog(@"position poiMultiSearchNearBy:%@",APP_POSITIONMODEL.position);
//	}
//    [self.mapManager stop];
//    [self stopAndNotification];
//}

//- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
//{
//    BMKPoiInfo* info =[result.poiList objectAtIndex:0];
//    APP_POSITIONMODEL.position=info.address;//result.strAddr;
//    //NSLog(@"position reverseGeocode:%@",APP_POSITIONMODEL.position);
//    [self.mapManager stop];
//    [self stopAndNotification];
//}

//http://api.map.baidu.com/geocoder?location=纬度(latitude),经度(longitude)&output=输出格式类型&key=用户密钥
-(void)geocoding:(NSString*)latitudeLongitude block:(void(^)(BOOL isSuccess, NSString* postion, NSMutableArray* businessArray))block{
    
    NSString *location = [[NSString alloc] initWithFormat:@"location=%@",latitudeLongitude];
    NSString *params = [[NSString alloc] initWithFormat:@"?%@&%@&%@",location,@"output=json",@"key=AE1B4BA76350B29E9353A5645A4507F70FFD4071"];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",BAIDUGEOCODING_URL,params];
    [HttpRequest postWithAutoLoginUrl:url
                                 param:[NSDictionary dictionaryWithObjectsAndKeys:nil] mainBlock:^(NSDictionary *returnDict) {
                                     NSLog(@"(地址解析的结果)=%@",returnDict);
                                     BOOL isSuccess = NO;
                                     NSString* position = @"";
                                     NSMutableArray* aroundBusinessArray = [NSMutableArray new];
                                     //非最后一次登录需要注销后重新登录
                                     if ([[returnDict objectForKey:@"status"] isEqualToString:@"OK"]) {
                                         if(self.param && [GRAB_POS_TO_STREET_LEVEL isEqualToString:self.param]){
                                             position = [[returnDict objectForKey:@"result"] objectForKey:@"formatted_address"];
                                             
                                             NSString* businessStr = [[[returnDict objectForKey:@"result"] objectForKey:@"business"]description];
                                             NSArray *businessArray = [businessStr componentsSeparatedByString:@","];
                                             [aroundBusinessArray removeAllObjects];
                                             for(NSString* business in businessArray){
                                                 if(business && ![@"" isEqualToString:business]){
                                                     [aroundBusinessArray addObject:business];
                                                 }
                                             }
                                             isSuccess = YES;
                                         }else{
                                             NSDictionary *addressComponentaddressComponent = [[returnDict objectForKey:@"result"] objectForKey:@"addressComponent"];
                                             NSString* city = [addressComponentaddressComponent objectForKey:@"city"];
                                             NSString* province = [addressComponentaddressComponent objectForKey:@"province"];
                                             NSString* district = [addressComponentaddressComponent objectForKey:@"district"];
                                             if([city isEqualToString:province]){
                                                 position = [[NSString alloc] initWithFormat:@"%@%@",city,district];
                                             }else{
                                                 //地区 省市
                                                 position = [[NSString alloc] initWithFormat:@"%@%@",province,city]; //%@,district
                                             }
                                             NSString* businessStr = [[[returnDict objectForKey:@"result"] objectForKey:@"business"]description];
                                             NSArray *businessArray = [businessStr componentsSeparatedByString:@","];
                                             [aroundBusinessArray removeAllObjects];
                                             for(NSString* business in businessArray){
                                                 if(business && ![@"" isEqualToString:business]){
                                                    [aroundBusinessArray addObject:business];
                                                 }
                                             }
                                             isSuccess = YES;
                                         }
                                     }else {
                                         //[[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:@"网络不给力!"];
                                         position = @"";
                                         [aroundBusinessArray removeAllObjects];
                                         NSLog(@"百度HTTP请求逆地址解析失败");
                                     }
                                     block(isSuccess, position, aroundBusinessArray);
//                                     [self stopAndNotification:@"1"];
                                     NSLog(@"position is %@",position);
                                 }];

}

/** islocationsuccess : 1 定位成功  0:失败*/
-(void) stopAndNotification:(NSString*)islocationsuccess
{
    [self stop];
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"locationsuccess",nil];
//    if(self.param && ![@"" isEqualToString:self.param]){
//        [userInfo setValue:self.param forKey:@"param"];
//    }
    [userInfo setValue:islocationsuccess forKey:@"islocationsuccess"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationsuccess" object:self userInfo:userInfo];
    if(self.param){
        self.param = nil;
    }
}

-(void)geocoding:(NSString*)currentLatitude currentLongitude:(NSString*)currentLongitude block:(void(^)(BOOL isSuccess, NSString* postion, NSMutableArray* businessArray))block{
    NSString* latitudeLongitudeStr = [[NSString alloc] initWithFormat:@"%@,%@",currentLatitude, currentLongitude];
    NSString *location = [[NSString alloc] initWithFormat:@"location=%@",latitudeLongitudeStr];
    NSString *params = [[NSString alloc] initWithFormat:@"?%@&%@&%@",location,@"output=json",@"key=AE1B4BA76350B29E9353A5645A4507F70FFD4071"];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",BAIDUGEOCODING_URL,params];
    [HttpRequest postWithAutoLoginUrl:url
                                param:[NSDictionary dictionaryWithObjectsAndKeys:nil] mainBlock:^(NSDictionary *returnDict) {
                                    BOOL isSuccess = NO;
                                    NSString* position = @"";
                                    NSMutableArray* aroundBusinessArray = [NSMutableArray new];
                                    if ([[returnDict objectForKey:@"status"] isEqualToString:@"OK"]) {
                                        isSuccess = YES;
                                        position = [[returnDict objectForKey:@"result"] objectForKey:@"formatted_address"];
                                        NSString* businessStr = [[[returnDict objectForKey:@"result"] objectForKey:@"business"]description];
                                        NSArray *businessArray = [businessStr componentsSeparatedByString:@","];
                                        for(NSString* business in businessArray){
                                            if(business && ![@"" isEqualToString:business]){
                                                [aroundBusinessArray addObject:business];
                                            }
                                        }
                                        if(position && ![@"" isEqualToString:position]){
                                            [aroundBusinessArray insertObject:position atIndex:0];
                                        }
                                    }else {
                                        isSuccess = NO;
                                        position = @"";
                                        NSLog(@"百度HTTP请求逆地址解析失败");
                                    }
                                    block(isSuccess, position, aroundBusinessArray);
                                }];
      }



//单例销毁
-(void)attemptDealloc
{
    _defaultLoc = nil;
}
@end
