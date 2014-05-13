//
//  VPPMapHelper.m
//  VideoShare
//
//  Created by xudongsheng on 12-11-20.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//
#import "VPPMapHelper.h"
#import "VPPMapCustomAnnotation.h"
#import "VPPMapClusterHelper.h"
#import "ArAnnotation.h"
//#import "UploadedModel.h"
#import "Tools.h"
#import "DrawArcUtils.h"
#import "ArData.h"
#import "CallOutAnnotationView.h"
#import "ArMapCell.h"
#import "ImageCacheManager.h"
//#import "MoviePlayer.h"
#import "Global.h"
//#import "VideoDetailViewController.h"
#import "ClusterDetailModalPanel.h"
#import "AppDelegate.h"
//#import "VideoPublishViewController.h"
#import "VPPMapClusterView.h"
#import "UserLocationAnnotationView.h"
#import "SpaceCollectionViewCell.h"
#import "DiaryDetailsViewController.h"

#define kVPPMapHelperOpenAnnotationDelay 0.65

#define kVPPMapHelperOnePinLongitudeDelta 0.003f
#define kVPPMapHelperOnePinLatitudeDelta 0.0006f

#define kPressDuration 0.5 // in seconds

@implementation VPPMapHelper
@synthesize mapView;
@synthesize centersOnUserLocation;
@synthesize showsDisclosureButton;
@synthesize pinAnnotationColor;
@synthesize mapRegionSpan;
@synthesize userCanDropPin;
@synthesize allowMultipleUserPins;
@synthesize pinDroppedByUserClass;
@synthesize shouldClusterPins;
@synthesize distanceBetweenPins;
@synthesize routeLine=_routeLine;
@synthesize routeLineView=_routeLineView;
@synthesize mycollectionNC=_mycollectionNC;
@synthesize showTrack=_showTrack;
@synthesize mapStyle=_mapStyle;
@synthesize userLocationLatitude=_userLocationLatitude;
@synthesize userLocationLongitude=_userLocationLongitude;
@synthesize userPosition=_userPosition;

#pragma mark -
#pragma mark Lifecycle

+ (VPPMapHelper*) VPPMapHelperForMapView:(MKMapView*)mapView 
                      pinAnnotationColor:(MKPinAnnotationColor)annotationColor 
                   centersOnUserLocation:(BOOL)centersOnUserLocation 
                   showsDisclosureButton:(BOOL)showsDisclosureButton
{
	
	// sets up the map
	VPPMapHelper *mh = [[VPPMapHelper alloc] init];
	mh->_userPins = [[NSMutableArray alloc] init];
	// we don't want user's location
	mh.centersOnUserLocation = centersOnUserLocation;
	// we want the disclosure button
	mh.showsDisclosureButton = showsDisclosureButton;
	// green pins
	mh.pinAnnotationColor = annotationColor;
	// mapView referenced
	mh->mapView = [mapView retain];
	// MKMapViewDelegate
	mapView.delegate = [mh retain];
    mh->_unfilteredPins = [[NSMutableArray alloc] init];
    mh->_diaryArray = [[NSMutableArray alloc] init];
    mh->_currentZoom = -1;
    mh->userCanDropPin = NO;
    mh.showTrack = NO;
    mh->_regionChangedBecauseAnnotationSelected = NO;
	return [mh autorelease];
}

- (void)dealloc {
    if (_userPins != nil) {
        [_userPins release];
    }
    if (mapView != nil) {
        [mapView release];
        mapView = nil;
    }
    if (_unfilteredPins != nil) {
        [_unfilteredPins release];
    }
	[super dealloc];
}

#pragma mark - Help stuff

- (float) distanceBetweenPins {
    if (distanceBetweenPins == 0) {
        return kVPPMapHelperDistanceBetweenPoints;
    }
    else {
        return distanceBetweenPins;
    }
}

-(void)drawArc:(NSArray*)diaryArray mapView:(MKMapView *)mapView{
    UIImageView* referedImageView=[[UIImageView alloc] initWithFrame:self.mapView.frame];
    int videosCount = [diaryArray count];
    NSMutableArray* videoScreenCoordinateArray = [[NSMutableArray alloc]initWithCapacity:videosCount];
    for(DiaryData* diaryData in diaryArray){
        CLLocationCoordinate2D videoLocation;
        videoLocation.latitude = [diaryData.d_latitude doubleValue];
        videoLocation.longitude = [diaryData.d_longitude doubleValue];
        CGPoint videoScreenCoordinate = [self.mapView convertCoordinate:videoLocation toPointToView:referedImageView];
        [videoScreenCoordinateArray addObject:[NSValue valueWithCGPoint:videoScreenCoordinate]];
    }
    NSArray *sortedArray = [Tools bubbleSortWithCGPointArray:videoScreenCoordinateArray];
    NSMutableArray* fillPointArray = [[NSMutableArray alloc]initWithCapacity:videosCount];
    for(int i = 0; i < videosCount - 1; i++){
        int startPointIndex = i;
        int endPointIndex = startPointIndex + 1;
        CGPoint startPoint = [[sortedArray objectAtIndex:startPointIndex]CGPointValue];
        CGPoint endPoint = [[sortedArray objectAtIndex:endPointIndex]CGPointValue];
        NSMutableArray* tempFillPointArray = [DrawArcUtils acquireArcFillPoints:startPoint  arcEndPoint:endPoint referedMapView:self.mapView];
        [fillPointArray addObjectsFromArray:tempFillPointArray];
    }
    if(sortedArray != nil && [sortedArray count] > 0){
        CGPoint point0 = [[sortedArray objectAtIndex:0]CGPointValue];
        CLLocationCoordinate2D startPoint =[self.mapView convertPoint:point0 toCoordinateFromView:referedImageView];
        CLLocation *startPointlocation = [[CLLocation alloc] initWithLatitude:startPoint.latitude longitude:startPoint.longitude];
        [fillPointArray insertObject:startPointlocation atIndex:0];
        [self configureRoutes:fillPointArray mapView:self.mapView];
    }
}

- (void)configureRoutes:(NSArray*)routeFillPoints mapView:(MKMapView *)mapView
{
    // define minimum, maximum points
	MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f); 
	MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f); 
	
	// create a c array of points. 
	MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * routeFillPoints.count);
    
	// for(int idx = 0; idx < pointStrings.count; idx++)
    for(int idx = 0; idx < routeFillPoints.count; idx++)
	{        
        CLLocation *location = [routeFillPoints objectAtIndex:idx];  
        CLLocationDegrees latitude  = location.coordinate.latitude;
		CLLocationDegrees longitude = location.coordinate.longitude;		 
        
		// create our coordinate and add it to the correct spot in the array 
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
		
		// if it is the first point, just use them, since we have nothing to compare to yet. 
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		} else {
			if (point.x > northEastPoint.x) 
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x) 
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y) 
				southWestPoint.y = point.y;
		}
		pointArray[idx] = point;        
	}
	
    if (self.routeLine) {
        [self.mapView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArray count:routeFillPoints.count];
    
    // add the overlay to the map
	if (nil != self.routeLine) {
		[self.mapView addOverlay:self.routeLine];
	}
    // clear the memory allocated earlier for the points
	free(pointArray);	
}

-(void)gotoDiaryDetailPage:(UITapGestureRecognizer *)sender{
    int curClickIndex = sender.view.tag;
    [self gotoDiaryDetailPageByCurClickIndex:curClickIndex];
}

- (void)gotoDiaryDetailPageByCurClickIndex:(int)curClickIndex
{
    NSMutableArray *uuidArray = [[NSMutableArray alloc] init];
    for (DiaryData *ddata in self.diaryArray) {
        [uuidArray addObject:ddata.d_diaryuuid];
    }
    DiaryDetailsViewController *diaryDetailsViewController = [[DiaryDetailsViewController alloc]initWithWhoYouAre:PREVIOUS_PAGE_IS_OTHERS_DIARY_PAGE diaries:uuidArray position:curClickIndex];
    [self.mycollectionNC pushViewController:diaryDetailsViewController animated:YES];
}

-(void)updateMapCellByDiaryStyle:(DiaryData*)diaryData mapCell:(ArMapCell*)mapCell{
    CELL_DISPLAY_STYLE diaryStyle  = [Tools getCollentionDiaryDisplayStyle:diaryData];
    mapCell.imageView.image = [UIImage imageNamed:@"3_tankuang_moren"];
    mapCell.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDiaryDetailPage:)];
    [mapCell.imageView addGestureRecognizer:imageSingleTap];
    mapCell.textContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDiaryDetailPage:)];
    [mapCell.textContentView addGestureRecognizer:singleTap];
    mapCell.nicknameLabel.text = diaryData.d_nickname;
    
    if ([@"1" isEqualToString:diaryData.d_sex]) {
        mapCell.sexView.image = [UIImage imageNamed:@"3_ar_nv"];
    }else if([@"0" isEqualToString:diaryData.d_sex]){
        mapCell.sexView.image = [UIImage imageNamed:@"3_ar_nan"];
    }else{
        mapCell.sexView.image = [UIImage imageNamed:@""];
    }
    mapCell.videoUploadTime.text = [Tools dateFormat:DIARY_CREATE_TIME_DEFAULT_FORMAT timeMilli:[NSNumber numberWithDouble:[diaryData.d_diarytimemilli doubleValue]]];
    switch (diaryStyle) {
        case VIDEO_NO_AUXILIARY_ATTACH:   //只有主附件，没有辅附件
        {
            NSString *videoCoverUrl = [Tools parseVideoCover:diaryData];
            if (videoCoverUrl) {
                [ImageCacheManager setImageToImage:videoCoverUrl imageView:mapCell.imageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            mapCell.bofangImageView.hidden = NO;
            break;
        }
        case VIDEO_HAS_ONE_AUXILIARY_VOICE_ATTACH://有：主附件，语音辅附件
        {
            NSString *videoCoverUrl = [Tools parseVideoCover:diaryData];
            if (videoCoverUrl) {
                [ImageCacheManager setImageToImage:videoCoverUrl imageView:mapCell.imageView];
            }
            mapCell.bofangImageView.hidden = NO;
            break;
        }
        case VIDEO_HAS_ONE_AUXILIARY_WORDS_ATTACH: //有：主附件，文字辅附件
        {
            NSString *videoCoverUrl = [Tools parseVideoCover:diaryData];
            if (videoCoverUrl) {
                [ImageCacheManager setImageToImage:videoCoverUrl imageView:mapCell.imageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            mapCell.bofangImageView.hidden = NO;
            break;
        }
        case VIDEO_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
        {
            NSString *videoCoverUrl = [Tools parseVideoCover:diaryData];
            if (videoCoverUrl) {
                [ImageCacheManager setImageToImage:videoCoverUrl imageView:mapCell.imageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            mapCell.bofangImageView.hidden = NO;
            break;
        }
        case AUDIO_NO_AUXILIARY_ATTACH://只有主附件，没有辅附件
        {
            mapCell.imageView.image = [UIImage imageNamed:@"3_tankuang_luyin"];
            break;
        }
        case AUDIO_NO_MAIN_ATTACH://无主附件，有两个辅附件
        {
            mapCell.imageView.image = [UIImage imageNamed:@"3_tankuang_nothing"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
        case AUDIO_HAS_ONE_AUXILIARY_WORDS_ATTACH://有：主附件，文字辅附件
        {
            mapCell.imageView.image = [UIImage imageNamed:@"3_tankuang_luyin"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
        case AUDIO_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
            
        {
            mapCell.imageView.image = [UIImage imageNamed:@"3_tankuang_luyin"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        case IMAGE_NO_AUXILIARY_ATTACH://只有主附件，没有辅附件
        {
            NSString *imageurl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
           if (imageurl) {
                [ImageCacheManager setImageToImage:imageurl imageView:mapCell.imageView];
            }
            break;
        }
            
        case IMAGE_HAS_ONE_AUXILIARY_VOICE_ATTACH://有：主附件，语音辅附件
        {
            NSString *imageurl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
            if (imageurl) {
                [ImageCacheManager setImageToImage:imageurl imageView:mapCell.imageView];
            }
            break;
        }
            
        case IMAGE_HAS_ONE_AUXILIARY_WORDS_ATTACH://有：主附件，文字辅附件
        {
            NSString *imageurl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
            if (imageurl) {
                [ImageCacheManager setImageToImage:imageurl imageView:mapCell.imageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        case IMAGE_HAS_TWO_AUXILIARY_ATTACH://有：主附件，语音辅附件，文字辅附件
            
        {
            NSString *imageurl = [Tools parseImageUrlByAttachLevel:diaryData attachLevel:1];
            if (imageurl) {
                [ImageCacheManager setImageToImage:imageurl imageView:mapCell.imageView];
            }
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        case AUXILIARY_ATTACH_WORDS: //只有文字
        {
            mapCell.imageView.image = [UIImage imageNamed:@"3_tankuang_nothing"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        case AUXILIARY_ATTACH_VOICE: //只有语音
        {
            mapCell.imageView.image = [UIImage imageNamed:@"3_tankuang_nothing"];
            break;
        }
            
        case AUXILIARY_ATTACH_WORDS_AND_VOICE:
        {
            mapCell.imageView.image = [UIImage imageNamed:@"3_tankuang_nothing"];
            mapCell.contentLabel.text = [Tools parseTextDescByAttachLevel:diaryData attachLevel:0];
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark -
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation;
{
    VPPMapClusterView *clusterView = nil;
    _isAnnClickedToJump = YES;
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CalloutMapAnnotation* selectedAnnotation = (CalloutMapAnnotation*)annotation;
        if(!selectedAnnotation.isUserLocationAnnotation){
            CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
            if (!annotationView) {
                annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView" isUserLocationAnn:NO calloutWidth:300 calloutHeight:100];
            }
            ArMapCell *cell = [[ArMapCell alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
            DiaryData* diaryData = selectedAnnotation.diaryData;
            [self updateMapCellByDiaryStyle:diaryData mapCell:cell];
            
            int curClickDiaryIndex = [self.diaryArray indexOfObject:diaryData];
            cell.textContentView.tag = curClickDiaryIndex;
            cell.imageView.tag = curClickDiaryIndex;
            
            
            UIView* lastview = [cell viewWithTag:222];
            if (lastview) {
                [lastview removeFromSuperview];
            }
            UIView * view = [Tools getRichText:UN_NIL(cell.contentLabel.text):160:2];
            view.tag = 222;
            view.frame = view.bounds;
            [cell addSubview:view];
            if([[annotationView.contentView subviews] count] > 0){
                [[[annotationView.contentView subviews]objectAtIndex:0] removeFromSuperview];
            }
            [annotationView.contentView addSubview:cell];
            return annotationView;
        }else{
            CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"userLocationCalloutView"];
            if (!annotationView) {
                annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userLocationCalloutView" isUserLocationAnn:YES];
            }
            UILabel* userLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 240 - 8*2, 50)];
            userLocationLabel.backgroundColor = [UIColor clearColor];
            userLocationLabel.font = [UIFont boldSystemFontOfSize:14];
            userLocationLabel.numberOfLines = 0;
            userLocationLabel.textAlignment = UITextAlignmentLeft;
            userLocationLabel.textColor = [UIColor whiteColor];
            if([@"" isEqualToString:UN_NIL(self.userPosition)]){
               NSString* positionText = @"经度:";
               positionText = [positionText stringByAppendingFormat:UN_NIL(self.userLocationLongitude)];
               positionText = [positionText stringByAppendingFormat:@"  纬度:"];
               positionText = [positionText stringByAppendingFormat:UN_NIL(self.userLocationLatitude)];
                userLocationLabel.text = positionText;
            }else{
               userLocationLabel.text = self.userPosition;
            }
            if([[annotationView.contentView subviews] count] > 0){
                [[[annotationView.contentView subviews]objectAtIndex:0] removeFromSuperview];
            }
            [annotationView.contentView addSubview:userLocationLabel];
            _isAnnClickedToJump = NO;
            return annotationView;
        }
	}else  if ([annotation isKindOfClass:[ArAnnotation class]]){
            clusterView = [self buildClusterViewByAnnStyle:@"single" annotation:annotation annStyle:ANNOTATION_BLUE theMapView:theMapView];
            clusterView.title = @"1";
            clusterView.canShowCallout = NO;
            return clusterView;
        }else if ([annotation isKindOfClass:[VPPMapCluster class]]) {
            clusterView = [self buildClusterViewByAnnStyle:@"cluster_star" annotation:annotation annStyle:ANNOTATION_STAR theMapView:theMapView];
            clusterView.title = [NSString stringWithFormat:@"%d",[[(VPPMapCluster*)annotation annotations] count]];
            clusterView.canShowCallout = NO;
            
             return clusterView;
    }else if([annotation isKindOfClass:[UserLocationAnnotation class]]){//标记用户当前位置
        MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[[UserLocationAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = NO;
        }
		return annotationView;
    }
    return nil;
}

-(VPPMapClusterView *)buildClusterViewByAnnStyle:(NSString *)identifier annotation:(id<MKAnnotation>)annotation annStyle:(ANNOTATION_STYLE)annStyle theMapView:(MKMapView *)theMapView{
    VPPMapClusterView *clusterView = (VPPMapClusterView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!clusterView) {
        clusterView = [[[VPPMapClusterView alloc] initWithAnnotation:annotation reuseIdentifier:identifier annStyle:annStyle] autorelease];
    }
    return clusterView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay;
{
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now. 
        if (self.routeLineView) {
            [self.routeLineView removeFromSuperview];
        }
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor redColor];
        self.routeLineView.strokeColor = [UIColor redColor];
        self.routeLineView.lineWidth = 5;
        
		overlayView = self.routeLineView;		
	}
    return overlayView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    _regionChangedBecauseAnnotationSelected = YES;
    [CmmobiAndUmengClick event:NEAR_ENTER_DETAILS_BUTTON]; //埋点
    if ([view.annotation isKindOfClass:[ArAnnotation class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [self.mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc] 
                              initWithLatitude:view.annotation.coordinate.latitude
                              andLongitude:view.annotation.coordinate.longitude];
        ArAnnotation* selectedAnnotation = (ArAnnotation*)view.annotation;
        _currentSelectedArAnnotation = selectedAnnotation;
        _calloutAnnotation.diaryData = selectedAnnotation.diaryData;
        [self.mapView addAnnotation:_calloutAnnotation];
        [self.mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else if([view.annotation isKindOfClass:[VPPMapCluster class]]){
        //点击之后直接弹出一个视频列表视图
        self.selectedClusterAnnotation = (VPPMapCluster *)view.annotation;
        int itemCount = [self.selectedClusterAnnotation.annotations count];
        self.modalPanel = [[ClusterDetailModalPanel alloc] initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height) itemCount:itemCount];
        [self.modalPanel.diaryArray addObjectsFromArray:self.diaryArray];
        self.modalPanel.mapStyle = self.mapStyle;
        self.modalPanel.mycollectionNC = self.mycollectionNC;
        self.modalPanel.clusterChildAnnotationList = self.selectedClusterAnnotation.annotations;
        [self.mapView addSubview:self.modalPanel];
        self.modalPanel.onClosePressed = ^(UAModalPanel* panel) {
			// [panel hide];
			[panel hideWithOnComplete:^(BOOL finished) {
				[panel removeFromSuperview];
                //此处改变地图中心位置，去触发didDeselectAnnotationView方法
                CLLocationCoordinate2D tempCoords = CLLocationCoordinate2DMake(self.selectedClusterAnnotation.latitude + 0.000001,self.selectedClusterAnnotation.longitude);
                [self.mapView setCenterCoordinate:tempCoords animated:YES];
			}];
		};
        // Show the panel from the center of the button that was pressed
        [self.mapView setCenterCoordinate:self.selectedClusterAnnotation.coordinate animated:YES];
        [self.modalPanel showFromPoint:[view center]];
    }
    else if([view.annotation isKindOfClass:[UserLocationAnnotation class]]){
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [self.mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                              initWithLatitude:view.annotation.coordinate.latitude
                              andLongitude:view.annotation.coordinate.longitude];
        _calloutAnnotation.isUserLocationAnnotation = YES;
        [self.mapView addAnnotation:_calloutAnnotation];
        [self.mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
    }else{
     if(!_calloutAnnotation){ //用户点击了单个标注
      //判断点击的是否是当前位置提示
       if(_isAnnClickedToJump){
         [self goToDiaryDetailPage:0];
       }
     }
   }
}

-(void)refreshOpenedModelPanel{
    if(self.modalPanel){
        [self.modalPanel removeFromSuperview];
        //TODO 
//        NSArray *mapViewAnnotiaons = self.mapView.annotations;
//        if(mapViewAnnotiaons && [mapViewAnnotiaons count] > 0){
//            for(int i = 0 ; i < [mapViewAnnotiaons count]; i++){
//                id<MKAnnotation> ann = [mapViewAnnotiaons objectAtIndex:i];
//                if(self.selectedClusterAnnotation.latitude == ann.coordinate.latitude && self.selectedClusterAnnotation.longitude == ann.coordinate.longitude){
//                    [self.mapView selectAnnotation:ann animated:NO];
//                    break;
//                }
//            }
//        }
    }
}

-(void)goToDiaryDetailPage:(int)curClickIndex{
    NSMutableArray *uuidArray = [[NSMutableArray alloc] init];
    for (DiaryData *ddata in self.diaryArray) {
        [uuidArray addObject:ddata.d_diaryuuid];
    }
    DiaryDetailsViewController *diaryDetailsViewController = [[DiaryDetailsViewController alloc]initWithWhoYouAre:PREVIOUS_PAGE_IS_OTHERS_DIARY_PAGE diaries:uuidArray position:curClickIndex];
    [self.mycollectionNC pushViewController:diaryDetailsViewController animated:YES];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if(view != nil){
        if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationView class]]) {
            if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
                _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
                [self.mapView removeAnnotation:_calloutAnnotation];
                _calloutAnnotation = nil;
            }
        }else{
            if([view isKindOfClass:[MKPinAnnotationView class]]){
                //NSLog(@"didDeselectAnnotationView, view isKindOfClass MKPinAnnotationView");
            }else{
                // NSLog(@"didDeselectAnnotationView, view is not KindOfClass MKPinAnnotationView");
            }
        }
    }
}

- (MKCoordinateRegion) regionAccordingToAnnotations:(NSArray*)annotations {
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    
    CLLocationCoordinate2D currentCoordinate;
    
    float minLatitude = -9999;
    float minLongitude = -9999;
    float maxLatitude = 9999;
    float maxLongitude = 9999;
    if(annotations && [annotations count] > 0){
        for (id<MKAnnotation> ann in annotations) {
            if ([ann isKindOfClass:[MKUserLocation class]]) {
                continue;
            }
            
            currentCoordinate = ann.coordinate;
            //add by xudongsheng begin
            if(currentCoordinate.latitude == 0 && currentCoordinate.longitude == 0){
                continue;
            }
            //add by xudongsheng end
            if (minLatitude == -9999 || minLongitude == -9999) {
                minLatitude = currentCoordinate.latitude;
                minLongitude = currentCoordinate.longitude;
            }
            if (maxLatitude == 9999 || maxLongitude == 9999) {
                maxLatitude = currentCoordinate.latitude;
                maxLongitude = currentCoordinate.longitude;
            }
            
            if (currentCoordinate.latitude < minLatitude) {
                minLatitude = currentCoordinate.latitude;
            }
            if (currentCoordinate.longitude < minLongitude) {
                minLongitude = currentCoordinate.longitude;
            }
            if (currentCoordinate.latitude > maxLatitude) {
                maxLatitude = currentCoordinate.latitude;
            }
            if (currentCoordinate.longitude > maxLongitude) {
                maxLongitude = currentCoordinate.longitude;
            }
        }
    }
        
    CLLocation *min = [[CLLocation alloc] initWithLatitude:minLatitude longitude:minLongitude];
    CLLocation *max = [[CLLocation alloc] initWithLatitude:maxLatitude longitude:maxLongitude];
    CLLocationDistance dist = [max distanceFromLocation:min];
    [max release];
    [min release];
    
    region.center.latitude = (minLatitude + maxLatitude) / 2.0;
    region.center.longitude = (minLongitude	+ maxLongitude) / 2.0;
    region.span.latitudeDelta = dist / 111319.5 * 1.5; // magic number !! :) 1.2
    //add by xudongsheng begin
    //若决定视野的几个视频都是私密视频，都没有经纬度，则设置地图为默认视野
    if(region.center.latitude == 0 && region.center.longitude == 0){
        region.center.latitude = 39.310283;
        region.center.longitude = 104.606751;
        if(iPhone5){
           region.span.latitudeDelta = 50;
        }else{
           region.span.latitudeDelta = 42;//原来26
        }
    }
    ////add by xudongsheng end
    if(region.span.latitudeDelta < -180 )
        region.span.latitudeDelta = -180;
    if(region.span.latitudeDelta > 180)
        region.span.latitudeDelta = 180;
    // explanation here: http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MapKitDataTypesReference/Reference/reference.html
    region.span.longitudeDelta = 0.0;
    
    return region;
    
}

#pragma mark - Centering map stuff

- (void)observeValueForKeyPath:(NSString *)keyPath  
                      ofObject:(id)object  
                        change:(NSDictionary *)change  
                       context:(void *)context {  
    
    if (self.centersOnUserLocation) {  
        [self centerMap];
    }
}

- (void) centerOnCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };

    region.center = coordinate;
    
    if (self.mapRegionSpan.latitudeDelta != 0.0 && self.mapRegionSpan.longitudeDelta != 0.0) {
        region.span = self.mapRegionSpan;
    }
    else {
        region.span.longitudeDelta = kVPPMapHelperLongitudeDelta;
        region.span.latitudeDelta = kVPPMapHelperLatitudeDelta;		
    }
    
    [self.mapView setRegion:region animated:YES];	
}

- (void) centerMap {
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
	CLLocationCoordinate2D currentCoordinate;
	
	if (self.centersOnUserLocation) {
		CLLocation *userLocation = self.mapView.userLocation.location;

		[self centerOnCoordinate:userLocation.coordinate];
		return;
	}
	
	else if ([self.mapView.annotations count] > 1) {	
		region = [self regionAccordingToAnnotations:self.mapView.annotations];
    }
	
	else if ([self.mapView.annotations count] == 1) {
		currentCoordinate = [[self.mapView.annotations objectAtIndex:0] coordinate];
		
        region.center = currentCoordinate;
		
		region.span.longitudeDelta = kVPPMapHelperOnePinLongitudeDelta;
		region.span.latitudeDelta = kVPPMapHelperOnePinLatitudeDelta;		
	}
	
	else {
		return;
	}
	[self.mapView setRegion:region animated:YES];	
}


#pragma mark - Clustering stuff
- (void) mapView:(MKMapView *)mmapView didAddAnnotationViews:(NSArray *)views {
    if (_pinsToRemove != nil) {
        [mmapView removeAnnotations:_pinsToRemove];
        [_pinsToRemove release];
        _pinsToRemove = nil;
    }
}

- (BOOL) mapViewDidZoom:(MKMapView*)mmapView  {
    if (_currentZoom == mmapView.visibleMapRect.size.width * mmapView.visibleMapRect.size.height) {
        return NO;
    }
    _currentZoom = mmapView.visibleMapRect.size.width * mmapView.visibleMapRect.size.height;
    return YES;
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}

- (void) mapView:(MKMapView *)mmapView regionDidChangeAnimated:(BOOL)animated {
    if (!_regionChangedBecauseAnnotationSelected) //note "!" in front
    {
        //reload (add/remove) annotations here...
        if (self.shouldClusterPins && [_unfilteredPins count] != 0 && [self mapViewDidZoom:mmapView]) {
            VPPMapClusterHelper *mh = [[VPPMapClusterHelper alloc] initWithMapView:self.mapView];
            [mh clustersForAnnotations:_unfilteredPins distance:self.distanceBetweenPins completion:^(NSArray *data) {
                if (_pinsToRemove != nil) {
                    [_pinsToRemove release];
                }
                _pinsToRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
                [_pinsToRemove removeObjectsInArray:data];
                [self.mapView addAnnotations:data];
                //若是首页，画轨迹
                if(_showTrack){
                    NSMutableArray* arcDataList = [self getArcDataList:data];
                    [self drawArc:arcDataList mapView:self.mapView];
                }
            }];
            [mh release];
        }
    }
    //reset flags...
    _regionChangedBecauseAnnotationSelected = NO;
}

#pragma mark - Managing annotations
- (void)setMapAnnotationsWithAllPos:(NSArray*)mapAnnotations visibleVideoAnnotations:(NSMutableArray*)visibleVideoAnnotations mapStyle:(MAP_STYLE)mapStyle showTrack:(BOOL)showTrack{
    self.mapStyle=mapStyle;
	// removes all previous annotations
	NSArray *annotations = [NSArray arrayWithArray:self.mapView.annotations];
	[self.mapView removeAnnotations:annotations];
	self.showTrack = showTrack;
    if(mapAnnotations && [mapAnnotations count] > 0){
        [self addMapAnnotations:mapAnnotations];
        if (self.shouldClusterPins) {
            [_unfilteredPins removeAllObjects];
            [self.mapView setRegion:[self regionAccordingToAnnotations:visibleVideoAnnotations] animated:YES];
        }
        else {
            [self centerMap];
        }
    }else{ //add by xudongsheng
        [_unfilteredPins removeAllObjects];
    }
}

// sets all annotations and initializes map.
- (void)setMapAnnotations:(NSArray*)mapAnnotations mapStyle:(MAP_STYLE)mapStyle showTrack:(BOOL)showTrack{
    self.mapStyle = mapStyle;
	// removes all previous annotations
	NSArray *annotations = [NSArray arrayWithArray:self.mapView.annotations];
	[self.mapView removeAnnotations:annotations];
	self.showTrack = showTrack;
    if(mapAnnotations && [mapAnnotations count] > 0){
        [self addMapAnnotations:mapAnnotations];
        if (self.shouldClusterPins) {
            [_unfilteredPins removeAllObjects];
            [self.mapView setRegion:[self regionAccordingToAnnotations:mapAnnotations] animated:YES];
        }
        else {
            [self centerMap];
        }
    }
}

// adds more annotations 
- (void)addMapAnnotations:(NSArray*)mapAnnotations{
    if (self.shouldClusterPins) {
        VPPMapClusterHelper *mh = [[VPPMapClusterHelper alloc] initWithMapView:self.mapView];
        [mh clustersForAnnotations:mapAnnotations distance:self.distanceBetweenPins completion:^(NSArray *data) {
            [_unfilteredPins addObjectsFromArray:mapAnnotations];
            [self.mapView addAnnotations:data];
            
            if(_showTrack){
                NSMutableArray* arcDataList = [self getArcDataList:data];
                //画弧线
                [self drawArc:arcDataList mapView:self.mapView];
            }
        }];
        [mh release];
    }
    else {
        [self.mapView addAnnotations:mapAnnotations];
    }
}

-(NSMutableArray*)getArcDataList:(NSArray*)data{
    NSMutableArray* arcDataList = [NSMutableArray array];
    for(int i=0 ; i < [data count]; i++){
        if([[data objectAtIndex:i] isKindOfClass:[VPPMapCluster class]]){
            DiaryData* diaryData = [[DiaryData alloc]init];
           diaryData.d_latitude = [NSString stringWithFormat:@"%f", [(id<VPPMapCustomAnnotation>)[data objectAtIndex:i]coordinate].latitude];
           diaryData.d_longitude = [NSString stringWithFormat:@"%f", [(id<VPPMapCustomAnnotation>)[data objectAtIndex:i]coordinate].longitude];
            [arcDataList addObject:diaryData];
        }else if([[data objectAtIndex:i] isKindOfClass:[ArAnnotation class]]){
            [arcDataList addObject:[(id<VPPMapCustomAnnotation>)[data objectAtIndex:i] diaryData]];
        }
    }
    return arcDataList;
}
@end
