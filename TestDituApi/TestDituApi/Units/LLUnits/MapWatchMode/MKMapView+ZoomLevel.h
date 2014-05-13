//
//  MKMapView+ZoomLevel.h
//  VideoShare
//
//  Created by xu dongsheng on 13-6-9.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (int) getZoomLevel;

@end
