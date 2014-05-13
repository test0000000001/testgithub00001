//
//  PhotoEngine.h
//  EfAVWriter
//
//  Created by penggang xi on 5/22/13.
//
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol PhotoEngineDelegate;

@interface PhotoEngine : NSObject{
    id <PhotoEngineDelegate> delegate;
}

@property (nonatomic, retain) AVCaptureStillImageOutput *mStillImageOutput;
@property (readwrite, assign) id <PhotoEngineDelegate> delegate;

- (void)takePicture:(NSString*)filepath;
- (id)initWithDelegate:(id)idelegate;
- (BOOL)isCaptured;
@end


@protocol PhotoEngineDelegate <NSObject>
@optional
- (void)takePictureFinish:(NSString*)filepath
              Orientation:(UIDeviceOrientation)orientation;
- (void)takePictureFailed;
- (void)capturing;
- (void)captured;
@end