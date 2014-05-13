//
//  ArAnnotation.h
//  VideoShare
//
//  Created by dongsheng xu on 12-11-30.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPPMapCustomAnnotation.h"

@interface ArAnnotation : NSObject <VPPMapCustomAnnotation>
{
    CLLocationCoordinate2D _coordinate;     
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;     
- (id)initWithLocation:(CLLocationCoordinate2D)coord;  
- (id)initWithLocation:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) BOOL isVisibleTop;
@end
