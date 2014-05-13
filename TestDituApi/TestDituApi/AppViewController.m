//
//  AppViewController.m
//  TestDituApi
//
//  Created by capry on 13-8-26.
//  Copyright (c) 2013年 capry. All rights reserved.
//

#import "AppViewController.h"
#import "HttpRequest.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AdSupport/AdSupport.h>

//百度翻转地址URL
#define BAIDUGEOCODING_URL @"http://api.map.baidu.com/geocoder"
//百度搜索URL
#define BAIDU_PLACE_SEARCH_URL @"http://api.map.baidu.com/place/search"

@interface AppViewController ()

@end

@implementation AppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
	// Do any additional setup after loading the view.
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    __block BOOL isGettingResult = YES;
    CLLocationDegrees centerLatitude = self.mapView.region.center.latitude;
    CLLocationDegrees centerLongitude = self.mapView.region.center.longitude;
    NSString* currentLatitude = [[NSString alloc] initWithFormat:@"%f",centerLatitude];
    NSString* currentLongitude = [[NSString alloc] initWithFormat:@"%f",centerLongitude];
    self.longitudeLabel.text = currentLongitude;
    self.latitudeLabel.text  = currentLatitude;
    
    [self geocoding:currentLatitude currentLongitude:currentLongitude block:^(BOOL isSuccess, NSString *postion, NSMutableArray *businessArray)
     {
         if (isSuccess)
         {
             if (postion.length > 0 && isGettingResult)
             {
                 isGettingResult = NO;
                 self.resultFromLabel.text = @"百度";
                 self.resultLabel.text = postion;
             }
         }
     }];
    
    [self googleCoding:currentLatitude currentLongitude:currentLongitude block:^(BOOL isSuccess, NSString *position)
     {
         if (isSuccess)
         {
             if (position.length > 0 && isGettingResult)
             {
                 isGettingResult = NO;
                 self.resultFromLabel.text = @"Google";
                 self.resultLabel.text = position;
             }
         }
     }];

}

//- (void) googleCoding:(CLLocationDegrees )currentLatitude currentLongitude:(CLLocationDegrees )currentLongitude block:(void(^)(BOOL isSuccess, NSString *position)) block
//{
//    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:currentLatitude longitude:currentLongitude];
//    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
//    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
//    {
//        for (CLPlacemark * placeMark in placemarks)
//        {
//            block(YES, placeMark.name);
//        }
//    };
//    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
//    [clGeoCoder release];
//    //    [manager stopUpdatingLocation];
//}

- (void) googleCoding:(NSString *)currentLatitude currentLongitude:(NSString *)currentLongitude block:(void(^)(BOOL isSuccess, NSString *position)) block
{
    //    [manager stopUpdatingLocation];
    
    NSString *params = [[NSString alloc] initWithFormat:@"latlng=%@,%@&language=zh-CN&sensor=false",currentLatitude, currentLongitude];

    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",@"http://maps.google.com/maps/api/geocode/json?",params];
    [HttpRequest postWithAutoLoginUrl:url
                                param:[NSDictionary dictionaryWithObjectsAndKeys:nil] mainBlock:^(NSDictionary *returnDict) {
                                    BOOL isSuccess = NO;
                                    NSString* position = @"";
                                    NSMutableArray* aroundBusinessArray = [NSMutableArray new];
                                    if ([[returnDict objectForKey:@"status"] isEqualToString:@"OK"]) {
                                        isSuccess = YES;
                                        NSMutableArray *resultsArray = [returnDict objectForKey:@"results"];
                                        NSMutableDictionary *resultAtO = [resultsArray objectAtIndex:0];
                                        position = [resultAtO objectForKey:@"formatted_address"];
                                    }else {
                                        isSuccess = NO;
                                        position = @"";
                                        NSLog(@"百度HTTP请求逆地址解析失败");
                                    }
                                    block(isSuccess, position);
                                }];

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
