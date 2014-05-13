//
//  effects_define.h
//  effectslib
//
//  Created by xi penggang on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef effectslib_effects_define_h
#define effectslib_effects_define_h

#include <stdint.h>
#include "version.h"

#if __ARM_NEON__
#define USE_NEON
#endif

#define MAX_PCM_BUFFER          192000 // 1 second of 48khz 32bit audio

#define LIBEFFECT_VERSION lib_effect_version

typedef enum {
    KEF_TYPE_NOTHING = 0,
    KEF_TYPE_GRAY,//              //灰度特效
    KEF_TYPE_ADDRGB,//            //增强颜色值特效
    KEF_TYPE_BW,//                //黑白特效
    KEF_TYPE_LUM_CT,//            //亮度对比度特效
    KEF_TYPE_PALETTE,             //调色板特效       //2(17种变色特效)
    
    KEF_TYPE_TWIRL,//             //扭曲特效
    KEF_TYPE_PINCH,//             //凹特效
    KEF_TYPE_POUCH,//             //凸特效
    KEF_TYPE_FLASH,//             //放射特效
    
    KEF_TYPE_FLIP,//              //上下颠倒特效
    KEF_TYPE_FOLD_LR,//           //左右折叠
    KEF_TYPE_FOLD_TB,//           //上下折叠
    KEF_TYPE_MOSAIC,//            //马赛克特效
    KEF_TYPE_GRAYFILM,//          //黑白底片效果
    KEF_TYPE_FILM,                //彩色底片效果     //2
    
    KEF_TYPE_RELIEVO,//           //浮雕特效
    
    KEF_TYPE_SKETCH,//            //素描特效
    KEF_TYPE_GRAY_SKETCH,         //黑白素描特效
    KEF_TYPE_SKETCH_CHALK,        //彩色粉笔画       //2
    KEF_TYPE_SKETCH_LOG,          //手绘  log算子
    KEF_TYPE_SKETCH_LP,           //手绘  lp算子
    KEF_TYPE_SKETCH_PRET,         //手绘  pret算子
    
    KEF_TYPE_PAINTING,//          //油画效果
    KEF_TYPE_WATERCOLOUR,         //水彩画效果       //2
    KEF_TYPE_SPLASHINK,           //泼彩画
    
    KEF_TYPE_D3,                  //3d效果        //2
    
    KEF_TYPE_LIGHTRING,//         //光斑效果
    
    KEF_TYPE_PHOTOFRAME,//        //相框
    KEF_TYPE_ANIMATION,//         //动画
    
    KEF_TYPE_BRIGHTEN,//          //变亮叠加效果      //2
    
    KEF_TYPE_BOPU,//              //波普特效        //2
    
    //根据阴影纹理不同分为5种效果
    KEF_TYPE_HATCH,             //斜线-漫画效果  //2
    KEF_TYPE_NORMAL,                            //2
    KEF_TYPE_HALFONE,                           //2
    KEF_TYPE_CROSSHATCH,                        //2
    KEF_TYPE_OLDPAPER,          //旧报纸         //2
    
    KEF_TYPE_AXIS,              //移轴        //2
    
    KEF_TYPE_ZOOM,//              //数字变焦  [暂时算一个特效]
    KEF_TYPE_CWR_90,//             //顺时针转90+翻转  【暂时先占一个位置吧】
    
    KEF_VIDEO_NUMBER,              //视频特效总数
    
    KEF_TYPE_AUDIOSYNTHESIS,//    //音频合成
    KEF_TYPE_ADD_MUSIC,             //配乐
    KEF_TYPE_DUB,                   //配音
    EFF_TYPE_TOM_CAT,               //汤姆猫
    EFF_TYPE_DALAY,                 //延时
    EFF_TYPE_LOW_FREQUENCY,         //低频
    EFF_TYPE_ALIEN,         //外星人
    KEF_AUDIO_NUMBER
}en_ef_type;


extern const char  *g_arr_name[];

//image data type.
enum tagDATATYPE{
    DATA_TYPE_32RGBA = 4,
    DATA_TYPE_24RGB  = 3,
    DATA_TYPE_8      = 1
};

enum tagTWIRLTYPE{
    TWIRL_TYPE_POUCH = 0,
    TWIRL_TYPE_PINCH = 1,
    TWIRL_TYPE_TWIRL = 2
};


typedef struct struCoordinate
{
    uint16_t x;
    uint16_t y;
}stru_POINT;

typedef struct struRect
{
    int top;
    int left;
    int width;
    int height;
}stru_RECT;

//about ios color struct.**********begin.
//根据具体情况添加。
typedef struct tagIOSARGB{
    uint8_t blue;
    uint8_t green;
    uint8_t red;
    uint8_t alpha;
}bgra;
typedef struct tagIOSRGBA
{
    uint8_t red;
    uint8_t green;
    uint8_t blue;
    uint8_t alpha;
}rgba;
typedef struct tagIOSGBRA{
    uint8_t green;
    uint8_t blue;
    uint8_t red;
    uint8_t alpha;
}gbra;

typedef struct tagIOSRBGA{
    uint8_t red;
    uint8_t blue;
    uint8_t green;
    uint8_t alpha;
}rbga;

typedef struct tagBGR565
{
    unsigned int blue:5;
    unsigned int green:6;
    unsigned int red:5;
}bgr565;

typedef enum enColorType{
    ef_color_type_rbga = 0,
    ef_color_type_bgra,
    ef_color_type_rgba,
    ef_color_type_gbra
}en_ef_COLOR_TYPE;

//about ios color struct.**********end.


#if(TARGET_IPHONE_SIMULATOR | TARGET_OS_IPHONE)
typedef bgra RGBAOGJ;
#else
typedef rgba RGBAOGJ;
#endif

struct tagVEFFECTSSETS;
typedef struct tagVEFFECTSSETS* AV_EF;
typedef void (*ef_func)(AV_EF p,
                        const unsigned char* psrcdata,
                        const int ntype,
                        const int width,
                        const int height,
                        unsigned char* pdstdata);

#define EFFECTE_FUNC_DEFINE(name) \
    void ef_##name (AV_EF p, \
    const unsigned char* psrcdata,\
    const int ntype,\
    const int width, \
    const int height, \
    unsigned char* pdstdata)


typedef struct struFace
{
    stru_RECT           bounds;
    int                 haslefteye;
    stru_POINT          ptlefteye;
    int                 hasrighteye;
    stru_POINT          ptrighteye;
    int                 hasmouth;
    stru_POINT          ptmouth;   
}stru_FACE;


/**
 @类型：结构体。
 @作用：配音/视频特效是以流的方式添加时。
 **/
typedef struct struEffectStream
{
    char                    filename[1024];     //文件名
    struct AVFormatContext  *avft;              //流对象
    void*                   pSampleContext;     //音频数据适配
    double                  currtime;           //流当前时间
    int                     isopen;
    double                  percent;            //特效合成是所占的%比
    
    unsigned char           *buffer;            //缓存缓存比较大的数据。
    long                    nlen;               //缓存中数据多少。
    unsigned char           *musicbuffer;       //一个临时变量用来存放音乐数据;
    
    int                     vindex;             //视频流索引
    int                     aindex;             //音频流索引
    
    //当配乐时用下列参数记录采集的或者被编辑的音频数据的信息。
    int                     BitsPerChannel;         //采样精度
    int                     Channels;               //声道数
    int                     SampleRate;             //采样率
    
    //关于配乐在目的媒体中的位置
    /**
     @DstTotalTime:目标文件的总时间长度。
     @StartTime:配乐在目的媒体中的开始时间
     @EndTime:配乐在目的媒体中的结束时间
     @说明:当EndTime为0时，配乐文件到结尾为止。
     @Adding:当当前播放时间超出配音时间范围时该值为0
     @isLoop:是否循环
     **/
    double                  DstTotalTime;
    double                  StartTime;         
    double                  EndTime;
    int                     Adding;
    int                     isLoop;
}stru_EFFECT_STREAM;

//保存音频信息
typedef struct strAudioInfo {
    int                     BitsPerChannel;         //采样精度
    int                     Channels;               //声道数
    int                     SampleRate;             //采样率
}stru_AUDIOINFO;

//声音美化时使用。
typedef struct strAudioInflexion{
    //输入的音频参数。
    stru_AUDIOINFO  audio_info;
    //输出的数据大小
    int             size;
    //当需要保存数据时创建下边缓存区。
    short   buffer[MAX_PCM_BUFFER];
    long            len;                //buffer中数据的长度。
    
    //这两个参数主要保存音频延迟效果上一包数据处理的情况
    int             noffset;            //该数据块的偏移量
    int             packindex;         // 指示包的参数
    //外星人特效参数
    float   sin_buffer[266];    //sin缓冲空间
    float   sin_buffer1[398];  //sin缓冲空间1
    float   sin_buffer_index;          //sin下标标示
    float   sin_buffer_index1;         //sin下标标示1
    
    float   volume;             //音量大小   暂定0-1之间的小数

}stru_AUDIOINFLEXION;

typedef struct struPalette{
    uint8_t                p_r[256];
    uint8_t                p_g[256];
    uint8_t                p_b[256];
}stru_PALETTE;

//长方形、圆形参数列表。
//总共两种特效，
//长方形：以rect开头
//圆形：  以cir开头
//x、y为响应的touch坐标
//type为特效类型
typedef struct struAxis{
    uint16_t rect_radia;          //长方形清晰部分半径
    uint16_t rect_radiay1;        //长方形上边沿渐变半径
    uint16_t rect_radiay2;        //长方形下边沿渐变半径
    float   rect_step;            //长放形渐变效果a渐变步长
    float   rect_init;            //长方形渐变效果a初始值
    uint16_t cir_radia;           //圆形内环半径
    uint16_t cir_radia_r;         //圆形外环半径
    float   cir_step;             //圆形渐变效果a渐变步长
    int16_t x_value;              //响应手指touch点的x坐标
    int16_t y_value;              //响应手指touch点的y坐标
    uint16_t rect_cirle_type;     //圆形方形特效类型标示符
}stru_AXIS;


//该结构主要用来前段创建特效所用。前端可以维护很多特效对象。
/**
 @类型：结构体
 @用处：用来创建一个特效链
 **/
typedef struct tagVEFFECTSSETS
{
    en_ef_type      ef_type;                    //特效
    int             ntag;                       //用户标识
    
    //特效方法
    ef_func         pfunc;
    
    //and R G B value.
    int             nred;                 //颜色值：0-100
    int             ngeen;
    int             nblue;
    
    //黑白特效中间值  
    int             nv;                     //厥值 0-255
    
    //luminance and contrast.
    int             luminance;               //亮度值：-255-255
    float           contrast;                //对比度：0-5.0 
    uint8_t         lctable[256]; 
    
    //about palette.
    stru_PALETTE    palette;
    
    //about axis.
    stru_AXIS       axis;
    
    //add photo frame
    unsigned char *framedata;
    int left;                              
    int top;
    int width;
    int height;
    
    //Scaling factor
    float factor;                           //最好在1.0-5.0
    
    //twirl 
    int twirltype;
    stru_POINT *pttable;                    //复杂运算的对照表
    stru_RECT tablerect;                    //矩阵大小。
    stru_RECT pinchrect;                    //pinch方式时中间部分大小  无需在设置时赋值。
    
    //about audio effects.
    unsigned char *audiodata;               //需要融合的音频数据
    long audiooffset;                       //已经融合的音频偏移量
    long audiodatalen;                      //音频数据总长度
    
    //用文件作为特效资源时
    stru_EFFECT_STREAM efstream;           //特效是用流方式给进来时。
    
    //about mosaic.
    int nMosaic;
    
    //该参数按照需要放置相关参数
    void* pexpand;
    
    struct tagVEFFECTSSETS *pnext;
}stru_effects_parameter;


#include "sys/time.h"

#if(defined(ANDROID))
#include <android/log.h>
#define  LOG_TAG    "ZC_libeffect_Effects"
#endif

//公共定义
//speech time debug.
//#define _EF_IS_PRINT_TIME_DEBUG_
#ifdef _EF_IS_PRINT_TIME_DEBUG_
#define _EF_TIME_DEBUG_BEGIN                                \
struct timeval t_start__,t_end__;                       \
gettimeofday(&t_start__, NULL);


#if(defined(ANDROID))
#define _EF_TIME_DEBUG_END(n)                                   \
    gettimeofday(&t_end__, NULL);                                   \
    __android_log_print(ANDROID_LOG_INFO,LOG_TAG,                   \
    "[0x%08X] use time:%ld \n",n,                                   \
    (t_end__.tv_sec*1000 + t_end__.tv_usec/1000) -                  \
    (t_start__.tv_sec*1000 + t_start__.tv_usec/1000))  
#else
#define _EF_TIME_DEBUG_END(n)                                   \
    gettimeofday(&t_end__, NULL);                                   \
    printf("[0x%08X] use time:%ld \n",n,                            \
    (t_end__.tv_sec*1000 + t_end__.tv_usec/1000) -                  \
    (t_start__.tv_sec*1000 + t_start__.tv_usec/1000)); 
#endif     

#else
#define _EF_TIME_DEBUG_BEGIN
#define _EF_TIME_DEBUG_END(n)
#endif

//#include <unistd.h>
//#define msleep(x)//usleep(x*100);
//#       define  LOGI(...)  printf("[%s] ", __FUNCTION__); printf(__VA_ARGS__)


//#define _DEBUG_PRINTF_
#ifdef _DEBUG_PRINTF_
#   if(defined(ANDROID))
#       define  LOGI(format, ...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,format,##__VA_ARGS__);
#       define  LOGI_F(format, ...) LOGI("[FU:%s] " format, __FUNCTION__, ##__VA_ARGS__)
#       define  LOGI_FFL(format, ...) LOGI("[FU:%s][FI:%s][LI:%d] " format"\n",  __FUNCTION__, __FILE__,__LINE__, ##__VA_ARGS__);

#       define  FUN_E      LOGI("func:%s,file:%s,line:%d enter",__FUNCTION__,__FILE__,__LINE__);
#       define  FUN_X      LOGI("func:%s exit",__FUNCTION__);
#   else
#       define  LOGI(format, ...)  printf(format, ##__VA_ARGS__);
#       define  LOGI_F(format, ...) LOGI("[FU:%s] " format, __FUNCTION__, ##__VA_ARGS__)
#       define  LOGI_FFL(format, ...) LOGI("[FU:%s][FI:%s][LI:%d] " format,  __FUNCTION__, __FILE__,__LINE__, ##__VA_ARGS__);
#       define  FUN_E      printf("func:%s,line:%d enter",__FUNCTION__,__LINE__);
#       define  FUN_X      printf("func:%s exit",__FUNCTION__);
#   endif
#else
#   define  LOGI(format, ...)
#   define  FUN_E;
#   define  FUN_X;
#endif

#define LOGX(format, ...) LOGI(format, ##__VA_ARGS__)

#if(defined (ANDROID))
#   define  LOGE(format, ...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,"[FU:%s][LI:%d] "format"\n",  __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define LOGE(format, ...) printf("[FU:%s][LI:%d] " format"\n", __FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

#define LOGX_ERROR(format, ...) LOGE(format, ##__VA_ARGS__)

#define CHECK_RGB(rgb) rgb > 255? 255 : rgb < 0? 0 : rgb

//特定环境定义。
#define CHECK_DATA \
if(!psrcdata || !pdstdata || !p) return;

//特定函数使用。
#define EF_HANDLE_BEGIN \
    CHECK_DATA; \
    _EF_TIME_DEBUG_BEGIN; \
    if (ntype == DATA_TYPE_32RGBA) {

#define EF_HANDLE_END(n) \
    } \
    _EF_TIME_DEBUG_END(KEF_TYPE_GRAY);


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] 

//旋转角度
#define MY_PI_ZERO  0           //旋转0度
#define MY_PI_1P2   1           //旋转90度
#define MY_PI_      3           //旋转180度
#define MY_PI_3P2   4           //旋转270度

#ifndef max
#define max(a,b)	(((a)>(b))?(a):(b))
#endif

#ifndef min
#define min(a,b)	(((a)<(b))?(a):(b))
#endif

/*
./configure \
--enable-cross-compile \
--target-os=darwin \
--arch=arm \
--cpu=cortex-a8 \
--extra-cflags='-arch armv7' \
--extra-ldflags='-arch armv7' \
--enable-pic \
--enable-neon \
--cc=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc \
--cross-prefix=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ \
--as='gas-preprocessor.pl /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc' \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.1.sdk \
--extra-cflags="-mfpu=neon -mfloat-abi=softfp" \
--extra-ldflags="-mfpu=neon -mfloat-abi=softfp" \
--extra-ldflags=-L/users/xpg-2007/xpg-work/x264-snapshot-20120531-2245/dist/lib \
--extra-cflags=-I/users/xpg-2007/xpg-work/x264-snapshot-20120531-2245/dist/include \
--extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.1.sdk/usr/lib/system \
--disable-ffmpeg \
--enable-libx264 \
--enable-gpl \
--disable-ffplay \
--disable-ffserver \
--disable-doc \
--disable-asm \
--disable-avfilter \
--disable-filters \
--disable-network \
--disable-bsfs \
--disable-indevs \
--disable-postproc \
--disable-stripping \
--disable-debug 
*/

/*
 //this is video effects define.
 #define KEF_TYPE_GRAY               0x00000001   //灰度特效
 #define KEF_TYPE_ADDRGB             0x00000002   //增强颜色值特效
 #define KEF_TYPE_BW                 0x00000004   //黑白特效
 #define KEF_TYPE_LUM_CT             0x00000008   //亮度对比度特效
 
 #define KEF_TYPE_TWIRL              0x00000010   //图像凹凸特效
 #define KEF_TYPE_FLASH              0x00000020   //放射特效
 
 #define KEF_TYPE_FLIP               0x00000040   //上下颠倒特效
 #define KEF_TYPE_FOLD_LR            0x00000080   //左右折叠
 #define KEF_TYPE_FOLD_TB            0x00000100   //上下折叠
 #define KEF_TYPE_MOSAIC             0x00000200   //马赛克特效
 #define KEF_TYPE_GRAYFILM           0x00000400   //黑白底片效果
 
 #define KEF_TYPE_RELIEVO            0x00001000   //浮雕特效
 #define KEF_TYPE_SKETCH             0x00002000   //素描特效
 #define KEF_TYPE_PAINTING           0x00004000   //油画效果
 
 #define KEF_TYPE_LIGHTRING          0x00100000   //光斑效果
 
 #define KEF_TYPE_PHOTOFRAME         0x00010000   //相框
 #define KEF_TYPE_ANIMATION          0x00020000   //动画
 #define KEF_TYPE_AUDIOSYNTHESIS     0x00040000   //音频合成
 
 #define KEF_TYPE_ZOOM               0x80000000   //数字变焦  [暂时算一个特效]
 #define KEF_TYPE_CWR_90             0x40000000   //顺时针转90+翻转  【暂时先占一个位置吧】
 */



#endif
