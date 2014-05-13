//
//  CalloutMapAnnotation.h
//  VideoShare
//
//  Created by dongsheng xu on 12-12-13.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "VPPMapCustomAnnotation.h"

@interface CalloutMapAnnotation : NSObject <VPPMapCustomAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, assign) BOOL isUserLocationAnnotation;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
