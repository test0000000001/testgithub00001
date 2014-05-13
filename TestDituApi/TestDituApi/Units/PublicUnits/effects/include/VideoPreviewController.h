//
//  VideoPreviewController.h
//  EfAVWriter
//
//  Created by penggang xi on 5/27/13.
//
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVCaptureVideoPreviewLayer.h"
#import "AVFoundation/AVCaptureVideoPreviewLayer.h"

@interface VideoPreviewController : UIViewController<UIAccelerometerDelegate>

@property (readwrite, getter = getshowmodle) int mv_show_modle;

- (id)initWithRect:(CGRect)rt;
- (void)setDelegate:(id)dg;

- (void)setRectAndTransform:(CGRect)rt Transform:(CGAffineTransform)transform;

- (void)setDefaultPreview:(AVCaptureVideoPreviewLayer*)avLayer;
- (void)showDefault:(BOOL)bshow;
@end


@interface VideoPreviewController(ShowVideo)

- (void)displayPixelBuffer:(CVImageBufferRef)pixelBuffer;

- (void)useBackCameras;
- (void)useFrontCameras;


@end


@interface VideoPreviewController(AccelerometerAndGrid)

- (void)setAccelermeter:(BOOL)bshow;
- (void)setGrid:(BOOL)bshow;
- (BOOL)isAccelermeter;
- (BOOL)isGrid;

@end

@interface VideoPreviewController(FocusPoint)
- (void)showFocusPointView;
- (void)hiddenFocusPointView;
@end


@protocol VideoPreviewControllerDelegate <NSObject>
@optional
- (void)ClickEvent:(UIView*)pview point:(CGPoint)point;
@end

