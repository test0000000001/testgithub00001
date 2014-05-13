//
//  LocalResourceInitModel.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LocalResourceModel.h"
#import "SandboxFile.h"
#import "Global.h"

@interface LocalResourceModel()

@property(nonatomic,strong) NSString* userid;
@property(nonatomic,strong) NSString* useridPath;
@property(nonatomic,strong) NSString* videosPath;
@property(nonatomic,strong) NSString* videosDownloadPath;
@property(nonatomic,strong) NSString* soundsPath;
@property(nonatomic,strong) NSString* soundsRecordPath;
@property(nonatomic,strong) NSString* soundsDownloadPath;
@property(nonatomic,strong) NSString* imagesPath;
@property(nonatomic,strong) NSString* imageDownloadPath;
@property(nonatomic,strong) NSString* imageCatchPath;
@property(nonatomic,strong) NSString* imageShootPath;

//add by xudongsheng
@property(nonatomic,strong) NSString* videosShootEdittmpPath;
@property(nonatomic,strong) NSString* videosDownloadEdittmpPath;
@property(nonatomic,strong) NSString* soundsRecordEdittmpPath;
@property(nonatomic,strong) NSString* soundsDownloadEdittmpPath;
@property(nonatomic,strong) NSString* imageShootEditPath;

@property(nonatomic,strong) NSString* privateMessagePath;
@end

@implementation LocalResourceModel
static id SharedInstance;
+(LocalResourceModel *)sharedLocalResourceModel
{
    @synchronized(SharedInstance)
    {
        if (!SharedInstance)
        {
            SharedInstance=[[self alloc]init];
        }
    }
    return SharedInstance;
}

-(void)initWithUserID:(NSString*)userid
{
    self.userid=userid;
    
    NSString* documentPath = [SandboxFile GetDocumentPath];
    
    NSString* versionPath = [SandboxFile CreateList:documentPath ListName:@"3_0"];
    
    self.useridPath = [SandboxFile CreateList:versionPath ListName:_userid];
    self.llDataBaseFile = [SandboxFile GetPathForDocuments:@"ll.db" inDir:[@"3_0" stringByAppendingPathComponent:_userid]];
    
    self.videosPath = [SandboxFile CreateList:_useridPath ListName:@"videos"];
    self.videosShootPath = [SandboxFile CreateList:_videosPath ListName:@"shoot"];
    self.videosDownloadPath = [SandboxFile CreateList:_videosPath ListName:@"download"];
    
    self.soundsPath = [SandboxFile CreateList:_useridPath ListName:@"sounds"];
    self.soundsRecordPath = [SandboxFile CreateList:_soundsPath ListName:@"record"];
    self.soundsDownloadPath = [SandboxFile CreateList:_soundsPath ListName:@"download"];
    
    self.imagesPath = [SandboxFile CreateList:_useridPath ListName:@"images"];
    self.imageCatchPath = [SandboxFile CreateList:_imagesPath ListName:@"imagecatch"];
    self.frontCoverPath = [SandboxFile CreateList:_imagesPath ListName:@"frontcover"];
    self.imageShootPath = [SandboxFile CreateList:_imagesPath ListName:@"shoot"];
    self.imageDownloadPath = [SandboxFile CreateList:_imagesPath ListName:@"download"];
    self.videosShootEdittmpPath = [SandboxFile CreateList:_videosShootPath ListName:@"edittmp"];
    self.videosDownloadEdittmpPath = [SandboxFile CreateList:_videosDownloadPath ListName:@"edittmp"];
    self.soundsRecordEdittmpPath = [SandboxFile CreateList:_soundsRecordPath ListName:@"edittmp"];
    self.soundsDownloadEdittmpPath = [SandboxFile CreateList:_soundsDownloadPath ListName:@"edittmp"];
    self.imageShootEditPath = [SandboxFile CreateList:_imageShootPath ListName:@"edittmp"];
    
    self.privateMessagePath = [SandboxFile CreateList:_useridPath ListName:@"privateMessage"];
}

+(NSString*)getUseridPath
{
    return [LocalResourceModel sharedLocalResourceModel].useridPath;
}

+(NSString*)getLlDataBaseFile
{
    return [LocalResourceModel sharedLocalResourceModel].llDataBaseFile;
}

+(NSString*)getVideosPath
{
    return [LocalResourceModel sharedLocalResourceModel].videosPath;
}

+(NSString*)VideosShootPath
{
    return [LocalResourceModel sharedLocalResourceModel].videosShootPath;
}

+(NSString*)VideosDownloadPath
{
    return [LocalResourceModel sharedLocalResourceModel].videosDownloadPath;
}

+(NSString*)getSoundsPath
{
    return [LocalResourceModel sharedLocalResourceModel].soundsPath;
}

+(NSString*)getSoundsRecordPath
{
    return [LocalResourceModel sharedLocalResourceModel].soundsRecordPath;
}

+(NSString*)getSoundsDownloadPath
{
    return [LocalResourceModel sharedLocalResourceModel].soundsDownloadPath;
}

+(NSString*)getImagesPath
{
    return [LocalResourceModel sharedLocalResourceModel].imagesPath;
}

+(NSString*)getImageCatchPath
{
    return [LocalResourceModel sharedLocalResourceModel].imageCatchPath;
}
+(NSString*)getImageDownloadPath
{
    return [LocalResourceModel sharedLocalResourceModel].imageDownloadPath;
}

+(NSString*)getFrontCoverPath
{
    return [LocalResourceModel sharedLocalResourceModel].frontCoverPath;
}

+(NSString*)getImageShootPath
{
    return [LocalResourceModel sharedLocalResourceModel].imageShootPath;
}

+(NSString*)getVideosShootEdittmpPath{
  return [LocalResourceModel sharedLocalResourceModel].videosShootEdittmpPath;
}

+(NSString*)getVideosDownloadEdittmpPath{
  return [LocalResourceModel sharedLocalResourceModel].videosDownloadEdittmpPath;
}

+(NSString*)getSoundsRecordEdittmpPath{
  return [LocalResourceModel sharedLocalResourceModel].soundsRecordEdittmpPath;
}

+(NSString*)getSoundsDownloadEdittmpPath{
 return [LocalResourceModel sharedLocalResourceModel].soundsDownloadEdittmpPath;
}

+(NSString*)getImageShootEditPath{
    return [LocalResourceModel sharedLocalResourceModel].imageShootEditPath;
}

/**
 * 功能：删除本地文件
 * 参数：(NSString *) localFilePath 需要删除的路径
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-25
 */
+(void)deleteLocalFile:(NSString *) localFilePath
{
    if(localFilePath.length > 0){
        NSFileManager *fileMgr = [[NSFileManager alloc] init];
        NSError *err;
        [fileMgr removeItemAtPath:localFilePath error:&err];
        NSLog(@"%@路径下文件被成功删除",localFilePath);
    }
}



//单例销毁
-(void)attemptDealloc
{
    SharedInstance = nil;
}

/**
 * 功能：私信内容存在本地文件夹
 * 参数：空
 * 返回值：私信存放路径
 
 * 创建者：dong
 * 创建日期：2013-08-04
 */
+(NSString*)getPrivateMessagePath
{
    return [LocalResourceModel sharedLocalResourceModel].privateMessagePath;
}
@end
