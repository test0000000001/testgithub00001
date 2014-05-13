//
//  LLDefines.h
//  VideoShare
//
//  Created by zengchao on 13-5-15.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//
#import "AppDelegate.h"

#ifndef __OPTIMIZE__
#    define NSLog(...) NSLog(__VA_ARGS__)
#else
#    define NSLog(...) {}
#endif

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define LL_GLOBAL_SERVICE APP_DELEGATE.llGlobalService

//判断server返回值是否为空
#define IS_NIL(key) ([@"<null>" isEqualToString:(key)] || [@"" isEqualToString:(key)]?nil:(key))
#define UN_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]]||[@"" isEqualToString:s]?@"":s)
#define OBJ_IS_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]])
#define UN_NIL_ENCODE(s) (s==nil || [s isKindOfClass:[NSNull class]]||[@"" isEqualToString:s]?@"":[Tools base64Encode:s])
#define UN_NIL_DECODE(s) (s==nil || [s isKindOfClass:[NSNull class]]||[@"" isEqualToString:s]?@"":[Tools base64Decode:s])

#define STR_IS_NIL(key) (([@"<null>" isEqualToString:(key)] || [@"" isEqualToString:(key)] || key == nil || [key isKindOfClass:[NSNull class]]) ? 1: 0)

//颜色值转换
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXCOLOR2(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


//判断是否是iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//根据view现有(iphone4 320*480)frame大小适配iphone5的界面（320*568）（iphone5offy = 568-480 = 88)

//（1）.根据原有view（按照320*480界面布局的view)自动适配iphone5的view的frame
#define fitIphone5Frame(view) [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+88, view.frame.size.width, view.frame.size.height)]
//实例代码
// if(iPhone5)
// fitIphone5Frame(Bottomview);

// 主副内容类型定义 高4位保存主类型，低4位保存副内容,用于详情页和编辑页判断
typedef NSInteger DIARY_TYPE;
typedef NS_ENUM(NSInteger, MAJOR_TYPE){
    MAJOR_NONE              = 0<<4 ,
    MAJOR_VIDEO             = 1<<4 ,
    MAJOR_PHOTO             = 2<<4 ,
    MAJOR_LONG_RECORD       = 3<<4
};

// 先进行None的判断，如果不是None的话，再对MINOR_SHORT_RECORD或者MINOR_TXT进行与操作。
typedef NS_ENUM(NSInteger, MINOR_TYPE){
    MINOR_NONE              = 0,    
    MINOR_SHORT_RECORD      = 1<<0,
    MINOR_TXT               = 1<<1
};

typedef NS_ENUM(NSInteger, ATTACH_VIDEO_TYPE)
{
    ATTACH_VIDEO_TYPE_LOW_QUALITY,                  // 普清
    ATTACH_VIDEO_TYPE_LOW_REENCODE_NOT_WATERMARK,   // 普清转码未压标
    ATTACH_VIDEO_TYPE_LOW_REENCODE,                 // 普清压标
    ATTACH_VIDEO_TYPE_HIGH_QUALITY,                 // 高清
    ATTACH_VIDEO_TYPE_HIGH_REENCODE,                // 高清压标
};

typedef NS_ENUM(NSInteger, ATTACH_PHOTO_TYPE)
{
    ATTACH_PHOTO_ORIGIN,
    ATTACH_PHOTO_WATERMARK,
};
//snsType定义(与协议文档定义一致)
typedef enum
{
    SNS_TYPE_SINA = 1, //新浪微博
    SNS_TYPE_TENCENT = 6, //腾讯微博
    SNS_TYPE_RENREN = 2 //人人网
} SNS_TYPE;

//定义视图浏览模式
typedef  enum {
    MAP_MODE = 0, //地图模式
    LIST_MODE = 1 //列表浏览模式
} MODE_VIEW_TYPE;

//获取十五种展示模式
typedef enum
{
    //视频
    VIDEO_NO_AUXILIARY_ATTACH       = 1,            //只有主附件，没有辅附件
    VIDEO_HAS_ONE_AUXILIARY_VOICE_ATTACH    = 2,    //有：主附件，语音辅附件
    VIDEO_HAS_ONE_AUXILIARY_WORDS_ATTACH    = 3,    //有：主附件，文字辅附件
    VIDEO_HAS_TWO_AUXILIARY_ATTACH  = 4,            //有：主附件，语音辅附件，文字辅附件
    
    //录音
    AUDIO_NO_AUXILIARY_ATTACH       = 5,            //只有主附件，没有辅附件
    //AUDIO_HAS_ONE_AUXILIARY_VOICE_ATTACH    = 6,    //有：主附件，语音辅附件
    AUDIO_NO_MAIN_ATTACH            = 6,            //无主附件，有两个辅附件
    AUDIO_HAS_ONE_AUXILIARY_WORDS_ATTACH    = 7,    //有：主附件，文字辅附件
    AUDIO_HAS_TWO_AUXILIARY_ATTACH  = 8,            //有：主附件，语音辅附件，文字辅附件
    
    //图片
    IMAGE_NO_AUXILIARY_ATTACH       = 9,            //只有主附件，没有辅附件
    IMAGE_HAS_ONE_AUXILIARY_VOICE_ATTACH    = 10,   //有：主附件，语音辅附件
    IMAGE_HAS_ONE_AUXILIARY_WORDS_ATTACH    = 11,   //有：主附件，文字辅附件
    IMAGE_HAS_TWO_AUXILIARY_ATTACH  = 12,           //有：主附件，语音辅附件，文字辅附件
    
    //文字
    //    WORDS_NO_AUXILIARY_ATTACH       = 13,           //只有主附件，没有辅附件
    //    WORDS_HAS_ONE_AUXILIARY_VOICE_ATTACH    = 14,   //有：主附件，语音辅助附件
    //    WORDS_NO_MAIN_ATTACH            = 15            //没有主附件
    
    AUXILIARY_ATTACH_WORDS = 13,
    AUXILIARY_ATTACH_VOICE = 14,
    AUXILIARY_ATTACH_WORDS_AND_VOICE    = 15,
    
    
} CELL_DISPLAY_STYLE;

typedef enum
{
    MAP_STYLE_WITH_MYLOCATION, //需要在地图上展现自己的位置,(附近)
    MAP_STYLE_WITHOUT_MYLOCATION, //不需要在地图上展现自己的位置
} MAP_STYLE;

#define DIARY_CREATE_TIME_DEFAULT_FORMAT @"yyyy-MM-dd"

//LOG
#ifdef DEBUG
#   define JLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define JLog(...)
#endif

//规格尺寸
#define IS_IPHONE5 (CGRectGetHeight([[UIScreen mainScreen] bounds]) == 568)
#define APPLICATION_WIDTH CGRectGetWidth([[UIScreen mainScreen] applicationFrame])
#define APPLICATION_HEIGHT CGRectGetHeight([[UIScreen mainScreen] applicationFrame])

#define TITLE_FONT 22

//经纬度无效值标示码
#define GIS_INFO_WRONG_CODE  @"-200"
//纬度合法性校验
#define LATITUDE_VALID(s) ([Tools isLatitudeValid:s] ? s: GIS_INFO_WRONG_CODE)
//经度合法性校验
#define LONGITUDE_VALID(s) ([Tools isLongitudeValid:s] ? s : GIS_INFO_WRONG_CODE)

#define SHOWWAITING(xxx) [LL_GLOBAL_SERVICE.progressHUDExtend showWaitingWithText:xxx]
//#define SHOWWAITINGALWAYS(xxx) [LL_GLOBAL_SERVICE.progressHUDExtend showWaitingAlways:xxx]
#define HIDEWAITING [LL_GLOBAL_SERVICE.progressHUDExtend hideWaiting]

#define RECONIZE_GAP 15
#define RECONIZE_WAIT_TOTALTIME 600

#define IS_HAVE_TASK_CONDITION 0


//是否有偷拍功能
#define OPEN_TOUPAI  1
