//
//  VideoGLView.h
//  EfAVWriter
//
//  Created by xi penggang on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



enum{
    FILL_TYPE_FULL = 0,     //铺满屏   当分辨率不一样时会变形。
    FILL_TYPE_PROP,         //等比显示。当分辨率不一样时会有空隙
    FILL_TYPE_EQ_FULL       //等比满屏显示。当分辨率不一样时会显示不全。
};

enum{
    FROM_DRIVE,
    FROM_FILE
};

typedef struct {
    int wframe;
    int hframe;
    float wview;
    float hview;
    float wrata;
    float hrata;
}videoimginfo;


@interface VideoGLView : UIView
{
    int             mfull;      //是否铺满整个view。
    int             mangle;     //视频旋转角度
    videoimginfo    mimginfo;   //缩放相关信息
    int             mUseBackOrFrontCameras;
    
    //方向缩放相关参数
    GLfloat spriteVertices[8];
    GLshort spriteTexcoords[8];
    
    int             mfrom;      //视频来源
    
    
}

@property (readwrite) int mfull;
@property (readwrite) int mangle;

@property (readwrite) int mfrom;
@property (readwrite) int mUseBackOrFrontCameras;

- (void)displayPixelBuffer:(CVImageBufferRef)pixelBuffer;
- (void)displayPixelBuffer:(unsigned char*)data w:(int)width h:(int)height;



//init  info
- (void)initspriteinfo;

//set Geometric scaling
//设置等比缩放参数
- (void)SetGeometricScal:(int)width VideoHeight:(int)height; 


@end
