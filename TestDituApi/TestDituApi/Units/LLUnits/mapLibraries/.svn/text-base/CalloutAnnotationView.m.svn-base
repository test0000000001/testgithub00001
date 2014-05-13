//
//  CalloutAnnotationView.m
//  VideoShare
//
//  Created by dongsheng xu on 12-12-13.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "CallOutAnnotationView.h"
#import <QuartzCore/QuartzCore.h>


#define  Arror_height 10

@interface CallOutAnnotationView ()

-(void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;
@end

@implementation CallOutAnnotationView
@synthesize contentView;

- (void)dealloc
{
    self.contentView = nil;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier isUserLocationAnn:(BOOL)isUserLocationAnn calloutWidth:(CGFloat)calloutWidth calloutHeight:(CGFloat)calloutHeight{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        _isUserLocationAnn = isUserLocationAnn;
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, 0 - calloutHeight/2 - 20); // -39
        self.frame = CGRectMake(0, 0, calloutWidth, calloutHeight);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arror_height)];
        _contentView.backgroundColor   = [UIColor clearColor];
        [self addSubview:_contentView];
        self.contentView = _contentView;
    }
    return self;

}


- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier isUserLocationAnn:(BOOL)isUserLocationAnn
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        _isUserLocationAnn = isUserLocationAnn;
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        //self.centerOffset = CGPointMake(0, -76); // -55
        if(isUserLocationAnn){
           self.centerOffset = CGPointMake(0, -50); // -57
        }else{
           self.centerOffset = CGPointMake(0, -60); // -57
        }
        self.frame = CGRectMake(0, 0, 240, 80);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arror_height)];
        _contentView.backgroundColor   = [UIColor clearColor];
        [self addSubview:_contentView];
        self.contentView = _contentView;
        
    }
    return self;
}


//- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.canShowCallout = NO;
//        //self.centerOffset = CGPointMake(0, -76); // -55
//        self.centerOffset = CGPointMake(0, -57); // -55
//        self.frame = CGRectMake(0, 0, 240, 80);
//        
//        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arror_height)];
//        _contentView.backgroundColor   = [UIColor clearColor];
//        [self addSubview:_contentView];
//        self.contentView = _contentView;
//        
//    }
//    return self;
//}

-(void)drawInContext:(CGContextRef)context
{
	
    CGContextSetLineWidth(context, 2.0);
    if(_isUserLocationAnn){
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.4f); // translucent white
    }else{
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0 alpha:0.8].CGColor);
    }
    // Draw background
   // CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
   // CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.4f); // translucent white
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
	CGFloat radius = 6.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect), 
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), 
    // midy = CGRectGetMidY(rrect), 
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height + 1, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height - 1, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
    
    //self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowColor = [[UIColor clearColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}
@end

