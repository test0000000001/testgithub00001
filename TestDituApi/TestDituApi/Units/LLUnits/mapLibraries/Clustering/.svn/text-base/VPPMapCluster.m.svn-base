//
//  VPPMapCluster.m
//  VideoShare
//
//  Created by xudongsheng on 12-11-20.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//
#import "VPPMapCluster.h"

#define kAnnotationsNumber @"%d annotations"

@implementation VPPMapCluster
@synthesize diaryData=_diaryData;
@synthesize annotations=_annotations;
@synthesize containTopVisibleItem=_containTopVisibleItem;
@synthesize containCurrentLocation=_containCurrentLocation;

- (VPPMapCluster *) init {
    if (self = [super init]) {
        self.annotations = [NSMutableArray array];
    }
    
    return self;
}

- (void) dealloc {
    self.annotations = nil;
    [super dealloc];
}
// optional
- (NSString *)subtitle
{
    return @"subtitle";
}

- (NSString *) title {
   // return [NSString stringWithFormat:kAnnotationsNumber,[self.annotations count]];
    return @"";
}

- (CLLocationCoordinate2D) coordinate {
    float lat = 0;
    float lon = 0;
    
    for (id<MKAnnotation> ann in self.annotations) {
        lat += ann.coordinate.latitude;
        lon += ann.coordinate.longitude;
    }
    return CLLocationCoordinate2DMake(lat/[self.annotations count], lon/[self.annotations count]);
}

-(CLLocationDegrees)latitude{
    float lat = 0;
    
    for (id<MKAnnotation> ann in self.annotations) {
        lat += ann.coordinate.latitude;
    }
    return  lat/[self.annotations count];
}

-(CLLocationDegrees)longitude{
    float lon = 0;
    
    for (id<MKAnnotation> ann in self.annotations) {
        lon += ann.coordinate.longitude;
    }
    return  lon/[self.annotations count];
}

@end
