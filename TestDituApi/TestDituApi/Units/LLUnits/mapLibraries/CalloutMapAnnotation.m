//
//  CalloutMapAnnotation.m
//  VideoShare
//
//  Created by dongsheng xu on 12-12-13.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation()


@end

@implementation CalloutMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize isUserLocationAnnotation=_isUserLocationAnnotation;
@synthesize diaryData=_diaryData;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.isUserLocationAnnotation = NO;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

@end

