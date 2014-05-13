//
//  ArMapBodyView.m
//  VideoShare
//
//  Created by dongsheng xu on 12-12-6.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "ArMapBodyView.h"
#import "ImageCacheManager.h"
#import "ArAnnotation.h"
#import "ToolsUnite.h"
#import "Tools.h"
#import "HttpRequest.h"
#import "DrawArcUtils.h"
#import "CustomAnnotationView.h"
#import "ArMapCell.h"
#import "CallOutAnnotationView.h"
#import "ArData.h"

#define MERCATOR_RADIUS 85445659.44705395 

@interface ArMapBodyView()

@property(nonatomic,strong)UIButton* resetMapViewportBtn;
@property(nonatomic, strong) MKMapView *arMapView;
@property(nonatomic, strong) VPPMapHelper *mh;
@end

@implementation ArMapBodyView

- (id)initWithFrame:(CGRect)frame mapStyle:(MAP_STYLE)mapStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mapStyle = mapStyle;
        [self initMapViewByParentSize];
        self.diaryArray = [NSMutableArray array];
        if(mapStyle == MAP_STYLE_WITH_MYLOCATION){ //附近数据
            [self initResetMapViewportBtn];
        }else if(mapStyle == MAP_STYLE_WITHOUT_MYLOCATION){//日记页数据,推荐
            
        }
        [self initVPPMapHelper];
    }
    return self;
}

-(void)resetMapViewPortByCurrentPos:(id)sender{
    [CmmobiAndUmengClick event:NEAR_MY_POSITION_BUTTON]; //埋点
    //在地图上用大头针标记出自己的位置
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.userLocationLatitude doubleValue], [self.userLocationLongitude doubleValue]);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(self.arMapView.region.span.latitudeDelta, self.arMapView.region.span.longitudeDelta));
    [self.arMapView setRegion:region animated:YES];
}

-(void)initResetMapViewportBtn{
    self.resetMapViewportBtn = [[UIButton alloc]initWithFrame:CGRectMake(13 , self.frame.size.height - 40 - 20 - 46 + 45, 50, 40)];
    [self.resetMapViewportBtn setImage:[UIImage imageNamed:@"3_guiwei_1"] forState:UIControlStateNormal];
    [self.resetMapViewportBtn setImage:[UIImage imageNamed:@"3_guiwei_2"] forState:UIControlStateHighlighted];
    [self.resetMapViewportBtn setImage:[UIImage imageNamed:@"3_guiwei_2"] forState:UIControlStateSelected];
    [self.resetMapViewportBtn addTarget:self action:@selector(resetMapViewPortByCurrentPos:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.resetMapViewportBtn];
}

-(void)initMapViewByParentSize{
    self.arMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.arMapView.mapType = MKMapTypeStandard;
    self.arMapView.showsUserLocation = NO;
    [self.arMapView setZoomEnabled:YES];
    [self.arMapView setScrollEnabled:YES];
    self.arMapView.userInteractionEnabled = YES;
    [self addSubview:self.arMapView];
    //增加阴影效果
    //[self addShadowEffect];
}

-(void)setCurrentUserLocation:(NSString*)currentLatitude currentLongitude:(NSString*)currentLongitude userPosition:(NSString*)userPosition{
    if([Tools locationIsValid:currentLatitude longitudeStr:currentLongitude]){
        self.userLocationLatitude = currentLatitude;
        self.userLocationLongitude = currentLongitude;
        _mh.userLocationLatitude = currentLatitude;
        _mh.userLocationLongitude = currentLongitude;
        _mh.userPosition = userPosition;
    }
}

-(void)initVPPMapHelper{
  	// sets up the map
	_mh = [VPPMapHelper VPPMapHelperForMapView:self.arMapView 
                            pinAnnotationColor:MKPinAnnotationColorGreen 
                         centersOnUserLocation:NO
                         showsDisclosureButton:NO];
    _mh.mapStyle = self.mapStyle;
	_mh.userCanDropPin = YES;
    _mh.shouldClusterPins=YES;
	_mh.allowMultipleUserPins = YES;
}

-(void)refreshBodyView:(NSMutableArray*)diaryArray{
    if(self.diaryArray && [self.diaryArray count] > 0){
        [self.diaryArray removeAllObjects];
    }
    if(diaryArray && [diaryArray count] > 0){
        //进行过滤去掉没有经纬度的
        for(DiaryData* diaryData in diaryArray){
            if([Tools locationIsValid:diaryData.d_latitude longitudeStr:diaryData.d_longitude]){
                [self.diaryArray addObject:diaryData];
            }
        }
    }
  //  if(self.diaryArray && [self.diaryArray count] > 0){
        [self updateAnnotationsWithAllDiarysOnMap:self.diaryArray];
   // }
}

-(void)addShadowEffect{
    UIImageView* topShadow = [[UIImageView alloc] initWithFrame:CGRectMake(self.arMapView.frame.origin.x, self.arMapView.frame.origin.y ,self.arMapView.frame.size.width, 12)];
    topShadow.image = [UIImage imageNamed:@"map_shang"];
    topShadow.clipsToBounds=YES;
    [self addSubview:topShadow];
    
    UIImageView* leftShadow = [[UIImageView alloc] initWithFrame:CGRectMake(self.arMapView.frame.origin.x, self.arMapView.frame.origin.y ,5, self.arMapView.frame.size.height)];
    leftShadow.image = [UIImage imageNamed:@"map_zuo"];
    leftShadow.clipsToBounds=YES;
    [self addSubview:leftShadow];
    
    UIImageView* rightShadow = [[UIImageView alloc] initWithFrame:CGRectMake(self.arMapView.frame.size.width, self.arMapView.frame.origin.y ,5, self.arMapView.frame.size.height)];
    rightShadow.image = [UIImage imageNamed:@"map_you"];
    rightShadow.clipsToBounds=YES;
    [self addSubview:rightShadow];
}

-(void)setMapAnnotationsWithDiarys:(NSMutableArray*)diaryArray{
    for(int i = 0; i < [diaryArray count]; i++){
         DiaryData* diaryData = [diaryArray objectAtIndex:i];
         ArAnnotation* annotation = [[ArAnnotation alloc]initWithLocation:[diaryData.d_latitude doubleValue] longtitude:[diaryData.d_longitude doubleValue]];
            annotation.index = i;
            annotation.diaryData = diaryData;
            [self.mapAnnotations addObject:annotation];
    }
    
    if([Tools locationIsValid:self.userLocationLatitude longitudeStr:self.userLocationLongitude]){
        // 在地图中添加一个PointAnnotation
        UserLocationAnnotation* userLocationAnnotation = [[UserLocationAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [self.userLocationLatitude doubleValue];
        coor.longitude = [self.userLocationLongitude doubleValue];
        userLocationAnnotation.coordinate = coor;
        [self.mapAnnotations addObject:userLocationAnnotation];
    }
  }

//更新当前地图视野范围,并标记所有的视频到地图上
-(void)updateAnnotationsWithAllDiarysOnMap:(NSMutableArray*)diaryArray{
    if(self.mapAnnotations == nil){
        self.mapAnnotations = [[NSMutableArray alloc]initWithCapacity:10];
    }else{
        [self.mapAnnotations removeAllObjects];
    }
    [self setMapAnnotationsWithDiarys:diaryArray];
    _mh.mycollectionNC = self.mycollectionNC;
    if([_mh.diaryArray count] > 0){
        [_mh.diaryArray removeAllObjects];
    }
    [_mh.diaryArray addObjectsFromArray:diaryArray];
    [_mh setMapAnnotationsWithAllPos:self.mapAnnotations visibleVideoAnnotations:nil mapStyle:self.mapStyle showTrack:NO];
}

- (int)getZoomLevel:(MKMapView*)_mapView { 
    return 21-round(log2(_mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * _mapView.bounds.size.width))); 
}

-(void)updateOpenedModelPanel{
    [_mh refreshOpenedModelPanel];
}

@end
