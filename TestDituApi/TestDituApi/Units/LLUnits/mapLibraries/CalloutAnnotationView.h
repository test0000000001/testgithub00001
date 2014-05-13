//
//  CalloutAnnotationView.h
//  VideoShare
//
//  Created by dongsheng xu on 12-12-13.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CallOutAnnotationView : MKAnnotationView{
    BOOL _isUserLocationAnn;
}

@property (nonatomic,retain)UIView *contentView;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier isUserLocationAnn:(BOOL)isUserLocationAnn calloutWidth:(CGFloat)calloutWidth calloutHeight:(CGFloat)calloutHeight;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier isUserLocationAnn:(BOOL)isUserLocationAnn;
@end
