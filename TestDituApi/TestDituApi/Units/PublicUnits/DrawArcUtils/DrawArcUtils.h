//
//  DrawArcUtils.h
//  VideoShare
//
//  Created by dongsheng xu on 12-11-30.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BMapKit.h"
#import <MapKit/MapKit.h>

@interface DrawArcUtils : NSObject

//根据传入的弧线起点跟终点，得到弧线需要的一组填充点数组
+(NSMutableArray*)acquireArcFillPoints:(CGPoint)pt1 arcEndPoint:(CGPoint)pt2 referedMapView:(MKMapView*)referedMapView;
//由弧上两点a,b 和半径求原点坐标
+(CGPoint)getCirleCenter:(CGPoint)p1 arcEndPoint:(CGPoint)p2 dRadius:(double)dRadius;
//由弧上一点x坐标获取y坐标
+(CGFloat)getCirclePointCoordinateY:(double)dRadius center:(CGPoint)center coordinateX:(CGFloat)coordinateX minFlag:(BOOL)minFlag;
//由弧上一点y坐标获取x坐标
+(CGFloat)getCirclePointCoordinateX:(double)dRadius center:(CGPoint)center coordinateY:(CGFloat)coordinateY;

+(CLLocation*)convertToCLLocation:(double)tempCoordinateX tempCoordinateY:(double)tempCoordinateY referedMapView:(MKMapView*)referedMapView;
@end
