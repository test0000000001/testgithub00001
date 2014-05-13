//
//  VPPMapClusterHelper.h
//  VideoShare
//
//  Created by xudongsheng on 12-11-20.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VPPMapClusterHelper : NSObject

@property (nonatomic, retain) MKMapView *mapView;

- (VPPMapClusterHelper *) initWithMapView:(MKMapView*)mapView;

- (void) clustersForAnnotations:(NSArray*)annotations distance:(float)distance completion:(void (^)(NSArray *data))block;

    
@end
