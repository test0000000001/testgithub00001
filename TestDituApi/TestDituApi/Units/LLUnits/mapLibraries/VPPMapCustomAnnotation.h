//
//  VPPMapCustomAnnotation.h
//  VideoShare
//
//  Created by dongsheng xu on 12-12-14.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DiaryData.h"

/** This protocol can be used to customize an annotation.
 
 VPPMapHelper will detect if a MKAnnotation conforms to VPPMapCustomAnnotation
 protocol, and in that case would read its customization. */

@protocol VPPMapCustomAnnotation <MKAnnotation>

@required
@property (nonatomic, retain) DiaryData* diaryData;

@end

