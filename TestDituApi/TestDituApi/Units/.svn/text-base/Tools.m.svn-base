//
//  Tools.m
//  VideoShare
//
//  Created by zengchao on 13-5-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

//工具类,用静态方法实现常用工具功能

#import "Tools.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomAlert.h"
#import "LocalResourceModel.h"
#include <objc/runtime.h>
#import "JSONKit.h"
#import "NSObject+ABJsonConverter.h"
#import "GTMBase64.h"
#import "LocalResourceModel.h"
#import "LLDaoBase.h"
#import "SpaceCollectionViewCell.h"
#include <dirent.h>
#include <sys/stat.h>
#import "RCLabel.h"
#import "LLUserDefaults.h"
#import "MarkData.h"
#import "CustomStatusBarNotifierView.h"
#import "LLTaskManager.h"
#import "LLFreeTaskManager.h"
#import "LLGlobalService.h"
#import "UIViewAdditions.h"
#import "DiaryData.h"
#import "GetMessageModel.h"
#import "DiaryDetailsModel.h"

@implementation Tools

@synthesize netUrlLength = _netUrlLength;

-(id)init
{
    if(self = [super init])
    {
        self.netUrlLength = [[NetUrlLength alloc] init];
        self.netUrlStatusAndType = [[NetUrlStatusAndType alloc] init];
    }
    return self;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *) createImageWithColor: (UIColor *) color : (CGRect)r
{
    CGRect rect=r;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImage*)createRoundedCornerImageWithoutBorder:(UIImage*)image :(CGFloat)cornerRadius{
    //转圆角
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:cornerRadius] addClip];
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+(BOOL)checkImageValid:(UIImage*)image
{
    BOOL result = NO;
    if (image) {
        CGImageRef cgref = [image CGImage];
        CIImage *cim = [image CIImage];
        if (cim == nil && cgref == NULL)
        {
            result = NO;
        }
        else
        {
            result = YES;
        }
        //CGImageRelease(cgref);
    }
    return result;
}

+ (CGRect)statusBarFrameViewRect:(UIView*)view
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect statusBarWindowRect = [view.window convertRect:statusBarFrame fromWindow: nil];
    
    CGRect statusBarViewRect = [view convertRect:statusBarWindowRect fromView: nil];
    
    return statusBarViewRect;
}

+(UIWindow*)getKeyWindow
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

+(void)showDialog:(NSString*)message
{
    CustomAlert* dialog = [[CustomAlert alloc] init];
    [dialog setMessage:message];
    [dialog addButtonWithTitle:@"确定"];
    [dialog show];
}

//冒泡排序(输入:double类型的一组数)
+(NSArray *) bubbleSortWithDoubleArray:(NSArray *)unsortArray{
    NSMutableArray* targetArray = [[NSMutableArray alloc]initWithArray:unsortArray];
    int count = [unsortArray count];
    for(int i = 0; i < count -1; i++){
        for(int j=0; j < count - i - 1; j++){
            double currentNum = [[targetArray objectAtIndex:j]doubleValue];
            double nextNum = [[targetArray objectAtIndex:(j+1)]doubleValue];
            if(currentNum > nextNum){
                double temp = nextNum;
                [targetArray replaceObjectAtIndex:(j+1) withObject:[NSNumber numberWithDouble:currentNum]];
                [targetArray replaceObjectAtIndex:(j) withObject:[NSNumber numberWithDouble:temp]];
            }
        }
    }
    return targetArray;
}

+(NSArray *) bubbleSortWithCGPointArray:(NSArray *)unsortArray{
    NSMutableArray* targetArray = [[NSMutableArray alloc]initWithArray:unsortArray];
    int count = [unsortArray count];
    for(int i = 0; i < count -1; i++){
        for(int j=0; j < count - i - 1; j++){
            CGPoint currentPoint = [[targetArray objectAtIndex:j]CGPointValue];
            double currentPointX = currentPoint.x;
            CGPoint nextPoint = [[targetArray objectAtIndex:(j+1)]CGPointValue];
            double nextPointX = nextPoint.x;
            if(currentPointX > nextPointX){
                CGPoint tempPoint= nextPoint;
                [targetArray replaceObjectAtIndex:(j+1) withObject:[NSValue valueWithCGPoint:currentPoint]];
                [targetArray replaceObjectAtIndex:(j) withObject:[NSValue valueWithCGPoint:tempPoint]];
            }
        }
    }
    return targetArray;
}



+ (int)convertToInt:(NSString*)strtemp
{
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}
+ (int)convertToInt2:(NSString*)strtemp
{
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}

+(BOOL)copyVideoFromSourcePathToDest:(NSString*)sourcePath :(NSString*)destTmpPath
{
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:sourcePath isDirectory:&isDir]) {
        return NO;
    }
    if (isDir) {
        return NO;
    }
    NSData * movieData = [NSData dataWithContentsOfFile:sourcePath];
    //生成临时文件
    BOOL r = [ movieData writeToFile:destTmpPath atomically:YES];
    return r;
}

+ (NSString *)stringFromTime:(NSInteger)time
{
    NSInteger minutes = floor(time / 60);
    NSInteger seconds = time - minutes * 60;
    NSString *minutesStr = [NSString stringWithFormat:minutes >= 10 ? @"%i" : @"0%i", minutes];
    NSString *secondsStr = [NSString stringWithFormat:seconds >= 10 ? @"%i" : @"0%i", seconds];
    return [NSString stringWithFormat:@"%@:%@", minutesStr, secondsStr];
}

//base64解码
+(NSString *)base64Decode:(NSString *)base64
{
    return  [base64 isKindOfClass:[NSNull class]]?nil:[[NSString alloc] initWithData:[GTMBase64 decodeString:base64 ]encoding:NSUTF8StringEncoding];
}
//base64编码
+(NSString *)base64Encode:(NSString *)string
{
    return [string isKindOfClass:[NSNull class]]?nil: [GTMBase64 stringByEncodingData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}


+(BOOL)isValidateEmail:(NSString *)email {
    //test return value
    //    return YES;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isVerificationCode:(NSString *)verificationcode {
    //test return value
    //    return YES;
    NSString *emailRegex = @"\\b[0-9][0-9][0-9][0-9][0-9][0-9]\\b";//手机号正则表达式
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:verificationcode];
}

+(BOOL)isValidatePhoneNumber:(NSString *)phonenumber {
    //test return value
    //    return YES;
    NSString *emailRegex = @"\\b(1)[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b";//手机号正则表达式
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:phonenumber];
}

//saving an image , ../Documents
+(void)saveImage:(UIImage*)image :(NSString*)fullPath
{
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    [[NSFileManager defaultManager] createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
}

+(void)thumbnailImageForVideo:(NSString *)fileFullPath atPersent:(float)persent :(void (^)(UIImage* image))block {
    if (!STR_IS_NIL(fileFullPath) && [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL * videoURL = [NSURL fileURLWithPath:fileFullPath];
            UIImage* result = nil;
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
            NSParameterAssert(asset);
            AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            assetImageGenerator.appliesPreferredTrackTransform = YES;
            assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
            //实际贞，速度慢，采用关键帧，速度快
            //assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
            //assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
            CGImageRef thumbnailImageRef = NULL;
            NSError *thumbnailImageGenerationError = nil;
            thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(asset.duration.value*persent, asset.duration.timescale) actualTime:NULL error:&thumbnailImageGenerationError];
            result = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
            //重要
            //Core Graphics (and Core Foundation) doesn't have an autorelease pool, so if you want to return you CGImageRef you need to either name your function containing Create(f.e. MyCreatePosterImage()) or return UIImage object:
            //CG CF 开头的api没有自动释放池，得手动释放
            CGImageRelease(thumbnailImageRef);
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(result);
            });
        });

    }
    else
    {
        block(nil);
    }
}

+(UIImage*)thumbnailImageForVideoSyn:(NSString *)fileFullPath atPersent:(float)persent
{
    UIImage* result = nil;
    if (!STR_IS_NIL(fileFullPath) && [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
        NSURL * videoURL = [NSURL fileURLWithPath:fileFullPath];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        //实际贞，速度慢，采用关键帧，速度快
        //assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        //assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        CGImageRef thumbnailImageRef = NULL;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(asset.duration.value*persent, asset.duration.timescale) actualTime:NULL error:&thumbnailImageGenerationError];
        result = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
        //重要
        //Core Graphics (and Core Foundation) doesn't have an autorelease pool, so if you want to return you CGImageRef you need to either name your function containing Create(f.e. MyCreatePosterImage()) or return UIImage object:
        //CG CF 开头的api没有自动释放池，得手动释放
        CGImageRelease(thumbnailImageRef);
        
    }
    return result;
}


+(NSString*)saveFrontCover:(UIImage*) image :(NSString*)videoSourceid
{
    NSString* fileFullPath = [[[LocalResourceModel getFrontCoverPath] stringByAppendingPathComponent:videoSourceid] stringByAppendingPathExtension:@"png"];
    [Tools saveImage:image :fileFullPath];
    return fileFullPath;
}

+(NSString*)frontCover:(NSString*)videoSourceid
{
    NSString* result = @"";
    NSString* fileFullPathPNG = [[[LocalResourceModel getFrontCoverPath] stringByAppendingPathComponent:videoSourceid] stringByAppendingPathExtension:@"png"];
    NSString* fileFullPathJPG = [[[LocalResourceModel getFrontCoverPath] stringByAppendingPathComponent:videoSourceid] stringByAppendingPathExtension:@"jpg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileFullPathPNG]) {
        result = fileFullPathPNG;
    }
    else if([[NSFileManager defaultManager] fileExistsAtPath:fileFullPathJPG])
    {
        result = fileFullPathJPG;
    }
    return result;
}

//xxx-xxx-xxx_1 to xxx-xxx-xxx
+(NSString*)stringMoveNumberSuffix:(NSString*)string
{
    NSString* result = string;
    NSArray* array = [string componentsSeparatedByString:@"_"];
    if ([array count] > 1) {
        NSMutableArray* arrayTmp = [NSMutableArray arrayWithArray:array];
        [arrayTmp removeLastObject];
        result = [arrayTmp componentsJoinedByString:@"_"];
    }
    return result;
}

//"" to  xxx-xxx-xxx_1 to xxx-xxx-xxx_2
+(NSString*)identifierStringIncreaseNumberSuffix:(NSString*)exsitIdentifierString
{
    NSString* result = @"";
    if (!STR_IS_NIL(exsitIdentifierString))
    {
        NSArray* array = [exsitIdentifierString componentsSeparatedByString:@"_"];
        if ([array count] > 1) {
            NSMutableArray* arrayTmp = [NSMutableArray arrayWithArray:array];
            NSString* s = [arrayTmp lastObject];
            if ([Tools isNumeric:s] == YES) {
                int n = [s intValue];
                [arrayTmp removeLastObject];
                s = [NSString stringWithFormat:@"%d",++n];
                [arrayTmp addObject:s];
                result = [arrayTmp componentsJoinedByString:@"_"];
            }
        }
        else
        {
            result = [exsitIdentifierString stringByAppendingFormat:@"_1"];
        }
    }
    return result;
}

+(NSString*)SuffixNumberOfIdentifierString:(NSString*)exsitIdentifierString
{
    NSString* result = @"";
    if (!STR_IS_NIL(exsitIdentifierString))
    {
        NSArray* array = [exsitIdentifierString componentsSeparatedByString:@"_"];
        if ([array count] > 1) {
            NSMutableArray* arrayTmp = [NSMutableArray arrayWithArray:array];
            NSString* s = [arrayTmp lastObject];
            if ([Tools isNumeric:s] == YES) {
                result = s;
            }
        }
    }
    return result;
}

+(BOOL)isNumeric:(NSString*)inputString
{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

+(NSString *)arrayIntoJson:(NSArray *)array
{
    NSString *jsonString = [array JSONString];
    return jsonString;

}

+(NSMutableArray *)jsonIntoArray:(NSString *)json error:(NSError **)error
{

    NSError *parseError = nil;
    id result = [json objectFromJSONStringWithParseOptions:JKParseOptionStrict error:&parseError];
    if (parseError && (error != nil))
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  parseError, @"error",
                                  @"Data parse error", NSLocalizedDescriptionKey, nil];
        *error = [NSError errorWithDomain:@"LooklookResponseErrorDomain" code:200 userInfo:userInfo];;
    }
    
    return result;

}

+(int)getCollentionDiaryDisplayStyle:(DiaryData *)d_data
{
    SpaceCollectionViewCell *cell = [[SpaceCollectionViewCell alloc] init];
    cell.indexPath = [NSIndexPath indexPathForRow:1000 inSection:10];
    [cell layoutDiaryCell:d_data];
    return cell.displayStyleCell;
}

+(NSString*)identifierString
{
    NSString* result = @"";
    CFUUIDRef identifier = CFUUIDCreate(NULL);
    result = (__bridge NSString *)CFUUIDCreateString(NULL, identifier);
    CFRelease(identifier);
    return result;
}


/**
 * 功能：由一个diarydate 转换成一个lldaomodeldiary
 * 参数：(DiaryData *)diaryData
 * 返回值：LLDaoModelDiary （日记数据库表）
 
 * 创建者：capry chen
 * 创建日期：2013-06-13
 */
+(LLDaoModelDiary *) convertDiaryDataToLLDaoModelDiary:(DiaryData *)diaryData
{
    
    LLDaoModelDiary *llDaoModelDiary = [[LLDaoModelDiary alloc] init];
    
    //确认转换时候，所有字段都包括，没有遗漏
    
//    llDaoModelDiary.downTaskId        = diaryData.d_downTaskId;
//    llDaoModelDiary.sharetaskid       = diaryData.d_sharetaskid;
//    llDaoModelDiary.publishtaskid     = diaryData.d_publishtaskid;
//    llDaoModelDiary.favoriteTaskId    = diaryData.d_favoriteTaskId;
//    llDaoModelDiary.uploadTask_taskID = diaryData.d_uploadTask_taskID;

    
    llDaoModelDiary.safeboxTaskId = diaryData.d_safeboxTaskId;
    llDaoModelDiary.addresscode = diaryData.d_addresscode;
    llDaoModelDiary.position_source = diaryData.d_position_source;
    llDaoModelDiary.position_status = diaryData.d_position_status;
    llDaoModelDiary.diaryuuid = diaryData.d_diaryuuid;//日记的本地id
    llDaoModelDiary.resourcediaryid = diaryData.d_resource_diaryid;
    llDaoModelDiary.resourceuuid= diaryData.d_resource_diaryuuid;
    
    llDaoModelDiary.isFavorite = diaryData.d_isFavorite;
    //下面同服务器协议
    llDaoModelDiary.nickname = diaryData.d_nickname;               // 昵称",  //日记主人昵称
    llDaoModelDiary.headimageurl = diaryData.d_headimageurl;           // 日记主人头像地址
    llDaoModelDiary.size = diaryData.d_size;
    llDaoModelDiary.weight = diaryData.d_weight;
    llDaoModelDiary.weather = diaryData.d_weather;
    llDaoModelDiary.weather_info = diaryData.d_weather_info;
    llDaoModelDiary.mood = diaryData.d_mood;
    llDaoModelDiary.publishid = diaryData.d_publishid;
    llDaoModelDiary.join_safebox = diaryData.d_join_safebox;            // 是否加入保险箱，1是 0否
    llDaoModelDiary.diaryid = diaryData.d_diaryid;                      // 日记ID
    llDaoModelDiary.userid = diaryData.d_userid;                        // 用户id
    llDaoModelDiary.diarytimemilli = diaryData.d_diarytimemilli;        // 日记建立毫秒数
    llDaoModelDiary.updatetimemilli = diaryData.d_updatetimemilli;      // 日记修改毫秒数
    llDaoModelDiary.introduction = diaryData.d_introduction;            // 简介，base64编码
    llDaoModelDiary.publish_status = diaryData.d_publish_status;        // 1全部人可见 2关注人可见 3指定人可见 4仅自己可见
    llDaoModelDiary.snscollect_sina = diaryData.d_snscollect_sina;      // "1231,12312,12312",// 所有分享到新浪的微博id
    llDaoModelDiary.diary_status = diaryData.d_diary_status;
    llDaoModelDiary.upload_status = diaryData.d_upload_status;
    
    llDaoModelDiary.snscollect_tencent = diaryData.d_snscollect_tencent;// "12312,1231,12312",// 所有分享到腾讯的微博id总和
    llDaoModelDiary.iscollect = diaryData.d_iscollect;                  // 1：已收藏，0：未收藏"
    llDaoModelDiary.position = diaryData.d_position;                    // 位置信息，base64编码
    llDaoModelDiary.longitude = diaryData.d_longitude;                  // 经度
    llDaoModelDiary.latitude = diaryData.d_latitude;                    // 纬度
    llDaoModelDiary.offset = diaryData.d_offset;                //位置偏移量
    
    llDaoModelDiary.sex = diaryData.d_sex;                              // 0男，1女， 2未知
    llDaoModelDiary.signature = diaryData.d_signature;                  // 个性签名,base64编码的
    //                                         llDaoModelDiary.sharestatus = diatyData.;
    llDaoModelDiary.enjoycount = diaryData.d_enjoycount;                // 喜欢数
    llDaoModelDiary.location_status = diaryData.d_location_status;      // 位置状态，0：保密，1不保密
    llDaoModelDiary.commentcount = diaryData.d_commentcount;            // 评论数
    llDaoModelDiary.forwardcount = diaryData.d_forwardcount;            // 转发数
    llDaoModelDiary.collectcount = diaryData.d_collectcount;            // 收藏数
    llDaoModelDiary.synchronization_status = diaryData.d_synchronization_status;//0未同步，1已同步
    llDaoModelDiary.is_publish_status = diaryData.d_is_publish_status;  // 是否发布过
    // 活动
    LLDaoModelDiaryActiveCell *activeCell = [[LLDaoModelDiaryActiveCell alloc] init];
    activeCell.activeid = diaryData.d_activeDic.d_activeid;//
    activeCell.activename = diaryData.d_activeDic.d_activename;//
    activeCell.starttime = diaryData.d_activeDic.d_starttime;//
    activeCell.endtime = diaryData.d_activeDic.d_endtime;//
    activeCell.introduction = diaryData.d_activeDic.d_active_introduction;//
    activeCell.add_way = diaryData.d_activeDic.d_add_way;//
    activeCell.rule = diaryData.d_activeDic.d_rule;//
    activeCell.prize = diaryData.d_activeDic.d_prize;//
    activeCell.picture = diaryData.d_activeDic.d_picture;//
    activeCell.isjoin = diaryData.d_activeDic.d_isjoin;//
    activeCell.iseffective = diaryData.d_activeDic.d_iseffective;//
    llDaoModelDiary.active = activeCell;
    
    llDaoModelDiary.isShortSoundRecognizedToText = diaryData.d_isShortSoundRecognizedToText;
    
    // 标签
    llDaoModelDiary.tags = [NSMutableArray array];//json字串
    
    for (int i = 0; i < [diaryData.d_tagsArray count]; i++)
    {
        ParsingTagsData *parsingTagsData = [diaryData.d_tagsArray objectAtIndex:i];
        LLDaoModelDiaryTagCell *llDaoModelDiaryTagCell = [[LLDaoModelDiaryTagCell alloc] init];
        
        llDaoModelDiaryTagCell.id = parsingTagsData.d_tagid;
        llDaoModelDiaryTagCell.name  = parsingTagsData.d_tagname;
        
        [llDaoModelDiary.tags addObject:llDaoModelDiaryTagCell];
    }
    
    // 分享轨迹
    llDaoModelDiary.sns = [NSMutableArray array];//json字串
    for (int j = 0; j < [diaryData.d_snsArray count]; j++)
    {
        ParsingSnsData *parsingSnsData = [diaryData.d_snsArray objectAtIndex:j];
        LLDaoModelDiarySnsCell *llDaoModelDiarySnsCell = [[LLDaoModelDiarySnsCell alloc] init];
        llDaoModelDiarySnsCell.snscontent = parsingSnsData.d_snscontent;
        llDaoModelDiarySnsCell.sharetime  = parsingSnsData.d_sharetime;
        llDaoModelDiarySnsCell.shareinfo  = [NSMutableArray array];
        for (int k = 0; k < [parsingSnsData.d_shareInfoArray count]; k++)
        {
            LLDaoModelDiarySnsCellShareinfoCell *daoShareInfoCell = [[LLDaoModelDiarySnsCellShareinfoCell alloc] init];
            ParsingShareInfoData *snsCell = [parsingSnsData.d_shareInfoArray objectAtIndex:k];
            
            daoShareInfoCell.snsid   = snsCell.d_snsid;
            daoShareInfoCell.snstype = snsCell.d_snstype;
            daoShareInfoCell.weiboid = snsCell.d_weiboid;
            
            [llDaoModelDiarySnsCell.shareinfo addObject:daoShareInfoCell];
        }
        [llDaoModelDiary.sns addObject:llDaoModelDiarySnsCell];
    }
    // 附件
    llDaoModelDiary.attachs = [NSMutableArray array];//附件
    for (int m = 0; m < [diaryData.d_attachsArray count]; m++)
    {
        LLDaoModelDiaryAttachsCell *llDaoModelDiaryAttachsCell = [[LLDaoModelDiaryAttachsCell alloc] init];
        ParsingAttachsData *parsingAttachsData = [diaryData.d_attachsArray objectAtIndex:m];
        
        llDaoModelDiaryAttachsCell.attach_latitude = parsingAttachsData.d_attach_latitude;
        llDaoModelDiaryAttachsCell.attach_logitude = parsingAttachsData.d_attach_logitude;
        llDaoModelDiaryAttachsCell.Operate_type = parsingAttachsData.d_Operate_type;
        llDaoModelDiaryAttachsCell.audio_type = parsingAttachsData.d_audio_type;
        llDaoModelDiaryAttachsCell.createType = parsingAttachsData.d_createType;
        
        llDaoModelDiaryAttachsCell.attachuuid = parsingAttachsData.d_attachuuid;
        llDaoModelDiaryAttachsCell.localSize = parsingAttachsData.d_localSize;
        llDaoModelDiaryAttachsCell.downLoadSize = parsingAttachsData.d_downLoadSize;
        llDaoModelDiaryAttachsCell.downLoadFilePath = parsingAttachsData.d_downLoadFilePath;
        llDaoModelDiaryAttachsCell.localfilePath = parsingAttachsData.d_localFilePath;
        llDaoModelDiaryAttachsCell.attachid = parsingAttachsData.d_attachid;
        llDaoModelDiaryAttachsCell.attachtype = parsingAttachsData.d_attachtype;
        llDaoModelDiaryAttachsCell.photo_type = parsingAttachsData.d_photo_type;
        llDaoModelDiaryAttachsCell.video_type = parsingAttachsData.d_video_type;
        llDaoModelDiaryAttachsCell.is_encrypt = parsingAttachsData.d_is_encrypt; //原音可见范围，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见，attachtype=2有效
        llDaoModelDiaryAttachsCell.content = parsingAttachsData.d_content;
        llDaoModelDiaryAttachsCell.videocover = parsingAttachsData.d_videocover;
        llDaoModelDiaryAttachsCell.attachlevel = parsingAttachsData.d_attachlevel;
        llDaoModelDiaryAttachsCell.playtime = parsingAttachsData.d_playtime;
        llDaoModelDiaryAttachsCell.attachtimemilli = parsingAttachsData.d_attachtimemilli;
        llDaoModelDiaryAttachsCell.playtimes = parsingAttachsData.d_playstimes;
        llDaoModelDiaryAttachsCell.pic_width = parsingAttachsData.d_pic_width;
        llDaoModelDiaryAttachsCell.pic_height = parsingAttachsData.d_pic_height;
        llDaoModelDiaryAttachsCell.show_width = parsingAttachsData.d_show_width;
        llDaoModelDiaryAttachsCell.show_height = parsingAttachsData.d_show_height;
        
        // 图片附件
        llDaoModelDiaryAttachsCell.attachimage = [NSMutableArray array];
        for (int m1 = 0; m1 < [parsingAttachsData.d_attachimageArray count]; m1++)
        {
            ParsingAttachImageData *parsingAttachImageData = [parsingAttachsData.d_attachimageArray objectAtIndex:m1];
            LLDaoModelDiaryAttachsCellAttachimageCell *daoAttachsCellImageCell = [[LLDaoModelDiaryAttachsCellAttachimageCell alloc] init];
            daoAttachsCellImageCell.imageurl      = parsingAttachImageData.d_imageurl;
            daoAttachsCellImageCell.imagetype     = parsingAttachImageData.d_imagetype;
            daoAttachsCellImageCell.imagesize     = parsingAttachImageData.d_imagesize;
            //daoAttachsCellImageCell.localfilePath = parsingAttachImageData.d_localFilePath;
            
            [llDaoModelDiaryAttachsCell.attachimage addObject:daoAttachsCellImageCell];
        }
        // 声音附件
        llDaoModelDiaryAttachsCell.attachaudio = [NSMutableArray array];
        for (int m2 = 0; m2 < [parsingAttachsData.d_attachaudioArray count]; m2++)
        {
            ParsingAttachAudioData *parsingAttachAudioData = [parsingAttachsData.d_attachaudioArray objectAtIndex:m2];
            LLDaoModelDiaryAttachsCellAttachaudioCell *daoAttachsCellAudioCell = [[LLDaoModelDiaryAttachsCellAttachaudioCell alloc] init];
            daoAttachsCellAudioCell.audiourl      = parsingAttachAudioData.d_audiourl;
            daoAttachsCellAudioCell.audiotype     = parsingAttachAudioData.d_audiotype;
            daoAttachsCellAudioCell.audiosize     = parsingAttachAudioData.d_audiosize;
            //daoAttachsCellAudioCell.localfilePath = parsingAttachAudioData.d_localFilePath;
            
            [llDaoModelDiaryAttachsCell.attachaudio addObject:daoAttachsCellAudioCell];
        }
        // 视频附件
        llDaoModelDiaryAttachsCell.attachvideo = [NSMutableArray array];
        for (int m3 = 0; m3 < [parsingAttachsData.d_attachvideoArray count]; m3++)
        {
            ParsingAttachVideoData *parsingAttachVideoData = [parsingAttachsData.d_attachvideoArray objectAtIndex:m3];
            LLDaoModelDiaryAttachsCellVideopathCell *daoAttachsCellVideoCell = [[LLDaoModelDiaryAttachsCellVideopathCell alloc] init];
            daoAttachsCellVideoCell.videotype = parsingAttachVideoData.d_videotype;
            daoAttachsCellVideoCell.playvideourl = parsingAttachVideoData.d_playvideourl;
            daoAttachsCellVideoCell.videosize    = parsingAttachVideoData.d_videosize;
            //daoAttachsCellVideoCell.localfilePath = parsingAttachVideoData.d_localFilePath;
            
            [llDaoModelDiaryAttachsCell.attachvideo addObject:daoAttachsCellVideoCell];
        }
        
        [llDaoModelDiary.attachs addObject:llDaoModelDiaryAttachsCell];
    }
    
    // 副本
    llDaoModelDiary.duplicate = [NSMutableArray array];//副本
    for (int t = 0; t < [diaryData.d_duplicateArray count]; t++)
    {
        ParsingDuplicateData *parsingDuplicateData = [diaryData.d_duplicateArray objectAtIndex:t];
        LLDaoModelDiaryDuplicateCell *daoModelDuplicateCell = [[LLDaoModelDiaryDuplicateCell alloc] init];
        daoModelDuplicateCell.diaryid = parsingDuplicateData.d_duplicate_diaryid;//
        daoModelDuplicateCell.diaryuuid = parsingDuplicateData.d_duplicate_diaryuuid;
        daoModelDuplicateCell.duplicatename = parsingDuplicateData.d_duplicatename;
        [llDaoModelDiary.duplicate addObject:daoModelDuplicateCell];
    }
    
    // 平台分享
    llDaoModelDiary.platformurls = [NSMutableArray array];
    for (int t = 0; t < [diaryData.d_platformurls count]; t++)
    {
        PlatformUrlData *platformUrlData = [diaryData.d_platformurls objectAtIndex:t];
        PlatformUrlCell *daoPlatformUrlCell = [[PlatformUrlCell alloc] init];
        daoPlatformUrlCell.snstype = platformUrlData.d_snstype;//
        daoPlatformUrlCell.url = platformUrlData.d_url;
        [llDaoModelDiary.platformurls addObject:daoPlatformUrlCell];
    }

    return llDaoModelDiary;
}

/**
 * 功能：由一个LLDaoModelDiary 转换成一个DiaryData
 * 参数：(LLDaoModelDiary *)llDaoModelDiary
 * 返回值：DiaryData （日记网络数据模型）
 
 * 创建者：capry chen
 * 创建日期：2013-06-13
 */
+(DiaryData *) convertLLDaoModelDiaryToDiaryData:(LLDaoModelDiary *)llDaoModelDiary
{
    if(!llDaoModelDiary){
        return nil;
    }
    DiaryData *diaryData = [[DiaryData alloc] init];
    
    NSDictionary *jsonDic = [llDaoModelDiary outPutDic];
    [diaryData setResponseModelFromDic:jsonDic];
    
    return diaryData;
}

+(LLDaoModelDiaryTagCell*)convertMarkCellToLlDaoModelDiaryTagCell:(MarkCell*)markCell{
    LLDaoModelDiaryTagCell *tagCell = [[LLDaoModelDiaryTagCell alloc]init];
    tagCell.id = markCell.markId;
    tagCell.name = markCell.name;
    return tagCell;
}


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
 还要做副本更新的判断  如果副本少了则删除掉多余的
 */
+(void) isDiaryDataUpdate:(NSMutableArray *)diaryDataArray
{
    for (int i = 0; i < diaryDataArray.count; i++)
    {
        DiaryData *latestDiaryData = [diaryDataArray objectAtIndex:i];
        
        if (latestDiaryData.d_attachsArray.count <= 0)
        {
            continue;
        }
        LLDaoModelDiary *llDaoModelDiaryClass = [[LLDaoModelDiary alloc] init];
        __block LLDaoModelDiary *llDaoModelDiary = nil;
        [[LLDAOBase shardLLDAOBase] searchWhere:llDaoModelDiaryClass
                                         String:[NSString stringWithFormat:@"diaryuuid = \'%@\'",latestDiaryData.d_diaryuuid]
                                        orderBy:nil
                                         offset:0
                                          count:1
                                       callback:^(NSArray *resultArray)
         {
             if (resultArray.count > 0)
             {
                 llDaoModelDiary = [resultArray objectAtIndex:0];
             }
         }
         ];
        
        if (llDaoModelDiary) // 有记录判断更新
        {
            LLDaoModelDiary *netDiary  = [Tools convertDiaryDataToLLDaoModelDiary:latestDiaryData];
            // 第三方历史分享文字纪录
            netDiary.localThirdShareMesHistory = llDaoModelDiary.localThirdShareMesHistory;
            //需要检查下，下面内容为本地专用字段,确保没漏
            netDiary.downTaskId        = llDaoModelDiary.downTaskId;
            netDiary.sharetaskid       = llDaoModelDiary.sharetaskid;
            netDiary.publishtaskid     = llDaoModelDiary.publishtaskid;
            netDiary.favoriteTaskId    = llDaoModelDiary.favoriteTaskId;
            netDiary.uploadTask_taskID = llDaoModelDiary.uploadTask_taskID;
            netDiary.upload_status     = llDaoModelDiary.upload_status;
            netDiary.safeboxTaskId     = llDaoModelDiary.safeboxTaskId;
            netDiary.synchronization_status = @"1";//服务器来的，所有是已同步
            netDiary.fromOldversion2_2 = llDaoModelDiary.fromOldversion2_2;
            
            if (llDaoModelDiary.safeboxTaskId != -1) {//有保险箱任务，则使用本地保险箱字段
                netDiary.join_safebox = llDaoModelDiary.join_safebox;
            }
            
            
//            if ([llDaoModelDiary.updatetimemilli longLongValue] <= [netDiary.updatetimemilli longLongValue] && [@"-3" isEqualToString:llDaoModelDiary.upload_status] && (llDaoModelDiary.uploadTask_taskID == -1) ){ //不是正在上传中状态
            if ([llDaoModelDiary.updatetimemilli longLongValue] <= [netDiary.updatetimemilli longLongValue] && [@"-3" isEqualToString:llDaoModelDiary.upload_status] && (llDaoModelDiary.uploadTask_taskID <= IS_HAVE_TASK_CONDITION) ){ //不是正在上传中状态
              //  NSLog(@"---llDaoModelDiary diaryUUID is %@, local_updatetimemilli is %@, update_status is %@ ,net_updatetimilli is %d",llDaoModelDiary.diaryuuid,llDaoModelDiary.updatetimemilli,llDaoModelDiary.upload_status, netDiary.uploadTask_taskID);
                BOOL isSynchronized = [llDaoModelDiary.synchronization_status isEqualToString:@"1"] ? YES : NO;
                [LLDaoModelDiary mergeAttachs:netDiary.attachs :llDaoModelDiary.attachs isSynchronized:isSynchronized];
                
                for (int k = 0; k < [latestDiaryData.d_duplicateArray count]; k++)
                {
                    ParsingDuplicateData *parsingDuplicateData = [latestDiaryData.d_duplicateArray objectAtIndex:k];
                    for (int k1 = 0; k1 < [llDaoModelDiary.duplicate count]; k1++)
                    {
                        LLDaoModelDiaryDuplicateCell *daoModelDuplicateCell = [llDaoModelDiary.duplicate objectAtIndex:k1];
                        if ([daoModelDuplicateCell.diaryid isEqualToString:parsingDuplicateData.d_duplicate_diaryid])
                        {
                            break;
                        }
                        // 如果执行到最后一个还没找到则进行删除动作
                        else if(k1 == [latestDiaryData.d_duplicateArray count]-1)
                        {
                            // 删除多余的副本
                            [[LLDAOBase shardLLDAOBase] deleteToDBWithWhere:llDaoModelDiary
                                                                      where:[NSString stringWithFormat:@"diaryid = \'%@\'",daoModelDuplicateCell.diaryid]
                                                                   callback:^(BOOL result)
                             {
                                 
                             }
                             ];
                        }
                    }
                }
                
                
                [[LLDAOBase shardLLDAOBase] updateToDB:netDiary
                                              callback:^(BOOL result)
                 {
                     // to-do 失败情况暂不考虑
                 }
                 ];

            }            
        }
        //        }
        else  // 数据库中无此条纪录，插入此条纪录
        {
            llDaoModelDiary = [Tools convertDiaryDataToLLDaoModelDiary:latestDiaryData];
            [llDaoModelDiary localSize];
            llDaoModelDiary.downTaskId        = -1;
            llDaoModelDiary.sharetaskid       = -1;
            llDaoModelDiary.publishtaskid     = -1;
            llDaoModelDiary.favoriteTaskId    = -1;
            llDaoModelDiary.uploadTask_taskID = -1;
            llDaoModelDiary.safeboxTaskId     = -1;

            [[LLDAOBase shardLLDAOBase] insertToDB:llDaoModelDiary
                                          callback:^(BOOL result)
             {
                 // to-do 失败情况暂不考虑
             }
             ];
        }
    }
}


/**
 * 功能：将modeldiary 数组转换成为diarydata数组
 * 参数：(LLDaoModelDiary *)llDaoModelDiary
 * 返回值：DiaryData （日记网络数据模型）
 
 * 创建者：capry chen
 * 创建日期：2013-06-13
 */
+(NSMutableArray *) changeModelDiaryToDiaryDataArray:(NSArray *)modelDiaryArray
{
    NSMutableArray *resultMutableArray = [NSMutableArray arrayWithArray:modelDiaryArray];
    for (int i = 0; i < resultMutableArray.count; i++)
    {
        LLDaoModelDiary *modelDiary = [resultMutableArray objectAtIndex:i];
        DiaryData *diaryData = [self convertLLDaoModelDiaryToDiaryData:modelDiary];
        [resultMutableArray replaceObjectAtIndex:i withObject:diaryData];
    }
    return resultMutableArray;
}

+(BOOL)moveFileFromSourcePathToNewPath:(NSString*)sourcePath newpath:(NSString*)newpath isSourceFileDelete:(BOOL)isSourceFileDelete
{
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:sourcePath isDirectory:&isDir]) {
        return NO;
    }
    if (isDir) {
        return NO;
    }
    if (![[NSFileManager defaultManager]fileExistsAtPath:newpath]) {
        NSData * movieData = [NSData dataWithContentsOfFile:sourcePath];
//        [[NSFileManager defaultManager] createDirectoryAtPath:[VIDEOPATH stringByAppendingPathComponent:videoid] withIntermediateDirectories:YES attributes:nil error:nil];
        BOOL r = [ movieData writeToFile:newpath atomically:YES];
        if(isSourceFileDelete){
           [[NSFileManager defaultManager] removeItemAtPath:sourcePath error:nil];
        }
        return r;
    }
    return YES;
}
+(NSString*)getDateTimeFrom:(NSString *)timeInterval{
    if(timeInterval.length == 0){
        return @"";
    }
    NSDate *correctDate = [NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    return [formatter stringFromDate:correctDate];
}

+ (BOOL) isCurrentDay:(NSDate *)nowDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    
    NSString *systemDateStr = [GetMessageModel getSystemCurrentTime];
    NSDate   *systemDate = [NSDate dateWithTimeIntervalSince1970:systemDateStr.longLongValue/1000.0];
    NSString *currentDay = [formatter stringFromDate:systemDate];
    NSString *nowDay = [formatter stringFromDate:nowDate];
    
    return [nowDay isEqualToString:currentDay] ? YES : NO;
}

+ (BOOL) isCurrentYear:(NSDate *)nowDate
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    
    NSString *systemDateStr = [GetMessageModel getSystemCurrentTime];
    NSDate   *systemDate = [NSDate dateWithTimeIntervalSince1970:systemDateStr.longLongValue/1000.0];
    NSString *currentYear = [formatter stringFromDate:systemDate];
    NSString *nowYear = [formatter stringFromDate:nowDate];
    
    return [nowYear isEqualToString:currentYear] ? YES : NO;
}

/**
 * 功能：获取时间如果时间小于一小时则显示多少分钟之前
 * 参数：时间str
 * 返回值：处理后的时间
 
 * 创建者：capry chen
 * 创建日期：2013-07-13
 */
+(NSString*)getDateFormatFrom:(NSString*)timeInterval
{
    if(timeInterval.length == 0){
        return @"";
    }
    NSDate *correctDate = [NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    
    NSString *systemDateStr = [GetMessageModel getSystemCurrentTime];
    NSDate   *systemDate = [NSDate dateWithTimeIntervalSince1970:systemDateStr.longLongValue/1000.0];
    NSTimeInterval differenceTime = [correctDate timeIntervalSinceDate:systemDate];
    if (differenceTime < 0 && differenceTime > -3600)
    {
        NSInteger differenceMin = -differenceTime / 60;
        NSString *resultStr = [NSString stringWithFormat:@"%d分钟前",differenceMin];
        if (differenceMin == 0)
        {
            resultStr = @"刚刚";
        }
        return resultStr;
    }
    else if([self  isCurrentDay:correctDate])
    {
        [formatter setDateFormat:@"HH:mm:ss"];
        NSString *resultStr = [NSString stringWithFormat:@"今天 %@",[formatter stringFromDate:correctDate]];
        return resultStr;
    }
    else if([self isCurrentYear:correctDate])
    {
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        NSString *resultStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:correctDate]];
        return resultStr;
    }
    else
    {
        return [formatter stringFromDate:correctDate];
    }
}

+ (NSString *)getDefaultFormatDateWithDateTime:(NSString *)time {
     return [self getFullDateWithIntvDateTime:[time longLongValue] Format:@"YYYY-MM-dd HH:mm"];
}

+ (NSString *)getFullDateWithStringDateTime:(NSString *)time Format:(NSString *)format {
    return [self getFullDateWithIntvDateTime:[time longLongValue] Format:format];
}

+ (NSString *)getFullDateWithIntvDateTime:(long long)time Format:(NSString *)format {
    if (!format) {
        return nil;
    }
    if (time == 0) {
        return @"";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    [formatter setDateFormat:format];
    
    return[formatter stringFromDate:date];
}

+(BOOL)alertViewExsit:(NSInteger)tag
{
    BOOL result = NO;
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        
        for (UIView* view in subviews) {
            NSLog(@"%@",NSStringFromClass([view class]));
            if ([view isKindOfClass:[UIView class]] && view.tag==tag) {
                result = YES;
                break;
            }
        }
        //        if ([subviews count] > 0)
        //        {
        //            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]] && ((UIAlertView*)[subviews objectAtIndex:0]).tag == tag)
        //                result = YES;
        //        }
    }
    return result;
}

+(void)arrayToClass:(NSMutableArray*)array :(Class)theClass
{
    for (int i = 0; i < array.count; i++) {
        id value = [array objectAtIndex:i];
        id cell = [theClass customClassWithProperties:value];
        if (cell) {
            [array replaceObjectAtIndex:i withObject:cell];
        }
    }
}

+(NSString*)parsingAudioUrlByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel{
    NSString* audioUrl =  @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if([attachsdata.d_attachtype intValue] == 2 && [attachsdata.d_attachlevel intValue] == attachLevel){
                if(!STR_IS_NIL(attachsdata.d_localFilePath)){
                    audioUrl = attachsdata.d_localFilePath;
                    return audioUrl;
                }else{
                    ParsingAttachAudioData *audiodata = [attachsdata.d_attachaudioArray objectAtIndex:0];
                    audioUrl = audiodata.d_audiourl;
              }
            }
        }
    }
    return audioUrl;
}

+(NSString*)parsingAudioPlayTimeByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel;
{
    NSString* playTime =  @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if([attachsdata.d_attachtype intValue] == 2 && [attachsdata.d_attachlevel intValue] == attachLevel){
                if(!STR_IS_NIL(attachsdata.d_playtime)){
                    playTime = attachsdata.d_playtime;
                    return playTime;
                }else{
                    
                }
            }
        }
    }
    return playTime;
}

+(NSString*)parsingAudiouuidByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel
{
    NSString* uuid =  @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if([attachsdata.d_attachtype intValue] == 2 && [attachsdata.d_attachlevel intValue] == attachLevel){
                uuid = attachsdata.d_attachuuid;
                break;
            }
        }
    }
    return uuid;
}

+(NSString*)parseTextDescByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel{
    NSString* textDesc = @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if([attachsdata.d_attachlevel intValue] == attachLevel && [attachsdata.d_attachtype intValue] == 4){
                textDesc = attachsdata.d_content;
                break;
            }
        }
    }
    return textDesc;

}

extern NSMutableArray *DiaryDetails_getAttachmentFromType(DiaryData *diary, DIARY_TYPE type);

+(NSString*)parseImageUrlByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel{
    NSString* imageUrl= @"";
    NSString *noWaterMarkImageUrl = @"";
    NSString *hasWaterMarkImageUrl = @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if([attachsdata.d_attachtype intValue] == 3 && [attachsdata.d_attachlevel intValue] == attachLevel){
                if(!STR_IS_NIL(attachsdata.d_localFilePath)){
                    imageUrl = attachsdata.d_localFilePath;
                    return imageUrl;
                }else{
                    if (attachsdata.d_attachimageArray.count > 0) {
                        
                        for (ParsingAttachImageData *onePhotoData in attachsdata.d_attachimageArray) {
                            
                            if ([onePhotoData.d_imagetype isEqualToString:@"0"]) {//无水印
                                noWaterMarkImageUrl = onePhotoData.d_imageurl;
                                
                            }
                            if ([onePhotoData.d_imagetype isEqualToString:@"1"]) {//有水印
                                hasWaterMarkImageUrl = onePhotoData.d_imageurl;
                                
                            }
                        }
                        if ([diaryData.d_userid isEqualToString:APP_USERID]) {
                            imageUrl = STR_IS_NIL(noWaterMarkImageUrl)?hasWaterMarkImageUrl:noWaterMarkImageUrl;
                            
                        } else {
                            imageUrl = STR_IS_NIL(hasWaterMarkImageUrl)?noWaterMarkImageUrl:hasWaterMarkImageUrl;
                        }
                    }
                }
            }
        }
    }
    return imageUrl;
}

+(NSString*)parseImageuuidByAttachLevel:(DiaryData*) diaryData attachLevel:(int)attachLevel
{
    NSString* uuid= @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if([attachsdata.d_attachtype intValue] == 3 && [attachsdata.d_attachlevel intValue] == attachLevel){
                uuid = attachsdata.d_attachuuid;
                break;
            }
        }
    }
    return uuid;
}

+(NSString*)parseVideoCover:(DiaryData*) diaryData{
    NSString* videoCoverUrl= @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if([attachsdata.d_attachtype intValue] == 1){
                videoCoverUrl = attachsdata.d_videocover;
                break;
              }
            }
    }
    return videoCoverUrl;
}

+(NSString*)parseVideoPlayUrl:(DiaryData*) diaryData attachLevel:(int)attachLevel{
    NSString* videoPlayUrl =  @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if([attachsdata.d_attachlevel intValue] == attachLevel && !STR_IS_NIL(attachsdata.d_localFilePath)){
                videoPlayUrl = attachsdata.d_localFilePath;
                return videoPlayUrl;
            }
            if([attachsdata.d_attachlevel intValue] == attachLevel){
                ParsingAttachVideoData *audiodata = [attachsdata.d_attachvideoArray objectAtIndex:0];
                videoPlayUrl = audiodata.d_playvideourl;
                break;
            }
        }
    }
    return videoPlayUrl;
}

+(NSString*)parseVideoUuid:(DiaryData*) diaryData attachLevel:(int)attachLevel
{
    NSString* videoPlayUuid =  @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            
            if([attachsdata.d_attachlevel intValue] == attachLevel){
                if(!STR_IS_NIL(attachsdata.d_attachuuid)){
                    videoPlayUuid = attachsdata.d_attachuuid;
                    break;
                }
            }
        }
    }
    return videoPlayUuid;
}


//解析录音时长
+(NSString *)parseAudioPlayTime:(DiaryData *)diaryData
{
    NSString* audioPlayTime = @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if ([attachsdata.d_attachtype intValue] == 2) {
                audioPlayTime = attachsdata.d_playtime;
                break;
            }

        }
    }
    return audioPlayTime;
}
//解析短录音时长
+(NSString *)parseShortAudioPlayTime:(DiaryData *)diaryData
{
    NSString* audioPlayTime = @"";
    NSMutableArray *attachs = diaryData.d_attachsArray;
    if(attachs && [attachs count] > 0){
        for(ParsingAttachsData *attachsdata in attachs){
            if ([attachsdata.d_attachtype intValue] == 2 && [attachsdata.d_attachlevel intValue] == 0) {
                audioPlayTime = attachsdata.d_playtime;
                break;
            }
            
        }
    }
    return audioPlayTime;
}



+(NSMutableDictionary *)parseVideoImageWidthAndHeight:(DiaryData *)diaryData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = diaryData.d_attachsArray;
    if (array && array.count >0) {
        for (ParsingAttachsData *aData in array) {
            if ([aData.d_attachtype intValue]==1 ||[aData.d_attachtype intValue]==3) {
                [dic setValue:aData.d_show_height forKey:@"height"];
                [dic setValue:aData.d_show_width forKey:@"width"];
                break;
            }
        }
    }
    
    return dic;
}

+(void)setImageViewCombineAnimation:(UIImageView*)targetImageView iamges:(NSArray*)images animationDuration:(NSTimeInterval)animationDuration animationRepeatCount:(NSInteger)animationRepeatCount{
    //imageView的动画图片是数组images
    targetImageView.animationImages = images;
    //按照原始比例缩放图片，保持纵横比
    targetImageView.contentMode = UIViewContentModeScaleAspectFit;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    targetImageView.animationDuration = animationDuration;
    //动画的重复次数，想让它无限循环就赋成0
    targetImageView.animationRepeatCount = animationRepeatCount;
    [targetImageView startAnimating];
}




//time milli转日期时间字符串
static NSMutableDictionary *dateFormatDict;
+(NSString *)dateFormat:(NSString *)format timeMilli:(NSNumber *)milli
{
    if (dateFormatDict==nil) {
        dateFormatDict=[[NSMutableDictionary alloc]init];
    }
    if ([format isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSDate *dt=[NSDate dateWithTimeIntervalSince1970:[milli doubleValue]/1000];
    NSDateFormatter *df=[dateFormatDict objectForKey:format];
    if (df==nil) {
        df=[[NSDateFormatter alloc]init];
        [df setDateFormat:format];
        [dateFormatDict  setValue:df forKey:format];
    }
    
    return [df stringFromDate:dt];
    
}
+(NSString *)timeMilliFrom:(NSDate*)date
{
    if (date==nil || [date isKindOfClass:[NSNull class]]) {
        return nil;
    }
    double second=[date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d000",(int)second];
    
}
+(NSString*)timeMilliFrom:(NSString*)dateStr format:(NSString*)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//en_US:Thu,zh_CN: 周四
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate* date = [formatter dateFromString:dateStr];
    return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]*1000];
}
+(NSString*)makeLogString:(NSString*)videourl :(NSString*)videoid
{
    NSString* result=videourl;
//    result=[result stringByAppendingFormat:@"?"];
//    
//    result=[result stringByAppendingFormat:@"os="];
//    result=[result stringByAppendingFormat:@"ios"];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"browsetype="];
//    result=[result stringByAppendingFormat:@""];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"cn="];
//    result=[result stringByAppendingFormat:@"0"];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"source="];
//    result=[result stringByAppendingFormat:@"3"];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"internettype="];
//    result=[result stringByAppendingFormat:APP_INTERNETWAY];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"clientversion="];
//    result=[result stringByAppendingFormat:APP_CLIENTVERSION];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"userid="];
//    result=[result stringByAppendingFormat:APP_USERID];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"gps="];
//    result=[result stringByAppendingFormat:@""];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"contentid="];
//    result=[result stringByAppendingFormat:videoid?videoid:@""];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"imei="];
//    result=[result stringByAppendingFormat:APP_UDID];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"imsi="];
//    result=[result stringByAppendingFormat:[UAModel3 defaultUAModel3].mac];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"mobiletype="];
//    result=[result stringByAppendingFormat:APP_DEVICETYPE];
//    result=[result stringByAppendingFormat:@"&"];
//    
//    result=[result stringByAppendingFormat:@"channelcode="];
//    result=[result stringByAppendingFormat:CHANNEL_ID];
//    
//    result = [result stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return result;
}


+ (long long) calculatefolderSizeAtPath:(NSString*) folderPath{
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir]) {
        if (isDir==YES) {
            return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            /**
            struct stat st;
            if(lstat([folderPath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
                return st.st_size;
            }
             **/
            return [self calculateFileSize:folderPath];
        }
    }
    return 0;
}

+ (long long) calculateFileSize:(NSString *)folderPath
{
    NSFileHandle *fHandle = [NSFileHandle fileHandleForReadingAtPath:folderPath];
    long long length = fHandle.seekToEndOfFile;
    [fHandle closeFile];

    NSDictionary *fileAttributeDic=[[NSFileManager defaultManager] attributesOfItemAtPath:folderPath error:NULL];
    NSLog(@"%@wwwwwwww->%@---->%lld---->datalength-->%lld",folderPath,fileAttributeDic,[fileAttributeDic fileSize],length);
    long long size = [fileAttributeDic fileSize];
    return size;
}

// 获取出来是以M为单位的
+ (float) calculatefolderSizeAtPathM:(NSString*) folderPath
{
    float resutSizeM = 0.0f;
    long long size = [self calculatefolderSizeAtPath:folderPath];
    resutSizeM = (float)size /(1024*1024);
    return resutSizeM;
}


+ (long long) _folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        int folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            NSString *folderPathStr = [[NSString alloc] initWithUTF8String:folderPath];
            folderSize += [self calculateFileSize:folderPathStr];
            /**
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
             **/
        }
    }
    return folderSize;
}


+(void)setFXLabelShadowText:(FXLabel*)label labelText:(NSString*)labelText labelFont:(UIFont*)labelFont{
    label.text = labelText;
    label.font = labelFont;
    label.backgroundColor = [UIColor clearColor];
    
    //内阴影
    label.innerShadowBlur = 0;
    label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    label.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    //demonstrate gradient fill
    label.gradientStartColor = HEXCOLOR2(0xffffff,1);
    label.gradientEndColor = HEXCOLOR2(0xffffff,1);
}

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 250
#define BEGIN_FLAG @"["
#define END_FLAG @"]"

+(UIView *)getRichText : (NSString *) message:(int)width:(int)lines
{
    if(message.length == 0){
        return nil;
    }
    
    NSString *messageKey = nil;

    if (lines > 0)
    {
        messageKey = [NSString stringWithFormat:@"%@$$$$$^^^^^=====WithDianDian__%d", message, lines];
    }
    else
    {
        messageKey = message;
    }
    
    //@"<font size = 14>Images with different sizes</font><img src='bq_bizui'>"
    NSString* rcLabeltext = nil;
    
    if ([[[LLGlobalService sharedLLGlobalService].textImageCacheArray allKeys] count] > 200) {
        [[LLGlobalService sharedLLGlobalService].textImageCacheArray removeAllObjects];
    }
    
    NSString* cacheCelltmp = [[LLGlobalService sharedLLGlobalService].textImageCacheArray objectForKey:messageKey];
    if (cacheCelltmp) {
        rcLabeltext = cacheCelltmp;
    }
    if (rcLabeltext == nil) {
        
        if (lines > 0)
        {
            message = [self getNeedLayoutStr:message width:width lines:lines];
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        int posFirst = 0;
        int posSecond = 0;
        BOOL readyToMatch = NO;
        for ( ; posSecond< [message length]; posSecond++) {
            NSString *temp = [message substringWithRange:NSMakeRange(posSecond, 1)];
            if ([temp isEqualToString:BEGIN_FLAG]) {
                readyToMatch = YES;
                if( posSecond-posFirst > 0)
                {
                    NSString* tmp = [message substringWithRange:NSMakeRange(posFirst,posSecond-posFirst)];
                    [array addObject: tmp];
                }
                posFirst = posSecond;
            }
            else if ([temp isEqualToString:END_FLAG] && readyToMatch == YES)
            {
                readyToMatch = NO;
                NSString* tmp = [message substringWithRange:NSMakeRange(posFirst,posSecond-posFirst+1)];
                [array addObject: tmp];
                posFirst = posSecond + 1;
            }
            else if (posSecond == [message length] - 1)
            {
                if( posSecond-posFirst +1 > 0)
                {
                    NSString* tmp = [message substringWithRange:NSMakeRange(posFirst,posSecond-posFirst+1)];
                    [array addObject: tmp];
                }
                
            }
        }
        
        for (int i = 0 ; i< [array count]; i++) {
            NSString* str = [array objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG])
            {
                NSString *imageName = [[LLGlobalService sharedLLGlobalService].seletfaceDictionary objectForKey:str];
                if (!STR_IS_NIL(imageName)) {
                    imageName = [NSString stringWithFormat:@"<img src='%@'>",imageName];
                    [array replaceObjectAtIndex:i withObject:imageName];
                }
            }
        }
        rcLabeltext = [array componentsJoinedByString:nil];
        rcLabeltext = [NSString stringWithFormat:@"<font size = 14>%@</font>",rcLabeltext];
    }
    
    RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(0,0,width,1000)];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:rcLabeltext];
    tempLabel.componentsAndPlainText = componentsDS;
    [tempLabel setTextColor:[UIColor grayColor]];
    
    
    CGSize optimumSize = [tempLabel optimumSize];
    CGRect frame = [tempLabel frame];
    frame.size.height = (int)optimumSize.height + 5;
    [tempLabel setFrame:frame];
    /*tempLabel.height = [tempLabel optimumSize].height;*/
    if (tempLabel.height > lines*KFacialSizeHeight && lines > 0) {
        tempLabel.height = lines*KFacialSizeHeight;
    }
    if (tempLabel.height > 0 && tempLabel.height < KFacialSizeHeight) {
        tempLabel.height = KFacialSizeHeight;//高度小于图片高度＋3，图片将绘制不出来，待优化
    }
    
    [[LLGlobalService sharedLLGlobalService].textImageCacheArray setObject:rcLabeltext forKey:messageKey];
    return tempLabel;
}


+(NSString *) getNeedLayoutStr:(NSString *)inStr width:(float)width lines:(int) lines
{
//    const char *chars = [str cStringUsingEncoding:NSUTF8StringEncoding];
    float currentWidth = 0.0f;
    float biaoqiangWidth = 18.0f;
    int currentLines = 1;
    NSMutableString *resultStr = [NSMutableString string];
    NSString *lastStr = nil;
    for (int i = 0; i < inStr.length; i++)
    {
        if (currentWidth < width || currentLines <= lines)
        {
            NSRange range = NSMakeRange(i, 1);
            NSString *strRs = [inStr substringWithRange:range];
            if ([strRs isEqualToString:@"["])
            {
                NSString *restStr = [inStr substringFromIndex:i];
                NSString *currentBiaoqingStr = [self getBiaoQingString:restStr];
                if ([currentBiaoqingStr isEqualToString:@"-1"])
                {
                    float currentStrWidth = [strRs sizeWithFont:[UIFont systemFontOfSize:14]].width;
                    if (currentWidth + currentStrWidth < width)
                    {
                        if (currentStrWidth < 15)
                        {
                            currentWidth += currentStrWidth;
                        }
                        else
                        {
                            currentWidth += currentStrWidth + 1.50f;
                        }
                        [resultStr appendString:strRs];
                        lastStr = strRs;
                    }
                    else
                    {
                        if (currentLines == lines)
                        {
                            resultStr = [self replaceLastOccurStrWithEllipsis:resultStr needReplaceStr:lastStr currentWidth:currentWidth totalWidth:width];
                            break;
                        }
                        else
                        {
                            currentWidth = 0;
                            currentLines += 1;
                            currentWidth += currentStrWidth;
                            [resultStr appendString:strRs];
                            lastStr = strRs;
                        }
                    }
                }
                else
                {
                    i = i + currentBiaoqingStr.length - 1;
                    if (currentWidth + biaoqiangWidth < width)
                    {
                        currentWidth += biaoqiangWidth + 1.0f;
                        [resultStr appendString:currentBiaoqingStr];
                        lastStr = currentBiaoqingStr;
                    }
                    else
                    {
                        if (currentLines == lines)
                        {
                            resultStr = [self replaceLastOccurStrWithEllipsis:resultStr needReplaceStr:lastStr currentWidth:currentWidth totalWidth:width];
                            break;
                        }
                        else
                        {
                            currentWidth = 0;
                            currentLines += 1;
                            currentWidth += biaoqiangWidth;
                            [resultStr appendString:currentBiaoqingStr];
                            lastStr = currentBiaoqingStr;
                        }
                    }
                }
            }
            else
            {
                float currentStrWidth = [strRs sizeWithFont:[UIFont systemFontOfSize:14]].width;
                if (currentWidth + currentStrWidth < width)
                {
                    if (currentStrWidth < 15.0f)
                    {
                        currentWidth += currentStrWidth;
                    }
                    else
                    {
                        currentWidth += currentStrWidth + 1.50f;
                    }
                    [resultStr appendString:strRs];
                    lastStr = strRs;
                }
                else
                {
                    if (currentLines == lines)
                    {
                        resultStr = [self replaceLastOccurStrWithEllipsis:resultStr needReplaceStr:lastStr currentWidth:currentWidth totalWidth:width];
                        break;
                    }
                    else
                    {
                        currentWidth = 0;
                        currentLines += 1;
                        currentWidth += currentStrWidth;
                        [resultStr appendString:strRs];
                        lastStr = strRs;
                    }
                }
            }
        }
        else
        {
            break;
        }
    }
    return resultStr;
}

+(NSMutableString *) replaceLastOccurStrWithEllipsis:(NSMutableString *)inStr needReplaceStr:(NSString *)needReplaceStr currentWidth:(float)currentWidth totalWidth:(float)totalWidth
{
    float restWidth = totalWidth - currentWidth;
    float dianWidth = [@"..." sizeWithFont:[UIFont systemFontOfSize:14]].width;
    if (restWidth < dianWidth)
    {
        // 返回一个 腾出宽度（float类型）deletedwidth，一个删除后的resultstr（删除后的str）
        BOOL whileAdition = YES;
        while (whileAdition)
        {
            NSMutableDictionary *resultDic = [self deleteLastUnit:inStr];
            float deletedwidth = [[resultDic objectForKey:@"deletedwidth"] floatValue];
            restWidth += deletedwidth;
            if ((deletedwidth + restWidth) > 4*dianWidth)
            {
                NSMutableString *resultstr = (NSMutableString *)[resultDic objectForKey:@"resultstr"];
                inStr = resultstr;
                [inStr appendString:@"..."];
                whileAdition = NO;
            }
        }
//        NSRange range = NSMakeRange(inStr.length - needReplaceStr.length, needReplaceStr.length);
//        [inStr deleteCharactersInRange:range];
//        [inStr appendString:@"..."];
    }
    else
    {
        [inStr appendString:@"..."];
    }
    return inStr;
}

// 返回一个 腾出宽度（float类型）deletedwidth，一个删除后的resultstr（删除后的str）
+(NSMutableDictionary *)deleteLastUnit:(NSMutableString *)inStr
{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    float deletedWidth = 0.0f;
    NSString *lastStr = [inStr substringFromIndex:inStr.length-1];
    float lastWidth = [lastStr sizeWithFont:[UIFont systemFontOfSize:14]].width;
    // 如果属于表情的后一部分
    if ([lastStr isEqualToString:@"]"])
    {
        // 获取表情代码
        NSMutableString *lastBiaoQingString = [NSMutableString string];
        for (int i = inStr.length; i > 0; i--)
        {
            NSRange range = NSMakeRange(i - 1, 1);
            NSString *strRs = [inStr substringWithRange:range];
            if ([strRs isEqualToString:@"["])
            {
                [lastBiaoQingString appendString:strRs];
                break;
            }
            else
            {
                [lastBiaoQingString appendString:strRs];
            }
        }
        NSString *imageName = [[LLGlobalService sharedLLGlobalService].seletfaceDictionary objectForKey:lastBiaoQingString];
        // 判断是不是一个表情
        if ([imageName isEqualToString:@"-1"])
        { // 不是则删除最后一个
            NSRange lastRange = NSMakeRange(inStr.length - 1, 1);
            [inStr deleteCharactersInRange:lastRange];
            deletedWidth = lastWidth;
        }
        else
        { // 是则删除整个表情
            NSRange lastBiaoqingRange = NSMakeRange(inStr.length - lastBiaoQingString.length -1, lastBiaoQingString.length);
            [inStr deleteCharactersInRange:lastBiaoqingRange];
            deletedWidth = 18.0f;
        }
    }
    // 否，则删除最后一个
    else
    {
        NSRange lastRange = NSMakeRange(inStr.length - 1, 1);
        [inStr deleteCharactersInRange:lastRange];
        deletedWidth = lastWidth;
    }
    
    [resultDic setObject:inStr forKey:@"resultstr"];
    NSString *deletedWidthStr = [NSString stringWithFormat:@"%f",deletedWidth];
    [resultDic setObject:deletedWidthStr forKey:@"deletedwidth"];
    
    return resultDic;
}

// 不符合则返回一个"-1"
+(NSString *) getBiaoQingString:(NSString *)str
{
    NSRange range = [str rangeOfString:@"]"];
    if (range.location == NSNotFound)
    {
        return @"-1";
    }
    else
    {
        NSRange rangeBiaoQing = NSMakeRange(0, range.location+1);
        NSString *biaoQingStr = [str substringWithRange:rangeBiaoQing];
        NSString *imageName = [[LLGlobalService sharedLLGlobalService].seletfaceDictionary objectForKey:biaoQingStr];
        if (STR_IS_NIL(imageName))
        {
            return @"-1";
        }
        else
        {
            return biaoQingStr;
        }

    }
    return nil;
}

//字体大小和getRichText函数保持一致
+(CGRect)getRichTextSize : (NSString *) message :(int)width :(int)lines
{
    UIView* view = [Tools getRichText:message :width :lines];
    return view.bounds;
}

//7天更新标签列表
+(BOOL)isUpdateTagList
{
    NSString* oldTimestampStr = [LLUserDefaults getValueWithKey:LAST_UPDATE_TAGLIST_TIMESTAMP];
    if(STR_IS_NIL(oldTimestampStr)){
        return YES;
    }
    NSLog(@"timeSp:%@",oldTimestampStr); //存储时间戳的值
    NSDate *datenow = [NSDate date];
    long nowTimestamp = (long)[datenow timeIntervalSince1970];
    
    long timestampDifference = (nowTimestamp - [oldTimestampStr longLongValue]);
    NSString *timeSp1 = [NSString stringWithFormat:@"%ld", timestampDifference];
    NSLog(@"timeSp1111:%@",timeSp1); //存储时间戳的差
    if (timestampDifference > 86400*7) {
        return YES;
    }
    return FALSE;
}

+(void)getAllMarkList:(void(^)(BOOL isSuccess, NSMutableArray* marksArray))mainBlock{
    //1.先比较时间，是否需要从服务器刷新最新的标签列表
    //2.如果不需要，则从数据库中取
    //3.如果需要，则重新从服务器取，并更新数据库
    if([Tools isUpdateTagList]){
        RIAWebRequestLib* webRequestLib =  [RIAWebRequestLib riaWebRequestLib];
        RequestModel* requestModel = [[RequestModel alloc]initWithUrl:TAGLIST_URL params:[[NSMutableDictionary alloc]initWithObjectsAndKeys:APP_USERID, @"userid",                                                                       nil]requestMethod:REQUEST_METHOD_POST];
        [webRequestLib fetchDataFromNet:requestModel dataModelClass:[MarkData class] mainBlock:^(BaseData *responseModel) {
            if(responseModel.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS){
                MarkData *markData = (MarkData*)responseModel;
                if(markData.marksArray && [markData.marksArray count] > 0){
                    NSDate *datenow = [NSDate date];
                    long nowTimestamp = (long)[datenow timeIntervalSince1970];
                    NSString* nowTimestampStr = [NSString stringWithFormat:@"%ld", nowTimestamp];
                    [LLUserDefaults setValue:nowTimestampStr forKey:LAST_UPDATE_TAGLIST_TIMESTAMP];
                    [LLUserDefaults setValue:markData.marksArray forKey:ALL_TAGS];
                    mainBlock(YES, markData.marksArray);
                }
            }else{
                mainBlock(NO, nil);
            }
        }];
    }else{
        NSMutableArray* tagList= [LLUserDefaults getMutArrayWithKey:ALL_TAGS];
        if(tagList && [tagList count] > 0){
           mainBlock(YES, tagList);
        }else{
          mainBlock(NO, nil);
        }
      }
  }

+(void)checkMarksValidAndUpdateDb{
    if([Tools isUpdateTagList]){
        RIAWebRequestLib* webRequestLib =  [RIAWebRequestLib riaWebRequestLib];
        RequestModel* requestModel = [[RequestModel alloc]initWithUrl:TAGLIST_URL params:[[NSMutableDictionary alloc]initWithObjectsAndKeys:APP_USERID, @"userid",                                                                       nil]requestMethod:REQUEST_METHOD_POST];
        [webRequestLib fetchDataFromNet:requestModel dataModelClass:[MarkData class] mainBlock:^(BaseData *responseModel) {
            if(responseModel.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS){
                MarkData *markData = (MarkData*)responseModel;
                if(markData.marksArray && [markData.marksArray count] > 0){
                    NSDate *datenow = [NSDate date];
                    [[NSUserDefaults standardUserDefaults] setObject:datenow forKey:@"sinaTimestamp"];
                    [LLUserDefaults setValue:markData.marksArray forKey:ALL_TAGS];
                }
            }
        }];
    }
}

+(CGSize)imageFileSize:(NSString*)imageFile
{
    CGSize size;
    
    UIImage* image = [UIImage imageWithContentsOfFile:imageFile];
    
    if (image) {
        size = image.size;
    }
    
    return size;
}

+(BOOL)isLatitudeValid:(NSString*)latitudeStr{
    BOOL isValid = YES;
    if(STR_IS_NIL(latitudeStr)){
        isValid = NO;
    }else{
        if([latitudeStr doubleValue] < -90 || [latitudeStr doubleValue] > 90){
            isValid = NO;
        }
    }
    return isValid;
}

+(BOOL)isLongitudeValid:(NSString*)longitudeStr{
    BOOL isValid = YES;
    if(STR_IS_NIL(longitudeStr)){
        isValid = NO;
    }else{
        if([longitudeStr doubleValue] < -180 || [longitudeStr doubleValue] > 180){
            isValid = NO;
        }
    }
    return isValid;
}

+(BOOL)locationIsValid:(NSString*)latitudeStr longitudeStr:(NSString*)longitudeStr{
    if(STR_IS_NIL(latitudeStr)|| STR_IS_NIL(longitudeStr)){
        return NO;
    }
    if(![GIS_INFO_WRONG_CODE isEqualToString:latitudeStr] && ![GIS_INFO_WRONG_CODE isEqualToString:longitudeStr]){
        return YES;
    }
    return NO;
}

+(void)showStatusToStatusBar:(NSString *)content delegate:(id)delegate statutype:(BOOL)type viewtpye:(UIWindow *)window
{
    // modified by shupeng
    [[JohnStatusBar defaultStatusBar] showTextWithAutoDismiss:content];
    return;
    
    CustomStatusBarNotifierView *notifierView = [[CustomStatusBarNotifierView alloc]
                                                 initWithMessage:content
                                                 delegate:delegate
                                                 statusType:type];
    notifierView.timeOnScreen = 3.0;
    [notifierView showInWindow:window];
}

+(void)showStatusArrayToStatusBar:(NSArray *)contentArray delegate:(id)delegate statutype:(BOOL)type viewtpye:(UIWindow *)window
{
    CustomStatusBarNotifierView *notifierView = [[CustomStatusBarNotifierView alloc]
                                                 initWithMessageArray:contentArray
                                                 delegate:delegate
                                                 statusType:type];
    notifierView.manuallyHide = YES;
    [notifierView showInWindow:window];
    
}

+(NSString*)seprateToDeleteStr:(NSString *)str
{
    if(str.length == 0){
        return @"";
    }
    NSMutableString *resultStr = [NSMutableString string];
    NSArray *strArray = [str componentsSeparatedByString:@","];
    for (int i = 0; i < strArray.count; i++)
    {
        NSString *rsStr = [strArray objectAtIndex:i];
        [resultStr appendFormat:@"\'%@\'",rsStr];
        if ((i+1) < strArray.count)
        {
            [resultStr appendFormat:@","];
        }
    }
    return resultStr;
}

//按主附件，辅附件，解析日记类型（用于日记详情页和编辑页，相关逻辑处理）
DIARY_TYPE getDiaryType(DiaryData *diary){
    DIARY_TYPE diaryType = 0;
    if (diary.d_attachsArray.count)
    {
        for (ParsingAttachsData *data in diary.d_attachsArray)
        {
            // 如果是副内容
            if ([data.d_attachlevel isEqualToString:@"0"])
            {
                if ([data.d_attachtype isEqualToString:@"2"])
                {
                    diaryType |= MINOR_SHORT_RECORD;
                }
                else if ([data.d_attachtype isEqualToString:@"4"])
                {
                    diaryType |= MINOR_TXT;
                }
            }
            // 如果是主内容
            else if ([data.d_attachlevel isEqualToString:@"1"])
            {
                if ([data.d_attachtype isEqualToString:@"1"]) {
                    diaryType = MAJOR_VIDEO;
                }
                else if ([data.d_attachtype isEqualToString:@"2"])
                {
                    diaryType = MAJOR_LONG_RECORD;
                }
                else if ([data.d_attachtype isEqualToString:@"3"])
                {
                    diaryType = MAJOR_PHOTO;
                }
            }
        }
    }

    return diaryType;
}

+(NSURL*)convertUrlStrToNSURL:(NSString*)urlString{
    NSURL *url = nil;
    if (!STR_IS_NIL(urlString)) {
        if ([urlString hasPrefix:@"http://"]) {
            url = [NSURL URLWithString:urlString];
        } else {
            url = [NSURL fileURLWithPath:urlString];
        }
    }
    return url;
}

+(UIImage*)imageByScalingAndCroppingForSize:(UIImage *)sourceImage withTargetSize: (CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
	
	CGFloat imgRatio = width / height;
	CGFloat maxRatio = targetWidth / targetHeight;
	
	if( imgRatio != maxRatio ){
		if(imgRatio < maxRatio){
			imgRatio = targetWidth / height;
			scaledWidth = imgRatio * width;
			scaledHeight = targetHeight;
		} else {
			imgRatio = targetHeight / width;
			scaledWidth = imgRatio * height;
			scaledHeight = targetWidth;
		}
	}
	
	CGRect rect = CGRectMake(0.0, 0.0, scaledWidth, scaledHeight);
	UIGraphicsBeginImageContext(rect.size);
	[sourceImage drawInRect:rect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

//设置本地提醒
+ (UILocalNotification *)setLocalNotification:(int)number :(NSString*)str
{
    UIApplication* app = [UIApplication sharedApplication];
    NSArray* oldNotifications = [app scheduledLocalNotifications];
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    // Create a new notification.
    UILocalNotification* alarm =[[UILocalNotification alloc] init];
    if (alarm){
        alarm.alertBody = str;
        alarm.soundName = UILocalNotificationDefaultSoundName;
        alarm.repeatInterval = 0;
        alarm.applicationIconBadgeNumber = number;//提示数量
        NSDate* now = [NSDate new];
        alarm.fireDate = [now dateByAddingTimeInterval:5];//延迟秒 保证最后一次
        alarm.timeZone = [NSTimeZone defaultTimeZone];
    }
    return alarm;
}

//等比例缩放
+(UIImage*)UIImageScaleToSize:(UIImage*)sourceImg :(CGSize)size
{
    UIImage* scaledImage = nil;
    if (!OBJ_IS_NIL(sourceImg)) {
        CGFloat width = CGImageGetWidth(sourceImg.CGImage);
        CGFloat height = CGImageGetHeight(sourceImg.CGImage);
        
        float verticalRadio = size.height*1.0/height;
        float horizontalRadio = size.width*1.0/width;
        
        float radio = 1;
        if(verticalRadio>1 && horizontalRadio>1)
        {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
        }
        else
        {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
        }
        
        width = width*radio;
        height = height*radio;
        
        int xPos = (size.width - width)/2;
        int yPos = (size.height-height)/2;
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(size);
        
        // 绘制改变大小的图片
        [sourceImg drawInRect:CGRectMake(xPos, yPos, width, height)];
        
        // 从当前context中创建一个改变大小后的图片
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 * 功能：根据日记id获取日记内容（用于查看副本之类得上一级页面没有传过来得）
 * 参数：(NSString *)diaryId 日记 (void(^)(RIA_RESPONSE_CODE riaResponseCode))block 回调代码块(成功得时候就重新从数组中获取日记数据，失败了提示当前日记数据暂时无法获取）
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-03
 */
+(void) getDiaryContent:(NSString *)diaryId block:(void(^)(RIA_RESPONSE_CODE riaResponseCode, DiaryData *resultData))block
{
    NSString *whereStr = [NSString stringWithFormat:@"diaryid = \'%@\'",diaryId];
    
    [[LLDAOBase shardLLDAOBase] searchAll:[[LLDaoModelDiary alloc] init]
                                    where:whereStr
                                 callback:^(NSArray *resultArray)
     {
         if (resultArray.count > 0)
         {
             LLDaoModelDiary *diaryModelDiary = [resultArray objectAtIndex:0];
             DiaryData *diaryResultData = [Tools convertLLDaoModelDiaryToDiaryData:diaryModelDiary];
             block(RIA_RESPONSE_CODE_SUCCESS, diaryResultData);
         }
         else
         {
             NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
             [paramDic setObject:APP_USERID forKey:@"userid"];
             [paramDic setObject:diaryId forKey:@"diaryid"];
             
             RequestModel *requestModel = [[RequestModel alloc] initWithUrl:GET_DIARY_DETAIL params:paramDic];
             
             [[RIAWebRequestLib riaWebRequestLib] fetchDataFromNet:requestModel
                                                    dataModelClass:[DiaryDetailsInfoData class]
                                                         mainBlock:^(BaseData *responseData)
              {
                  if (responseData.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS)
                  {
                      DiaryDetailsInfoData *diaryDetailsInfoData = (DiaryDetailsInfoData *)responseData;
                      DiaryData *diatyData = diaryDetailsInfoData.diaries;
                      if (diatyData)
                      {
                          // 将新数据插入到数据库中
                          LLDaoModelDiary *llDaoModelDiary = [[LLDaoModelDiary alloc] init];
                          llDaoModelDiary = [Tools convertDiaryDataToLLDaoModelDiary:diatyData];
                          LLDAOBase *llDaoBase = [LLDAOBase shardLLDAOBase];
                          // 插入新日记数据到数据库中
                          [llDaoBase insertToDB:llDaoModelDiary callback:^(BOOL result){}];
                          
                      }
                      block(responseData.responseStatusCode,diatyData);
                  }
                  else
                  {
                      // 日记不存在  此处预留提示
                      if ([responseData.status isEqualToString:@"138102"])
                      {
                          block(responseData.responseStatusCode,nil);
                      }
                      else
                      {
                          block(responseData.responseStatusCode,nil);
                      }
                  }
              }];
         }
     }];
}

/*
 * 时间戳转成 xx'xx''显示的格式
 */
+ (NSString *)getDurationText:(NSTimeInterval)duration
{
    NSString *durationStr = nil;
    if (duration > 0) {
        if ((int)ceil(duration)/60 == 0) {
            durationStr = [NSString stringWithFormat:@"%d\"",(int)ceil(duration)%60];
        }
        else {
            durationStr = [NSString stringWithFormat:@"%d'%d\"", (int)ceil(duration)/60,(int)ceil(duration)%60];
        }
        
        // 如果发现时长介于0到1秒之间，则显示1秒。
        if ([durationStr isEqualToString:@"0\""]) {
            durationStr = @"1\"";
        }
    }
    else {
        durationStr = @"0";
    }
    
    return durationStr;
}

/*
 * 时间格式转换成时间戳
 */
+ (NSString *)getDateFormatToTimeStamp:(NSString *)timestr
{    
    if ([timestr isEqualToString:@""]) {
        return @"";
    }
    
    NSRange range1 = [timestr rangeOfString:@":"];//判断字符串是否包含
    if (range1.location != NSNotFound) {
        
        NSRange range = [timestr rangeOfString:@"."];//判断字符串是否包含
        if (range.location != NSNotFound)//不包含
        {
            timestr = [timestr substringWithRange:NSMakeRange(0,range.location)];
        }
        
        NSString * start = @"00:00:00";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateStyle:NSDateFormatterMediumStyle];
        //[formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        
        NSDate *zero = [formatter dateFromString:start];
        NSDate* date = [formatter dateFromString:timestr]; //------------将字符串按formatter转成nsdate
//        NSLog(@"seconds: %lf", CFDateGetTimeIntervalSinceDate((CFDateRef)date, (CFDateRef)zero));
//        //NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
//        //时间转时间戳的方法:
//        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]/86400];
//        NSLog(@"timeSp:%@",timeSp); //时间戳的值
//        
////        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////        [formatter setDateFormat:@"HH:ss"];
////        NSDate *curDate = [formatter dateFromString:@"12:32"];
//        
        
        return [Tools getDurationText:CFDateGetTimeIntervalSinceDate((CFDateRef)date, (CFDateRef)zero)];
        
    }
    
    NSString *timeSp = [Tools getDurationText:[timestr doubleValue]];
    
    return timeSp;
}

/**
 * 功能：删除服务器要删除的日记
 * 参数：服务器回传的removeids
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013－07－17
 */
+ (void) deleteModelDiary:(NSString *)diaryids block:(void(^)(BOOL result)) block
{
    NSString *deleteWhereStr = [self seprateToDeleteStr:diaryids];
    // 清除服务器要删除的 但是未发布的要保留
    NSString *whereStr = [NSString stringWithFormat:@"upload_status == \'-3\' AND diaryid in (%@)",deleteWhereStr];
    [[LLDAOBase shardLLDAOBase] deleteToDBWithWhere:[[LLDaoModelDiary alloc] init]
                                              where:whereStr
                                           callback:^(BOOL result)
     {
         block(result);
     }];
}

+(double)mediaDuration:(NSString *)fileFullPath
{
    double result = 0;
    if (!STR_IS_NIL(fileFullPath) && [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
        NSURL * videoURL = [NSURL fileURLWithPath:fileFullPath];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
        NSParameterAssert(asset);
        result=CMTimeGetSeconds(asset.duration);
    }
    return result;
}
/*
 * 排序（按时间）
 */
+ (void)orderByUpdateTime : (NSMutableArray *)array
{
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        DiaryData *myObj1 = (DiaryData*)obj1;
        DiaryData *myObj2 = (DiaryData*)obj2;
        
        NSComparisonResult result = NSOrderedSame;
        
        if([myObj1.d_updatetimemilli longLongValue]==[myObj2.d_updatetimemilli longLongValue])
        {
            result = NSOrderedSame;
        }
        else if([myObj1.d_updatetimemilli longLongValue] > [myObj2.d_updatetimemilli longLongValue])
        {
            result = NSOrderedAscending;
        }
        else
            result = NSOrderedDescending;
        
        return result;
    }];
    
}

+(long long)getSystemFreeSpace
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSDictionary *fileSysAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:path];
    NSNumber *FreeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    long long freespace = [FreeSpace longLongValue];
    return freespace;
}

/**
 * 功能: 从指定位置copy文件到指定的位置
 * 参数：服务器回传的removeids
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013－07－17
 */
+(void)copyLocalFileFrom:(NSString *)fromLocalFilePath to:(NSString *)toLocalFilePath
{
//    if ([[NSFileManager defaultManager] fileExistsAtPath:toLocalFilePath]) {
//        NSLog(@"文件已经存在了");
//    }else {
    NSData *needCopyFileData = [NSData dataWithContentsOfFile:fromLocalFilePath];
    [[NSFileManager defaultManager] createFileAtPath:toLocalFilePath
                                            contents:needCopyFileData
                                          attributes:nil];
//    }

}

//获取网络文件的大小
+(void)getNetUrlLength:(NSString*)url :(void (^)(unsigned long long length))block
{
    [APP_DELEGATE.tools.netUrlLength fetchNetUrlLength:url:block];
}

+(void)getNetUrlStatusAndType:(NSString*)url :(void (^)(int status,NSString* type,unsigned long long length))block
{
    [APP_DELEGATE.tools.netUrlStatusAndType fetchNetUrlStatusAndType:url:block];
}
@end









