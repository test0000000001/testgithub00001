//
//  ArAnnotation.m
//  VideoShare
//
//  Created by dongsheng xu on 12-11-30.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "ArAnnotation.h"
//#import "BMapKit.h"

@implementation ArAnnotation 

@synthesize diaryData=_diaryData;
@synthesize coordinate=_coordinate;
@synthesize index = _index;
@synthesize isVisibleTop=_isVisibleTop;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {     
    self = [super init];     
    if (self) {     
        _coordinate = coord;
         _isVisibleTop = NO;
    }     
    return self;     
}    

- (id)initWithLocation:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude{     
    self = [super init];     
    if (self) {     
        CLLocationCoordinate2D coords;
        coords.latitude = latitude;
        coords.longitude = longtitude;
        _coordinate = coords;
        _isVisibleTop = NO;
    }     
    return self;     
}  

- (NSString *)title
{
    return @"title";
}

// optional
- (NSString *)subtitle
{
    return @"subtitle";
}
@end
