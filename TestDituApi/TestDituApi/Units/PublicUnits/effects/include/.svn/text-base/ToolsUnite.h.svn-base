//
//  ToolsUnite.h
//  EfAVWriter
//
//  Created by xi penggang on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolsUnite : NSObject{}

+ (unsigned char *)GetDataFromUiimage:(UIImage*)image;
+ (UIImage*)RgbaToImage:(void*)RgbaData 
                 ImageW:(int)weidth 
                 ImageH:(int)height;

+ (UIImage*)RgbaToImageWithOrientation:(void*)RgbaData
                                ImageW:(int)weidth
                                ImageH:(int)height
                           Orientation:(UIImageOrientation)orientation;

+ (void)ClockWiseRotation_90:(const unsigned char*)psrcdata 
                        type:(const int)ntype 
                        W:(const int)width 
                        H:(const int)height 
                        DstData:(unsigned char*) pdstdata;

+ (void)U_ClockWiseRotation_90:(const unsigned char*)psrcdata 
                        type:(const int)ntype 
                           W:(const int)width 
                           H:(const int)height 
                     DstData:(unsigned char*) pdstdata;


+ (void)ScaleRGBAData:(unsigned char*)psrcdata srcw:(int)src_w srch:(int)src_h destdata:(unsigned char*)pdstdata dstw:(int)dst_w dsth:(int)dst_h;

@end

@interface ToolsUnite(VideoPress)

+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
+ (unsigned char*) RGBFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
+ (unsigned char*) RGBFromSampleBufferAndSize:(CMSampleBufferRef) sampleBuffer Width:(int*)w Height:(int*)h;
+ (unsigned char*) RGBFromPixelBuffer:(CVPixelBufferRef)pixelBuffer;
+ (CVPixelBufferRef)BuffToPixelBufferRef:(const unsigned char*)data W:(int)width H:(int)height;
+ (CVPixelBufferRef)BuffToPixelBufferRef:(const unsigned char*)data W:(int)width H:(int)height 
                        Opt:(NSDictionary*)options;

@end

@interface  ToolsUnite(transforCoordinate480x360)
+ (void)transforCoordinateFrom360x480to480x360:(int*)x Y:(int*)y W:(int)width H:(int)height;
+ (void)transforCoordinateFrom:(CGSize)srcsize X:(int *)x Y:(int *)y W:(int)width H:(int)height;

//
+ (void)transforCoordinateFromSrctoDst:(int*)x Y:(int*)y SrcW:(int)swidth SrcH:(int)sheight DstW:(int)dwidth DstH:(int)dheight;


/**
 *名称：transforGeometricProportion
 *
 **/
+ (void)transforGeometricProportion:(int)sw SrcH:(int)sh DstW:(int)dw DstH:(int)dh RetW:(int*)rw RetH:(int*)rh;


/**
 *zoomCreateRect 用srcSize通过缩放的方式创建一个rect。
 *referenceRect 放置生成的rect的窗口。
 *srcSize 原始大小
 *nmodle 缩放模式 en_V_SHOW_MODLE中的一个值。
 **/
+ (CGRect)zoomCreateRect:(CGRect)referenceRect src:(CGSize)srcSize modle:(int)nmodle;

@end


@interface ToolsUnite(LatitudeAndLongitude)
+ (double)getRad:(double)d;
+ (double)getAngleWithRad:(double)rad;
+ (double)getDistanceWithLatAndLng:(double)lat1 Lng1:(double)lng1 Lat2:(double)lat2 Lng2:(double)lng2;
+ (double)getAngleBaseNorth:(double)lat1 Lng1:(double)lng1 Lat2:(double)lat2 Lng2:(double)lng2;
@end

@interface ToolsUnite(ffconvert)

//+ (void)CutMediaFile:(NSString*)Infile StartTime:(int)tStart TimeLenght:(int)tLen Out:(NSString*)Outfile;

@end

@interface ToolsUnite(formediafile)
+ (int)GetFileVideoAngle:(NSString*)filename;
+ (void)GetFileTotalTime:(NSString*)filename
      completionHandler:(void (^)(NSString* filename, double time))handler;
@end

@interface ToolsUnite(fileAndfolder)
+ (BOOL)isDirExist:(NSString*)path;
+ (BOOL)changeFileName:(NSString*)srcPath dest:(NSString*)dstPath;
@end



@interface ToolsUnite(systeminfo)
+ (NSString *)getDeviceVersion;



+ (NSString *)getLibVersion;
@end


@interface ToolsUnite(UIImagePress)
+ (UIImage*)ChangeImageDirection:(UIImage*) pimage;

/**
 @ChangeImageDirectionWithPath 旋转图片角度以适配其他操作系统图片的正确性。
 @该函数将覆盖源文件。
 **/
+ (void)ChangeImageDirectionWithPath:(NSString *) path;

/**
 @ChangeImageDirectionWithPath 旋转图片角度以适配其他操作系统图片的正确性。
 @srcPath 源文件全路径 
 @dstPath 生成文件全路径
 **/
+ (void)ChangeImageDirectionWithPath:(NSString *) srcPath dst:(NSString *) dstPath;

/**
 @zoomImageToScreen 根据手机屏幕大小等比缩放图片。
 @该函数只有在图片尺寸大于屏幕尺寸时才生效，否则原样返回。
 **/
+ (UIImage *)zoomImageToScreen:(UIImage *)image;
/**
 @zoomImageWithDstSize 自己设置大小来等比缩放图片。
 @该函数只有在图片尺寸大于目标尺寸时才生效，否则原样返回。
 @请传入点数数值，该函数将自动将点转换为像素。
 **/
+ (UIImage *)zoomImageWithDstSize:(CGSize)dstsize iamge:(UIImage *)image;

@end





