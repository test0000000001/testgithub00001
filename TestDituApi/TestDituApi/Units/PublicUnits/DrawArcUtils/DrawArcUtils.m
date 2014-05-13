//
//  DrawArcUtils.m
//  VideoShare
//
//  Created by dongsheng xu on 12-11-30.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "DrawArcUtils.h"
//#import "BMapKit.h"
#import "Tools.h"

@implementation DrawArcUtils

+(CLLocation*)convertToCLLocation:(double)tempCoordinateX tempCoordinateY:(double)tempCoordinateY referedMapView:(MKMapView*)referedMapView{
    UIImageView* referedImageView=[[UIImageView alloc] initWithFrame:referedMapView.frame];
    CGPoint point;
    point.x = tempCoordinateX;
    point.y = tempCoordinateY;
    CLLocationCoordinate2D locationPoint =[referedMapView convertPoint:point toCoordinateFromView:referedImageView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locationPoint.latitude longitude:locationPoint.longitude];
    return location;
}

+(NSMutableArray*)acquireArcFillPoints:(CGPoint)pt1 arcEndPoint:(CGPoint)pt2 referedMapView:(MKMapView*)referedMapView{
    UIImageView* referedImageView=[[UIImageView alloc] initWithFrame:referedMapView.frame];
    NSMutableArray* fillPointArray = [[NSMutableArray alloc]initWithCapacity:10];
    //两点相同
    if(pt1.x == pt2.x && pt1.y == pt2.y){
        CLLocationCoordinate2D endPointCoord =[referedMapView convertPoint:pt2 toCoordinateFromView:referedImageView];
        CLLocation *endPointLocation = [[CLLocation alloc] initWithLatitude:endPointCoord.latitude longitude:endPointCoord.longitude];
        [fillPointArray insertObject:endPointLocation atIndex:[fillPointArray count]];
        return fillPointArray;
    }
    CGFloat vx =pt2.x-pt1.x;
    CGFloat vy =pt2.y-pt1.y; 
    double dLine = sqrt((double)(vx*vx+vy*vy)); //pt1,pt2之间的玄长
    double dRadius= dLine ;
    CGPoint startPoint;
    CGPoint endPoint;
    if(pt1.x < pt2.x){
        startPoint = pt1;
        endPoint = pt2;
    }else{
        startPoint = pt2;
        endPoint = pt1;
    }
    CGPoint centerPoint = [self getCirleCenter:startPoint arcEndPoint:endPoint dRadius:dRadius];
    double centerPointX = centerPoint.x;
    double centerPointY = centerPoint.y;
    int partsCountToDivide = 13;
    NSMutableArray* screenPointXArray = [[NSMutableArray alloc]initWithCapacity:10];
    NSMutableArray* screenPointYArray = [[NSMutableArray alloc]initWithCapacity:10];
    NSString* queryStr = @"";
    double degree = acos((dRadius*dRadius*2 - dLine*dLine)/(2*dRadius*dRadius));
    CGFloat tempCoordinateX;
    if(centerPointX < startPoint.x){
        if(centerPointY > endPoint.y){ //平分弧AB 13等份
            for(int i = 0; i < partsCountToDivide; i++){
                double degreeEndCenter = atan((centerPoint.y - endPoint.y)/(endPoint.x - centerPoint.x));
                double arcDegree = degree - (degree * i / partsCountToDivide) + degreeEndCenter;
                tempCoordinateX = centerPoint.x + dRadius*cos(arcDegree); 
                [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
                float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:YES];
                CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
                [fillPointArray addObject:location]; 
            }
        }else if(centerPointY >= startPoint.y && centerPointY <= endPoint.y){
            double arcStartXDegree = atan((centerPointY - startPoint.y)/(startPoint.x - centerPointX));
            double dArcDegree = degree / partsCountToDivide;
            double tempPartsCount = arcStartXDegree/dArcDegree;
            for(int i =0; i < floor(tempPartsCount);i++){
                tempCoordinateX =centerPointX + dRadius*cos(arcStartXDegree - dArcDegree*i);
                [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
                float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:YES];
                 CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
                [fillPointArray addObject:location]; 
            }
            double arcDom = dArcDegree*(1 - (tempPartsCount - floor(tempPartsCount)));
            tempCoordinateX = centerPointX + dRadius*cos(arcDom);
            [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
            float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:NO];
             CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
            [fillPointArray addObject:location];
            for(int i = 1; i < partsCountToDivide - ceil(tempPartsCount); i++){
                tempCoordinateX = centerPointX + dRadius*cos(arcDom + dArcDegree*i);
                [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
                float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:NO];
                 CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
                [fillPointArray addObject:location];
            }
            NSLog(@"screenPointXArray is:%@",screenPointXArray);
        }else{
          // centerPoint.y < startPoint.y 不成立
            NSLog(@"不成立");
        }
    }else if(centerPointX >= startPoint.x && centerPointX <= endPoint.x){
        if(centerPointY > endPoint.y){
            double dArcDegree = degree / partsCountToDivide;
            double startCenterYDegree = asin((centerPointX - startPoint.x)/dRadius);
            double startCenterXDegree = acos((centerPointX - startPoint.x)/dRadius);
            double tempPartsCount = startCenterYDegree/dArcDegree;
            for(int i = 0; i < floor(tempPartsCount);i++){
                tempCoordinateX = centerPointX - dRadius*cos(startCenterXDegree + dArcDegree*i);
                [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
                float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:YES];
                 CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
                [fillPointArray addObject:location];
            }
            double arcDom = dArcDegree*(1 - (tempPartsCount - floor(tempPartsCount)));
            tempCoordinateX = centerPointX + dRadius*cos( M_PI /2 - arcDom);
            [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
            float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:YES];
             CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
            [fillPointArray addObject:location];
            
            for(int i = 1; i < partsCountToDivide - ceil(tempPartsCount); i++){
                tempCoordinateX = centerPointX + dRadius*cos(M_PI/2 - arcDom - dArcDegree*i);
                [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
                float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:YES];
                CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
                [fillPointArray addObject:location];
            }
        }else{
            NSLog(@"不成立");
        }
    }else{
        //此时一定是 startPoint.y > endPoint.y
        if(centerPointY > startPoint.y){
            for(int i = 0; i < partsCountToDivide; i++){
                double degreeStartCenter = acos((centerPointX - startPoint.x)/dRadius);
                double dArcDegree = degree / partsCountToDivide;
                double arcDegree = degreeStartCenter + dArcDegree*i;
                tempCoordinateX = centerPoint.x - dRadius*cos(arcDegree); 
                [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
                float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:YES];
                 CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
                [fillPointArray addObject:location]; 
            }
        }else if( centerPointY >= endPoint.y && centerPointY <= startPoint.y){
            NSLog(@"centerPointY >= endPoint.y && centerPointY <= startPoint.y");
            double startCenterXDegree = acos((centerPointX - startPoint.x)/dRadius);
            double dArcDegree = degree / partsCountToDivide;
            double tempPartsCount = startCenterXDegree/dArcDegree;
            for(int i = 0; i < floor(tempPartsCount);i++){
                tempCoordinateX = centerPointX - dRadius*cos(startCenterXDegree - dArcDegree*i);
                [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
                float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:NO];
                [screenPointYArray addObject:[NSNumber numberWithDouble:tempCoordinateY]];
                CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
                [fillPointArray addObject:location];
            }
            double arcDom = dArcDegree*(1 - (tempPartsCount - floor(tempPartsCount)));
            tempCoordinateX = centerPointX - dRadius*cos(arcDom);
            [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
            float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:YES];
            [screenPointYArray addObject:[NSNumber numberWithDouble:tempCoordinateY]];
            CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
            [fillPointArray addObject:location];
            for(int i = 1; i < partsCountToDivide - ceil(tempPartsCount); i++){
                tempCoordinateX = centerPointX - dRadius*cos(arcDom + dArcDegree*i);
                [screenPointXArray addObject:[NSNumber numberWithDouble:tempCoordinateX]];
                float tempCoordinateY =  [DrawArcUtils getCirclePointCoordinateY:dRadius center:centerPoint coordinateX:tempCoordinateX minFlag:YES];
                [screenPointYArray addObject:[NSNumber numberWithDouble:tempCoordinateY]];
                 CLLocation* location = [DrawArcUtils convertToCLLocation:tempCoordinateX tempCoordinateY:tempCoordinateY referedMapView:referedMapView];
                [fillPointArray addObject:location];
            }
        }else{
           NSLog(@"不成立");
        }
    }
    CLLocationCoordinate2D endPointCoord =[referedMapView convertPoint:pt2 toCoordinateFromView:referedImageView];
    CLLocation *endPointLocation = [[CLLocation alloc] initWithLatitude:endPointCoord.latitude longitude:endPointCoord.longitude];
    [fillPointArray insertObject:endPointLocation atIndex:[fillPointArray count]];
    NSLog(@"fillPointArray1 build complete, queryStr is:%@", queryStr);
    return fillPointArray;
}

+(CGFloat)getCirclePointCoordinateY:(double)dRadius center:(CGPoint)center coordinateX:(CGFloat)coordinateX minFlag:(BOOL)minFlag{
    double temp = dRadius*dRadius - ((coordinateX - center.x)*(coordinateX - center.x));
    if(temp < 0){
        temp = 0;
    }
    CGFloat coordianteY1 = center.y - sqrt(temp);
    CGFloat coordianteY2 =  sqrt(temp) + center.y;
    if(minFlag){
        return  MIN(coordianteY1, coordianteY2);
    }
    return MAX(coordianteY1, coordianteY2);
}

+(CGFloat)getCirclePointCoordinateX:(double)dRadius center:(CGPoint)center coordinateY:(CGFloat)coordinateY{
    CGFloat coordianteX1 = center.x + (sqrt(dRadius*dRadius - (coordinateY - center.y)*(coordinateY - center.y)));
    CGFloat coordianteX2 = (sqrt(dRadius*dRadius - (coordinateY - center.y)*(coordinateY - center.y))) - center.x;
    return  MAX(coordianteX1, coordianteX2);
}


+(CGPoint)getCirleCenter:(CGPoint)p1 arcEndPoint:(CGPoint)p2 dRadius:(double)dRadius{
    double k = 0.0,k_verticle = 0.0;
	double mid_x = 0.0,mid_y = 0.0;
	double a = 1.0;
	double b = 1.0;
	double c = 1.0;
	CGPoint center1,center2;
	k = (p2.y - p1.y) / (p2.x - p1.x);
	if(k == 0)
	{
		center1.x = (p1.x + p2.x) / 2.0;
		center2.x = (p1.x + p2.x) / 2.0;
		center1.y = p1.y + sqrt(dRadius * dRadius -(p1.x - p2.x) * (p1.x - p2.x) / 4.0);
		center2.y = p2.y - sqrt(dRadius * dRadius -(p1.x - p2.x) * (p1.x - p2.x) / 4.0);
	}
	else
	{
		k_verticle = -1.0 / k;
		mid_x = (p1.x + p2.x) / 2.0;
		mid_y = (p1.y + p2.y) / 2.0;
		a = 1.0 + k_verticle * k_verticle;
		b = -2 * mid_x - k_verticle * k_verticle * (p1.x + p2.x);
		c = mid_x * mid_x + k_verticle * k_verticle * (p1.x + p2.x) * (p1.x + p2.x) / 4.0 - 
        (dRadius * dRadius - ((mid_x - p1.x) * (mid_x - p1.x) + (mid_y - p1.y) * (mid_y - p1.y)));
		
		center1.x = (-1.0 * b + sqrt(b * b -4 * a * c)) / (2 * a);
		center2.x = (-1.0 * b - sqrt(b * b -4 * a * c)) / (2 * a);
        center1.y = [self Y_Coordinates:mid_x y:mid_y k:k_verticle x0:center1.x];
        center2.y = [self Y_Coordinates:mid_x y:mid_y k:k_verticle x0:center2.x];
        //从两组值中
	}
    NSLog(@"(center1.x, center1.y) is (%f,%f)",center1.x, center1.y);
    NSLog(@"(center2.x, center2.y) is (%f,%f)",center2.x, center2.y);
    //根据直线上的两点,判断直线方向，取不同的值
    if(p1.y >= p2.y){
        return center1;
    }else if(p1.y < p2.y){
        return center2;
    }
    return  center2;
}

+(double)Y_Coordinates:(double)x y:(double)y k:(double)k x0:(double)x0{
    return k * x0 - k * x + y;
}
@end
