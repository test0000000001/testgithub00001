//
//  AppViewController.h
//  TestDituApi
//
//  Created by capry on 13-8-26.
//  Copyright (c) 2013年 capry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AppViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, strong) IBOutlet UILabel *longitudeLabel;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *resultFromLabel;
@end
