//
//  ArMapBodyView.h 地图模式视图组件
//  VideoShare
//
//  Created by dongsheng xu on 12-12-6.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VPPMapHelper.h"
#import "Global.h"


@interface ArMapBodyView : UIView

@property (nonatomic, strong) UINavigationController *mycollectionNC;
@property(nonatomic, assign)  MAP_STYLE mapStyle;
@property(nonatomic, strong) NSMutableArray *diaryArray;
@property(nonatomic, strong)  NSMutableArray *mapAnnotations;
@property(nonatomic, strong)  NSString *userLocationLatitude; //用户所在位置维度
@property(nonatomic, strong)  NSString *userLocationLongitude;//用户所在位置经度

- (id)initWithFrame:(CGRect)frame mapStyle:(MAP_STYLE)mapStyle;
-(void)refreshBodyView:(NSMutableArray*)diaryArray;
-(void)setCurrentUserLocation:(NSString*)currentLatitude currentLongitude:(NSString*)currentLongitude userPosition:(NSString*)userPosition;

-(void)updateOpenedModelPanel;

@end
