//
//  LocalResourceInitModel.h
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalResourceModel : NSObject
@property(nonatomic,strong) NSString* videosShootPath;
@property(nonatomic,strong) NSString* llDataBaseFile;
@property(nonatomic,strong) NSString* frontCoverPath;
-(void)initWithUserID:(NSString*)userid;
+(LocalResourceModel *)sharedLocalResourceModel;

+(NSString*)getUseridPath;
+(NSString*)getLlDataBaseFile;
+(NSString*)getVideosPath;
+(NSString*)VideosShootPath;
+(NSString*)VideosDownloadPath;
+(NSString*)getSoundsPath;
+(NSString*)getSoundsRecordPath;
+(NSString*)getSoundsDownloadPath;
+(NSString*)getImagesPath;
+(NSString*)getImageCatchPath;
+(NSString*)getImageDownloadPath;
+(NSString*)getFrontCoverPath;
+(NSString*)getImageShootPath;
//add by xudongsheng
+(NSString*)getVideosShootEdittmpPath;
+(NSString*)getVideosDownloadEdittmpPath;
+(NSString*)getSoundsRecordEdittmpPath;
+(NSString*)getSoundsDownloadEdittmpPath;
+(NSString*)getImageShootEditPath;

/**
 * 功能：私信内容存在本地文件夹
 * 参数：空
 * 返回值：私信存放路径
 
 * 创建者：dong
 * 创建日期：2013-08-04
 */
+(NSString*)getPrivateMessagePath;

/**
 * 功能：删除本地文件
 * 参数：(NSString *) localFilePath 需要删除的路径
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-25
 */
+(void)deleteLocalFile:(NSString *) localFilePath;

//单例销毁
-(void)attemptDealloc;
@end
