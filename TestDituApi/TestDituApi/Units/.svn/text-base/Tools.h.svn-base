//
//  Tools.h
//  VideoShare
//
//  Created by zengchao on 13-5-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiaryData.h"
#import "LLDaoModelDiary.h"
#import "FXLabel.h"
#import "Global.h"
#import "MarkData.h"
#import "NetUrlLength.h"
#import "NetUrlStatusAndType.h"

#define TAG_REQUEST_SUCCESS_ALERT 556677

@interface Tools : NSObject

@property( nonatomic,strong) NetUrlLength* netUrlLength;
@property( nonatomic,strong) NetUrlStatusAndType* netUrlStatusAndType;

+ (UIImage *) imageWithView:(UIView *)view;
+(UIImage *)createImageWithColor:(UIColor *)color;//纯色图片1X1
+(UIImage *)createImageWithColor:(UIColor *) color :(CGRect)r;//纯色图片
+(UIImage*)createRoundedCornerImageWithoutBorder:(UIImage*)image :(CGFloat)cornerRadius;
+(BOOL)checkImageValid:(UIImage*)image;//检查图片是否有效
+ (CGRect)statusBarFrameViewRect:(UIView*)view;
+(UIWindow*)getKeyWindow;
+(void)showDialog:(NSString*)message;

//add by xudongsheng
+(NSArray *) bubbleSortWithDoubleArray:(NSArray *)unsortArray; //冒泡排序(输入:double类型的一组数)
+(NSArray *) bubbleSortWithCGPointArray:(NSArray *)unsortArray;//冒泡排序(输入:CGpoint类型的一组数)

+ (int)convertToInt:(NSString*)strtemp;  //计算字符串长度
+ (int)convertToInt2:(NSString*)strtemp;
+(BOOL)copyVideoFromSourcePathToDest:(NSString*)sourcePath :(NSString*)destTmpPath;
+ (NSString *)stringFromTime:(NSInteger)time;


//base64 字符编解码
+(NSString *)base64Decode:(NSString *)base64;
+(NSString *)base64Encode:(NSString *)string;


//利用正则表达式验证邮箱
+(BOOL)isValidateEmail:(NSString *)email;
//验证手机号码格式是否正确  只验证是不是十一位数字
+(BOOL)isValidatePhoneNumber:(NSString *)phonenumber;
//验证码格式是否正确  与服务器端确认6位数字
+(BOOL)isVerificationCode:(NSString *)phonenumber;

+(void)saveImage:(UIImage*)image :(NSString*)fullPath;
+(void)thumbnailImageForVideo:(NSString *)fileFullPath atPersent:(float)persent :(void (^)(UIImage* image))block;
+(UIImage*)thumbnailImageForVideoSyn:(NSString *)fileFullPath atPersent:(float)persent;
+(NSString*)saveFrontCover:(UIImage*) image :(NSString*)videoSourceid;
+(NSString*)frontCover:(NSString*)videoSourceid;

+(NSString*)identifierString;
//xxx-xxx-xxx_1 to xxx-xxx-xxx
+(NSString*)stringMoveNumberSuffix:(NSString*)string;
//"" to  xxx-xxx-xxx_1 to xxx-xxx-xxx_2
+(NSString*)identifierStringIncreaseNumberSuffix:(NSString*)exsitIdentifierString;
+(NSString*)SuffixNumberOfIdentifierString:(NSString*)exsitIdentifierString;
+(BOOL)isNumeric:(NSString*)inputString;
//数组转换成json串
+(NSString *)arrayIntoJson:(NSArray *)array;
+(NSMutableArray *)jsonIntoArray:(NSString *)json error:(NSError **)error;

//获取瀑布流日记展示风格
+(int)getCollentionDiaryDisplayStyle:(DiaryData *)d_data;

/**
 * 功能：由一个diarydate 转换成一个lldaomodeldiary
 * 参数：(DiaryData *)diaryData
 * 返回值：LLDaoModelDiary （日记数据库表）
 
 * 创建者：capry chen
 * 创建日期：2013-06-13
 */
+(LLDaoModelDiary *) convertDiaryDataToLLDaoModelDiary:(DiaryData *)diaryData;

/**
 * 功能：由一个LLDaoModelDiary 转换成一个DiaryData
 * 参数：(LLDaoModelDiary *)llDaoModelDiary
 * 返回值：DiaryData （日记网络数据模型）
 
 * 创建者：capry chen
 * 创建日期：2013-06-13
 */
+(DiaryData *) convertLLDaoModelDiaryToDiaryData:(LLDaoModelDiary *)llDaoModelDiary;

+(LLDaoModelDiaryTagCell*)convertMarkCellToLlDaoModelDiaryTagCell:(MarkCell*)markCell;

/**
 * 功能：判断日记数据更新与否
 * 参数：(LLDaoModelDiary *)llDaoModelDiary
 * 返回值：DiaryData （日记网络数据模型）
 
 * 创建者：capry chen
 * 创建日期：2013-06-13
 */
/*更新逻辑：
 根据“更新时间”字段判断本地数据是否是最新得。
如果判断更新了，还要分别判断附件url是否改变如果改变则清除本地附件并更新数据库中附件得url。
 并且判断下载队列中如果有旧附件得下载任务，则移出下载队列并且删除已下载得内容。
 */
+(void) isDiaryDataUpdate:(NSMutableArray *)diaryDataArray;

/**
 * 功能：将modeldiary 数组转换成为diarydata数组
 * 参数：(LLDaoModelDiary *)llDaoModelDiary
 * 返回值：DiaryData （日记网络数据模型）
 
 * 创建者：capry chen
 * 创建日期：2013-06-13
 */
+(NSMutableArray *) changeModelDiaryToDiaryDataArray:(NSArray *)modelDiaryArray;

/**
 * 功能：把文件从源路径移动到目标路径
 * 参数：(NSString*)tmppath 文件原路径
        (NSString*)newpath  目标路径
        (BOOL)isSourceFileDelete 是否删除源文件(YES:删除 NO:不删除)
 * 返回值：BOOL （YES:成功 NO:失败）
         
 * 创建者：xudongsheng
 * 创建日期：2013-06-15
 */
+(BOOL)moveFileFromSourcePathToNewPath:(NSString*)sourcePath newpath:(NSString*)newpath isSourceFileDelete:(BOOL)isSourceFileDelete;
/**
 *弹出的视图是否存在
 */
+(BOOL)alertViewExsit:(NSInteger)tag;
/*
  播放ImageView组合动画
 */
+(void)setImageViewCombineAnimation:(UIImageView*)targetImageView iamges:(NSArray*)images animationDuration:(NSTimeInterval)animationDuration animationRepeatCount:(NSInteger)animationRepeatCount;
+(NSString *)dateFormat:(NSString *)format timeMilli:(NSNumber *)milli;
+(NSString *)timeMilliFrom:(NSDate*)date;
+(NSString*)timeMilliFrom:(NSString*)date format:(NSString*)format;
+(NSString*)makeLogString:(NSString*)videourl :(NSString*)videoid;

//数组解析,数组如果从json转过来的话,里面是字典,此函数将里面的字典都转成对象
+(void)arrayToClass:(NSMutableArray*)array :(Class)theClass;
+ (long long) calculatefolderSizeAtPath:(NSString*) folderPath;
// 获取出来是以M为单位的
+ (float) calculatefolderSizeAtPathM:(NSString*) folderPath;

//解析录音播放url, 录音附件类别 attachLevel(0:辅附件 1:主附件)
+(NSString*)parsingAudioUrlByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel;
//解析录音播放url, 录音附件类别 attachLevel(0:辅附件 1:主附件)
+(NSString*)parsingAudioPlayTimeByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel;
//解析录音播放uuid, 录音附件类别 attachLevel(0:辅附件 1:主附件)
+(NSString*)parsingAudiouuidByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel;
//从日记数据中解析出文字内容 文字附件类别 attachLevel(0:辅附件 1:主附件)
+(NSString*)parseTextDescByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel;
//从日记数据中解析出图片Url  图片附件类别 attachLevel(0:辅附件 1:主附件)
+(NSString*)parseImageUrlByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel;
//从日记数据中解析出图片uuid  图片附件类别 attachLevel(0:辅附件 1:主附件)
+(NSString*)parseImageuuidByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel;
//解析视频封面url
+(NSString*)parseVideoCover:(DiaryData*) diaryData;
//解析视频播放地址
+(NSString*)parseVideoPlayUrl:(DiaryData*) diaryData attachLevel:(int)attachLevel;
//解析视频播放uuid
+(NSString*)parseVideoUuid:(DiaryData*) diaryData attachLevel:(int)attachLevel;
//解析录音时长
+(NSString *)parseAudioPlayTime:(DiaryData *)diaryData;
//解析短录音时长
+(NSString *)parseShortAudioPlayTime:(DiaryData *)diaryData;
//获取视频或者图片要显示的 宽和高
+(NSMutableDictionary *)parseVideoImageWidthAndHeight:(DiaryData *)diaryData;

+(void)setFXLabelShadowText:(FXLabel*)label labelText:(NSString*)labelText labelFont:(UIFont*)labelFont;

// 获取富文本Label
+(UIView *)getRichText : (NSString *) message :(int)width :(int)lines;
// 获取富文本Size
+(CGRect)getRichTextSize : (NSString *) message :(int)width :(int)lines;
//获取所有的标签列表
+(void)getAllMarkList:(void(^)(BOOL isSuccess, NSMutableArray* marksArray))mainBlock;
//判断本地存放的标签是否过期并同步更新数据库
+(void)checkMarksValidAndUpdateDb;
+(CGSize)imageFileSize:(NSString*)imageFile;
//判断纬度是否合法
+(BOOL)isLatitudeValid:(NSString*)latitudeStr;
//判断经度是否合法
+(BOOL)isLongitudeValid:(NSString*)longitudeStr;
//地址是否合法
+(BOOL)locationIsValid:(NSString*)latitudeStr longitudeStr:(NSString*)longitudeStr;

+(void)showStatusToStatusBar:(NSString *)content delegate:(id)delegate statutype:(BOOL)type viewtpye:(UIWindow *)window;
+(void)showStatusArrayToStatusBar:(NSArray *)contentArray delegate:(id)delegate statutype:(BOOL)type viewtpye:(UIWindow *)window;
+(NSString*)getDateTimeFrom:(NSString*)timeIn;

/**
 * 功能：判断是不是在当天
 * 参数：时间str
 * 返回值：处理后的时间
 
 * 创建者：capry chen
 * 创建日期：2013-07-13
 */
+ (BOOL) isCurrentDay:(NSDate *)nowDate;

/**
 * 功能：判断是不是今年
 * 参数：时间str
 * 返回值：处理后的时间
 
 * 创建者：capry chen
 * 创建日期：2013-07-13
 */
+ (BOOL) isCurrentYear:(NSDate *)nowDate;

/**
 * 功能：获取时间如果时间小于一小时则显示多少分钟之前
 * 参数：时间str
 * 返回值：处理后的时间
 
 * 创建者：capry chen
 * 创建日期：2013-07-13
 */
+(NSString*)getDateFormatFrom:(NSString*)timeIn;

/**
 * 功能：获取格式化的时间字符串
 * 参数：times 时间，以毫秒为单位
 * 参数：format 返回字符串的格式
 */
+ (NSString *)getFullDateWithStringDateTime:(NSString *)time Format:(NSString *)format;

/**
 * 功能：获取格式化的时间字符串
 * 参数：times 时间，以毫秒为单位
 * 参数：format 返回字符串的格式
 */
+ (NSString *)getFullDateWithIntvDateTime:(long long)time Format:(NSString *)format;

/**
 * 功能：获取格式化的时间字符串
 * 参数：times 时间，以毫秒为单位,格式为YYYY-MM-dd HH:mm
 */
+ (NSString *)getDefaultFormatDateWithDateTime:(NSString *)time;

+(NSString*)seprateToDeleteStr:(NSString *)str;


//将字符串类型的路径转换成NSURL格式
+(NSURL*)convertUrlStrToNSURL:(NSString*)urlString;

+(UIImage*)imageByScalingAndCroppingForSize:(UIImage *)sourceImage withTargetSize: (CGSize)targetSize;

+ (UILocalNotification *)setLocalNotification:(int)number :(NSString*)str;
+(UIImage*)UIImageScaleToSize:(UIImage*)sourceImg :(CGSize)size;

/**
 * 功能：根据日记id获取日记内容（用于查看副本之类得上一级页面没有传过来得）
 * 参数：(NSString *)diaryId 日记 (void(^)(RIA_RESPONSE_CODE riaResponseCode))block 回调代码块(成功得时候就重新从数组中获取日记数据，失败了提示当前日记数据暂时无法获取）
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-03
 */
+(void) getDiaryContent:(NSString *)diaryId block:(void(^)(RIA_RESPONSE_CODE riaResponseCode, DiaryData *resultData))block;

/*
 * 时间戳转成 xx'xx''显示的格式
 */
+ (NSString *)getDurationText:(NSTimeInterval)duration;

/*
 * 时间格式转换成时间戳
 */
+ (NSString *)getDateFormatToTimeStamp:(NSString *)timestr;

/**
 * 功能：删除服务器要删除的日记
 * 参数：服务器回传的removeids
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013－07－17
 */
+ (void) deleteModelDiary:(NSString *)diaryids block:(void(^)(BOOL result)) block;

+(double)mediaDuration:(NSString *)fileFullPath;

/*
 * 排序（按时间）
 */
+ (void)orderByUpdateTime : (NSMutableArray *)array;

//取系统剩余空间
+(long long)getSystemFreeSpace;

/**
 * 功能: 从指定位置copy文件到指定的位置
 * 参数：服务器回传的removeids
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013－07－17
 */
+(void)copyLocalFileFrom:(NSString *)fromLocalFilePath to:(NSString *)toLocalFilePath;
//获取网络文件的大小
+(void)getNetUrlLength:(NSString*)url :(void (^)(unsigned long long length))block;
+(void)getNetUrlStatusAndType:(NSString*)url :(void (^)(int status,NSString* type,unsigned long long length))block;
@end


