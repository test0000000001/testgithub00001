//
//  VPPMapHelper.h
//  VideoShare
//
//  Created by xudongsheng on 12-11-20.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//
/** 
 This library simplifies the creation and management of a MKMapView. Features:
 
 - Automatic annotations management with their views and callouts. 
 - Map region centering based on the current visible annotations. 
 - Automatic annotation clustering.
 - Easy management of pins dropped by user.
 
 Using VPPMapCustomAnnotation protocol (instead of MKAnnotation protocol)
 would allow a higher annotation customization, although this is optional.
 
 ### Extending MKMapViewDelegate implementation
 VPPMap provides an implementation to the most used methods found in 
`MKMapViewDelegate` protocol. However, you may need to implement some methods
 not implemented by VPPMap. In this case, you have two alternatives:
 
 - Create a category on VPPMapHelper and implement there all the `MKMapViewDelegate`
 methods you need. Be careful to not implement those already implemented 
 by VPPMapHelper.
 - Subclass VPPMapHelper. This will be a harder alternative, but more customizable.
 
 @warning **Important** This library depends on MapKit framework and
 CoreLocation framework.
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CalloutMapAnnotation.h"
#import "ClusterDetailModalPanel.h"
#import "ArAnnotation.h"
#import "UserLocationAnnotation.h"
#import "VPPMapCluster.h"

// specifies initial zoom, used when no mapRegionSpan property is defined
#define kVPPMapHelperLongitudeDelta 0.08f
#define kVPPMapHelperLatitudeDelta 0.0020f
#define kVPPMapHelperDistanceBetweenPoints 40

@protocol ReturnFromOpenedPageDelegate;
@interface VPPMapHelper : NSObject <MKMapViewDelegate> {
@private
	NSMutableArray *_userPins;
    
    NSMutableArray *_unfilteredPins;
    NSMutableArray *_pinsToRemove;
    
    BOOL _regionChangedBecauseAnnotationSelected;
    
    float _currentZoom;
    CalloutMapAnnotation *_calloutAnnotation;
    
    ArAnnotation* _currentSelectedArAnnotation;
    id<ReturnFromOpenedPageDelegate> _returnFromOpenedPageDelegate;
    UserLocationAnnotation* _userLocationAnnotation; //用户当前位置标注
    UAModalPanel* _panelOpened;
    BOOL _isAnnClickedToJump;//用于标注大头针点击后是否进行页面跳转
}
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic, strong) UINavigationController *mycollectionNC;
@property(nonatomic,assign)BOOL showTrack;
//customerize property  add by xudongsheng begin
@property (nonatomic, assign) MAP_STYLE mapStyle;
@property(nonatomic, retain)  NSString *userLocationLatitude; //用户所在位置维度
@property(nonatomic, retain)  NSString *userLocationLongitude;//用户所在位置经度
@property(nonatomic, retain)  NSString *userPosition;//用户所在位置
@property(nonatomic, retain)  NSMutableArray *diaryArray;//日记列表，用于日记详情页展示使用

@property(nonatomic, retain) ClusterDetailModalPanel* modalPanel;//点击地图大头针弹出的列表框
@property(nonatomic, retain) VPPMapCluster *selectedClusterAnnotation;

//add by xudongsheng end
//@property(nonatomic,retain)NSArray*  videoListWithDetailInfo_ar;
-(void)playVideo:(UITapGestureRecognizer *)sender;
-(void)goToDiaryDetailPage:(int)curClickIndex;
//
-(void)refreshOpenedModelPanel;

/** ---
 @name Initializating a Map Helper 
 */

/** Creates and returns a new autoreleased instance with the specified configuration. */
+ (VPPMapHelper*) VPPMapHelperForMapView:(MKMapView*)mapView 
                      pinAnnotationColor:(MKPinAnnotationColor)annotationColor 
                   centersOnUserLocation:(BOOL)centersOnUserLocation 
                   showsDisclosureButton:(BOOL)showsDisclosureButton;
/** ---
 @name Accesing the map view
 */
/// Holds reference to the managed map view
@property (nonatomic, readonly) MKMapView *mapView;

/** ---
 @name Map helper properties
 */

/** Sets if user can drop a pin by longpressing the map in any point.
 */
@property (nonatomic, assign) BOOL userCanDropPin;

/** Sets if user can drop more than one pin by longpressing on the map.
 needs userCanDropPin to be set to YES. */
@property (nonatomic, assign) BOOL allowMultipleUserPins;

/** Holds reference to the pin's class that will be used when user longpresses. 
 It must implement MKAnnotation protocol */
@property (nonatomic, assign) Class pinDroppedByUserClass;

/** Indicates if pins should be grouped in clusters. 
 
 This only applies to those pins added **after** this property has been set to YES
 using the methods addMapAnnotations: or setMapAnnotations: */
@property (nonatomic, assign) BOOL shouldClusterPins;

/** Indicates distance between pins to cluster them. */
@property (nonatomic, assign) float distanceBetweenPins;

/** ---
 @name Default annotation properties
 */

/** Indicates if the annotations' view should show a disclosure button.
 This property can be overriden for each annotation by VPPCustomAnnotation. */
@property (nonatomic, assign) BOOL showsDisclosureButton;


/** Indicates pins color. Red if none is assigned.
 This property can be overriden for each annotation by VPPCustomAnnotation. */
@property (nonatomic, assign) MKPinAnnotationColor pinAnnotationColor;

/** ---
 @name Managing annotations
 */

/** Removes all previous annotations and sets the given ones.
 They must conform to MKAnnotation protocol, or optionally to
 VPPMapCustomAnnotation. 
 
 Invoking this method will center the map automatically. If you want to
 avoid that feature, remove by hand all the existing annotations and use
 addMapAnnotations: instead.
 
 If shouldClusterPins is set to YES, given annotations will be automatically 
 clustered.
 */
- (void)setMapAnnotations:(NSArray*)mapAnnotations mapStyle:(MAP_STYLE)mapStyle showTrack:(BOOL)showTrack;

- (void)setMapAnnotationsWithAllPos:(NSArray*)mapAnnotations visibleVideoAnnotations:(NSMutableArray*)visibleVideoAnnotations mapStyle:(MAP_STYLE)mapStyle showTrack:(BOOL)showTrack;

/** Adds more map annotations to the already existing ones. They must
 conform to MKAnnotation protocol, or optionally to VPPMapCustomAnnotation. 
 
 If shouldClusterPins is set to YES, given annotations will be automatically 
 clustered.
 */
- (void)addMapAnnotations:(NSArray*)mapAnnotations;


/** ---
 @name Centering the map 
 */


/** Indicates whether the map view should be centered on user location or not.
 
 
mapView.showsUserLocation property is independent of this one.
 */
@property (nonatomic, assign) BOOL centersOnUserLocation;


/** Indicates the amount of zoom used when centering the map.
 */
@property (nonatomic, assign) MKCoordinateSpan mapRegionSpan;

/** Calcultates the best map's region to be shown and centers the map view to
 fit that region.
 
 If centersOnUserLocation is set to YES, mapView will be centered on it
 with the mapRegionSpan indicated.
 
 If centersOnUserLocation is set to NO, mapView will be centered around the 
 current annotations, with the needed span to let all annotations to be shown.
 */
- (void) centerMap;

/** Sets the best map region to show the indicated coordinate.
 */
- (void) centerOnCoordinate:(CLLocationCoordinate2D)coordinate;


@end
