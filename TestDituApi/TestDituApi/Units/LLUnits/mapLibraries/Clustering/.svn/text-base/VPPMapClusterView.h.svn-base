//
//  VPPMapClusterView.h
//  VideoShare
//
//  Created by xu dongsheng on 13-2-21.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef  enum {
    ANNOTATION_RED,
    ANNOTATION_BLUE,
    ANNOTATION_STAR,
} ANNOTATION_STYLE;

@interface VPPMapClusterView : MKAnnotationView {
@private
    UILabel *_label;
}

@property (nonatomic, retain) NSString *title;

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier annStyle:(ANNOTATION_STYLE)annStyle;
- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;


@end
