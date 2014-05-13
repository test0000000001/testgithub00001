//
//  LLDaoModelDiary.m
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelDiary.h"
#import "LLDaoBase.h"
#import "NSObject+ABJsonConverter.h"
#import "Global.h"
#import "Tools.h"
#import "GetMessageModel.h"
#import "LocalResourceModel.h"
#import "LLTaskManager.h"
#import "LLFreeTaskManager.h"
#import "LLDeleteDiaryTask.h"
#import "UIImage+Resize.h"

@implementation LLDaoModelDiaryTagCell
@end

@implementation LLDaoModelDiarySnsCell
+(id)customClassWithProperties:(id)properties
{
    LLDaoModelDiarySnsCell* returnObject = [super customClassWithProperties:properties];
    [Tools arrayToClass:returnObject.shareinfo:[LLDaoModelDiarySnsCellShareinfoCell class]];
    return returnObject;
}
@end

@implementation LLDaoModelDiarySnsCellShareinfoCell
@end

@implementation LLDaoModelDiaryAttachsCell
-(id)init
{
    if (self = [super init]) {
        self.attachaudio = [[NSMutableArray alloc]initWithCapacity:10];
        self.attachvideo = [[NSMutableArray alloc]initWithCapacity:10];
        self.attachimage = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}

-(void)createDefault
{
    self.attachuuid = @"";
    self.attachid = @"";
    self.attachtype = @"";              //附件类型，1视频、2音频、3图片、4文字
    self.content = @"";                 // 内容
    self.videocover = @"";              // 视频封面
    self.is_encrypt = @"1";              // 原音可见范围，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见，attachtype=2有效
    self.attachlevel = @"1";//附件级别,区分是主文件还是辅助文件。1主内容、0辅内容
    self.playtime = @"";
    self.attachtimemilli = [GetMessageModel getSystemCurrentTime];//附件建立毫秒数
    self.playtimes = @"0";
    self.pic_width = @"100";
    self.pic_height = @"100";
    self.show_width = @"100";
    self.show_height = @"100";
    self.attach_logitude = @"100";          //经纬度,服务器缺少
    self.attach_latitude = @"100";
    self.createType = @"1";// 附件形成类型,1正常,n分段
    self.Operate_type = @"1";
    self.audio_type = @"1";
    self.photo_type = @"0";
    self.video_type = @"0";
}

+(id)customClassWithProperties:(id)properties
{
    LLDaoModelDiaryAttachsCell* returnObject = [super customClassWithProperties:properties];
    [Tools arrayToClass:returnObject.attachvideo:[LLDaoModelDiaryAttachsCellVideopathCell class]];
    [Tools arrayToClass:returnObject.attachaudio:[LLDaoModelDiaryAttachsCellAttachaudioCell class]];
    [Tools arrayToClass:returnObject.attachimage:[LLDaoModelDiaryAttachsCellAttachimageCell class]];
    return returnObject;
}

-(NSString*)suffix
{
    NSString* result = @"";
    //附件类型，1视频、2音频、3图片、4文字
    if ([_attachtype isEqualToString:@"1"]) {
        result = @".mp4";
    }
    else if([_attachtype isEqualToString:@"2"])
    {
        result = @".mp4";
    }
    else if([_attachtype isEqualToString:@"3"])
    {
        result = @".png";
    }
    return result;
}

-(void)setLocalPath:(NSString*)localPath
{
    self.localfilePath = localPath;
    self.localSize = [NSString stringWithFormat:@"%lld",[Tools calculatefolderSizeAtPath:localPath]];
    CGSize size;
    if([_attachtype isEqualToString:@"1"])
    {
        size = [Tools imageFileSize:_videocover];
        
    }
    else if([_attachtype isEqualToString:@"3"])
    {
        size = [Tools imageFileSize:_localfilePath];
    }
    self.show_height = [NSString stringWithFormat:@"%f",size.height];
    self.show_width = [NSString stringWithFormat:@"%f",size.width];
    self.pic_height = [NSString stringWithFormat:@"%f",size.height];
    self.pic_width = [NSString stringWithFormat:@"%f",size.width];
}
@end

@implementation LLDaoModelDiaryAttachsCellAttachimageCell
@end

@implementation LLDaoModelDiaryAttachsCellAttachaudioCell
@end

@implementation LLDaoModelDiaryAttachsCellVideopathCell
@end


@implementation LLDaoModelDiaryActiveCell
@end

@implementation LLDaoModelDiaryDuplicateCell
@end

@implementation PlatformUrlCell
@end

@implementation LLDaoModelDiary


+(id)customClassWithProperties:(id)properties
{
    LLDaoModelDiary* returnObject = [super customClassWithProperties:properties];
    returnObject.active = [LLDaoModelDiaryActiveCell customClassWithProperties:returnObject.active];
    [Tools arrayToClass:returnObject.attachs :[LLDaoModelDiaryAttachsCell class]];
    [Tools arrayToClass:returnObject.sns:[LLDaoModelDiarySnsCell class]];
    [Tools arrayToClass:returnObject.duplicate:[LLDaoModelDiaryDuplicateCell class]];
    [Tools arrayToClass:returnObject.tags:[LLDaoModelDiaryTagCell class]];
    [Tools arrayToClass:returnObject.platformurls :[PlatformUrlCell class]];
    return returnObject;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.primaryKey = @"diaryuuid";
        self.join_safebox = @"0";
        [self initDefaultValue];
    }
    return self;
}

-(void)initDefaultValue
{
    self.fromOldversion2_2 = @"";
    self.weather = [LLGlobalService sharedLLGlobalService].weather;
    self.weather_info = [LLGlobalService sharedLLGlobalService].weather_info;
    self.addresscode = CURRENT_CITYCODE;
    self.is_delete = @"0";
    self.position_source = @"";
    self.uploadTask_taskID = -1;
    self.isFavorite = @"n";              // 是否已收藏
    self.diaryuuid = @"";
    self.join_safebox = @"0";
    self.diaryid = @"";
    self.resourcediaryid = @"";
    self.resourceuuid = @"";
    self.mood = @"";
    self.publishid = @"";
    self.diarytimemilli = [GetMessageModel getSystemCurrentTime];
    self.updatetimemilli = [GetMessageModel getSystemCurrentTime];
    self.introduction = @"";
    self.publish_status = @"";
    self.position_status = @"";
    self.publishtaskid = -1;
    self.sharetaskid = -1;
    self.safeboxTaskId = -1;
    self.sns  = [[NSMutableArray alloc]initWithCapacity:10];
//    LLDaoModelDiarySnsCell* lLDaoModelDiarySnsCell = [[LLDaoModelDiarySnsCell alloc]init];
//    lLDaoModelDiarySnsCell.snscontent = @"";
//    lLDaoModelDiarySnsCell.sharetime = @"";
//    lLDaoModelDiarySnsCell.shareinfo = [[NSMutableArray alloc]initWithCapacity:10];
//    LLDaoModelDiarySnsCellShareinfoCell* lLDaoModelDiarySnsCellShareinfoCell = [[LLDaoModelDiarySnsCellShareinfoCell alloc]init];
//    lLDaoModelDiarySnsCellShareinfoCell.snstype = @"1";
//    lLDaoModelDiarySnsCellShareinfoCell.snsid = @"1";
//    lLDaoModelDiarySnsCellShareinfoCell.weiboid = @"1";
//    [lLDaoModelDiarySnsCell.shareinfo addObject:lLDaoModelDiarySnsCellShareinfoCell];
//    [_sns addObject:lLDaoModelDiarySnsCell];
    self.snscollect_sina = @"";
    self.snscollect_tencent = @"";
    self.iscollect = @"0";
    self.tags = [[NSMutableArray alloc]initWithCapacity:10];
//    LLDaoModelDiaryTagCell* lLDaoModelDiaryTagCell = [[LLDaoModelDiaryTagCell alloc]init];
//    lLDaoModelDiaryTagCell.id = @"";
//    lLDaoModelDiaryTagCell.name = @"";
//    [_tags addObject:lLDaoModelDiaryTagCell];
    self.position = APP_POSITIONMODEL.position;
    if (!STR_IS_NIL(APP_GPS)) {
        NSArray *gpsArray = [APP_GPS componentsSeparatedByString:@","];
        if(gpsArray.count > 1)
        {
            self.longitude = [gpsArray objectAtIndex:1];//分享经度，可能为空
            self.latitude = [gpsArray objectAtIndex:0];//分享纬度可能为空
            self.offset = APP_POSITIONMODEL_HorizontalAccuracy;
        }
    }
    self.sex = @"1";
    self.signature = @"";
    self.diary_status = @"-2";
    self.upload_status = @"-4";
    self.synchronization_status = @"0";
    self.enjoycount = @"0";
    self.location_status = @"0";
    self.commentcount = @"0";
    self.forwardcount = @"0";
    self.collectcount = @"0";
    self.weight = @"1";                  // 权重值
    self.size = @"0";                    // 日记大小（单位M）
    self.platformurls = [NSMutableArray array];
    self.isShortSoundRecognizedToText = @"1";
    
    self.attachs = [[NSMutableArray alloc]initWithCapacity:10];
    
    self.active = [[LLDaoModelDiaryActiveCell alloc]init];
    _active.activeid = @"";
    _active.activename = @"";
    _active.starttime = @"";
    _active.endtime = @"";
    _active.introduction = @"";
    _active.add_way = @"";
    _active.rule = @"";
    _active.prize = @"";
    _active.picture = @"";
    _active.isjoin = @"0";
    _active.iseffective = @"0";
    
    self.duplicate = [[NSMutableArray alloc]initWithCapacity:10];
}

+(NSString*)fetchLocalFilePath :(NSString*)localDiaryID
{
    __block NSString* localfilePath = @"";
    LLDaoModelDiary *lLDaoModelDiary = [[LLDaoModelDiary alloc] init];
    [[LLDAOBase shardLLDAOBase] searchWhere:lLDaoModelDiary
                                     String:[NSString stringWithFormat:@"localDiaryID = \'%@\'",localDiaryID]
                                    orderBy:nil
                                     offset:0
                                      count:1
                                   callback:^(NSArray *resultArray)
     {
         for (LLDaoModelDiary* cell in resultArray) {
             if ([cell.attachs count] > 0) {
                 localfilePath = ((LLDaoModelDiaryAttachsCell*)[cell.attachs objectAtIndex:0]).localfilePath;
                 //LLDaoModelDiaryAttachsCell* attachsCell = [LLDaoModelDiaryAttachsCell customClassWithProperties:[cell.attachs objectAtIndex:0]];
                 
                 //if ([attachsCell.attachvideo count] > 0) {
                     //LLDaoModelDiaryAttachsCellVideopathCell* videopathCell = [LLDaoModelDiaryAttachsCellVideopathCell customClassWithProperties:[attachsCell.attachvideo objectAtIndex:0]];
                     //localfilePath = videopathCell.localfilePath;
                 //}
             }
     }
     }];
     
     return localfilePath;
}

-(NSString*)imageForShow
{
    NSString* result = @"";
    
    if ([_attachs count] > 0) {
        LLDaoModelDiaryAttachsCell* attachsCell = [_attachs objectAtIndex:0];
        if ([attachsCell.attachtype isEqualToString:@"1"]) {
            result = attachsCell.videocover;
        }
        else if ([attachsCell.attachtype isEqualToString:@"2"])
        {
            //3_local_guanli_luyin@2x
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            result = [resourcePath stringByAppendingPathComponent:@"3_local_guanli_luyin@2x.png"];
        }
        else if ([attachsCell.attachtype isEqualToString:@"3"])
        {
            if (!STR_IS_NIL(attachsCell.localfilePath)) {
                result = attachsCell.localfilePath;
            }
            else if (!STR_IS_NIL(attachsCell.downLoadFilePath))
            {
                result = attachsCell.downLoadFilePath;
            }
            else if (attachsCell.attachimage.count > 0)
            {
                LLDaoModelDiaryAttachsCellAttachimageCell *imageCell = [attachsCell.attachimage objectAtIndex:0];
                result = imageCell.imageurl;
            }
        }
        else if ([attachsCell.attachtype isEqualToString:@"4"]) {
            //3_local_guanli_nothing@2x
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            result = [resourcePath stringByAppendingPathComponent:@"3_local_guanli_nothing@2x.png"];
        }
    }
    return result;
}

-(NSString*)tagsString
{
    NSString* result = @"";
    for (LLDaoModelDiaryTagCell* cell in _tags) {
        if (!STR_IS_NIL(result)) {
            result = [result stringByAppendingFormat:@","];
        }
        result = [result stringByAppendingFormat:@"%@",cell.id];
    }
    return result;
}

-(void)setLocalPath:(NSString*)localPath :(NSString*)attachUUid
{
    for (LLDaoModelDiaryAttachsCell* attachsCell in _attachs) {
        if ([attachsCell.attachuuid isEqualToString:attachUUid]) {
            attachsCell.localfilePath = localPath;
            attachsCell.localSize = [NSString stringWithFormat:@"%lld",[Tools calculatefolderSizeAtPath:localPath]];
            CGSize size;
            if([attachsCell.attachtype isEqualToString:@"1"])
            {
                size = [Tools imageFileSize:attachsCell.videocover];
                
            }
            else if([attachsCell.attachtype isEqualToString:@"3"])
            {
                size = [Tools imageFileSize:attachsCell.localfilePath];
            }
            attachsCell.show_height = [NSString stringWithFormat:@"%f",size.height];
            attachsCell.show_width = [NSString stringWithFormat:@"%f",size.width];
            attachsCell.pic_height = [NSString stringWithFormat:@"%f",size.height];
            attachsCell.pic_width = [NSString stringWithFormat:@"%f",size.width];
        
        }
    }
}

-(void)setCoverImage:(NSString*)imageFile :(NSString*)attachUUid
{
    for (LLDaoModelDiaryAttachsCell* attachsCell in _attachs) {
        if ([attachsCell.attachuuid isEqualToString:attachUUid]) {
            attachsCell.videocover = imageFile;
            CGSize size;
            if([attachsCell.attachtype isEqualToString:@"1"])
            {
                size = [Tools imageFileSize:attachsCell.videocover];
                
            }
            attachsCell.show_height = [NSString stringWithFormat:@"%f",size.height];
            attachsCell.show_width = [NSString stringWithFormat:@"%f",size.width];
            attachsCell.pic_height = [NSString stringWithFormat:@"%f",size.height];
            attachsCell.pic_width = [NSString stringWithFormat:@"%f",size.width];
        }
    }
}

-(NSString*)localPath
{
    NSString* result = @"";
    for (LLDaoModelDiaryAttachsCell* attachsCell in _attachs) {
        if ([attachsCell.attachlevel isEqualToString:@"1"]) {
            result = attachsCell.localfilePath;
        }
    }
    return result;
}

-(NSString*)localSize
{
    double l = 0;
    for (LLDaoModelDiaryAttachsCell* attachsCell in _attachs) {
        l+=[attachsCell.localSize longLongValue];
        l+=[attachsCell.downLoadSize longLongValue];
    }
    // 注释 因为网络下载任务需要总的
//    self.size = [NSString stringWithFormat:@"%.2f",l/(float)1024/1024];
    return [NSString stringWithFormat:@"%f",l];
}

//-(long long)partOflocalSize:(int)index
//{
//    long long l = 0;
//    int i = 0;
//    for (LLDaoModelDiaryAttachsCell* attachsCell in _attachs) {
//        if (i>=index) {
//            break;
//        }
//        l+=[attachsCell.size longLongValue];
//        i++;
//    }
//    return l;
//}

+(LLDaoModelDiary*)diaryFromUuid:(NSString*)uuid
{
    __block LLDaoModelDiary *lLDaoModelDiary = nil;
    [[LLDAOBase shardLLDAOBase] searchWhere:[[LLDaoModelDiary alloc] init]
                                     String:[NSString stringWithFormat:@"diaryuuid = \'%@\'",uuid]
                                    orderBy:nil
                                     offset:0
                                      count:1
                                   callback:^(NSArray *resultArray)
     {
         for (LLDaoModelDiary* cell in resultArray) {
             lLDaoModelDiary = cell;
             break;
         }
     }];
    return lLDaoModelDiary;

}

+(LLDaoModelDiary*)diaryFromId:(NSString*)diaryid
{
    __block LLDaoModelDiary *lLDaoModelDiary = nil;
    [[LLDAOBase shardLLDAOBase] searchWhere:[[LLDaoModelDiary alloc] init]
                                     String:[NSString stringWithFormat:@"diaryid = \'%@\'",diaryid]
                                    orderBy:nil
                                     offset:0
                                      count:1
                                   callback:^(NSArray *resultArray)
     {
         for (LLDaoModelDiary* cell in resultArray) {
             lLDaoModelDiary = cell;
             break;
         }
     }];
    return lLDaoModelDiary;
}


+(LLDaoModelDiaryAttachsCellVideopathCell*)getVideoAttach :(NSString*)diaryuuid :(NSString*)attachuuid
{
    __block LLDaoModelDiaryAttachsCellVideopathCell* result = nil;
    LLDaoModelDiary *lLDaoModelDiary = [[LLDaoModelDiary alloc] init];
    [[LLDAOBase shardLLDAOBase] searchWhere:lLDaoModelDiary
                                     String:[NSString stringWithFormat:@"diaryuuid = \'%@\'",diaryuuid]
                                    orderBy:nil
                                     offset:0
                                      count:1
                                   callback:^(NSArray *resultArray)
     {
         for (LLDaoModelDiary* cell in resultArray) {
             for (LLDaoModelDiaryAttachsCell* attachsCell in cell.attachs) {
                 if ([attachsCell.attachuuid isEqualToString:attachuuid]) {
                     if ([attachsCell.attachtype isEqualToString:@"1"]) {
                         if( [attachsCell.attachvideo count] > 0)
                         {
                             result = [attachsCell.attachvideo objectAtIndex:0];
                         }
                     }
                     
                 }
             }
         }
     }];
    return result;
}

+(LLDaoModelDiaryAttachsCellAttachaudioCell*)getAudioAttach :(NSString*)diaryuuid :(NSString*)attachuuid
{
    __block LLDaoModelDiaryAttachsCellAttachaudioCell* result = nil;
    LLDaoModelDiary *lLDaoModelDiary = [[LLDaoModelDiary alloc] init];
    [[LLDAOBase shardLLDAOBase] searchWhere:lLDaoModelDiary
                                     String:[NSString stringWithFormat:@"diaryuuid = \'%@\'",diaryuuid]
                                    orderBy:nil
                                     offset:0
                                      count:1
                                   callback:^(NSArray *resultArray)
     {
         for (LLDaoModelDiary* cell in resultArray) {
             for (LLDaoModelDiaryAttachsCell* attachsCell in cell.attachs) {
                 if ([attachsCell.attachuuid isEqualToString:attachuuid]) {
                     if ([attachsCell.attachtype isEqualToString:@"2"]) {
                         if( [attachsCell.attachaudio count] > 0)
                         {
                             result = [attachsCell.attachaudio objectAtIndex:0];
                         }
                     }
                 }
             }
         }
     }];
    return result;
}

+(LLDaoModelDiaryAttachsCellAttachimageCell*)getImageAttach :(NSString*)diaryuuid :(NSString*)attachuuid
{
    __block LLDaoModelDiaryAttachsCellAttachimageCell* result = nil;
    LLDaoModelDiary *lLDaoModelDiary = [[LLDaoModelDiary alloc] init];
    [[LLDAOBase shardLLDAOBase] searchWhere:lLDaoModelDiary
                                     String:[NSString stringWithFormat:@"diaryuuid = \'%@\'",diaryuuid]
                                    orderBy:nil
                                     offset:0
                                      count:1
                                   callback:^(NSArray *resultArray)
     {
         for (LLDaoModelDiary* cell in resultArray) {
             for (LLDaoModelDiaryAttachsCell* attachsCell in cell.attachs) {
                 if ([attachsCell.attachuuid isEqualToString:attachuuid]) {
                     if ([attachsCell.attachtype isEqualToString:@"3"]) {
                         if( [attachsCell.attachimage count] > 0)
                         {
                             result = [attachsCell.attachimage objectAtIndex:0];
                         }
                     }
                 }
             }
         }
     }];
    return result;
}

-(NSString*)lastAttachUUid
{
    NSString* result = @"";
    int max = 0;
    for (LLDaoModelDiaryAttachsCell* attachsCell in _attachs) {
        int number = [[Tools SuffixNumberOfIdentifierString:attachsCell.attachuuid] intValue];
        if(number>max)
        {
            max = number;
            result = attachsCell.attachuuid;
        }
    }
    return result;
}

+(void)setUploadStatus:(NSString*)diaryuuid :(NSString*)upLoadStatus
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:upLoadStatus,@"upload_status", nil];
    NSDictionary* dicWhere = [NSDictionary dictionaryWithObjectsAndKeys:diaryuuid,@"diaryuuid", nil];
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelDiary class] dic:dic dic:dicWhere callback:nil];
}

+(void)setDiaryStatus:(NSString*)diaryuuid :(NSString*)diaryStatus
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:diaryStatus,@"diary_status", nil];
    NSDictionary* dicWhere = [NSDictionary dictionaryWithObjectsAndKeys:diaryuuid,@"diaryuuid", nil];
    [[LLDAOBase shardLLDAOBase] updateToDB:[LLDaoModelDiary class] dic:dic dic:dicWhere callback:nil];
}

+(void)deleteAttachsFiles:(NSString*)diaryuuid
{
    LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromUuid:diaryuuid];
    if(diary)
    {
        for (LLDaoModelDiaryAttachsCell* cell in diary.attachs) {
            //视频
            if([cell.attachtype isEqualToString:@"1"])
            {
                NSString* folder = [[LocalResourceModel VideosShootPath] stringByAppendingPathComponent:cell.attachuuid];
                [LocalResourceModel deleteLocalFile:folder];
            }
            //音频
            else if([cell.attachtype isEqualToString:@"2"])
            {
                NSString* folder = [[LocalResourceModel getSoundsRecordPath] stringByAppendingPathComponent:cell.attachuuid];
                [LocalResourceModel deleteLocalFile:folder];
            }
            //图片
            else if([cell.attachtype isEqualToString:@"3"])
            {
//                NSString* folder = [[LocalResourceModel getImageShootPath] stringByAppendingPathComponent:cell.attachuuid];
                [LocalResourceModel deleteLocalFile:cell.localfilePath];
            }
            cell.localfilePath = @"";
            cell.localSize = @"0";
            [LocalResourceModel deleteLocalFile:cell.downLoadFilePath];
            cell.downLoadFilePath = @"";
            cell.downLoadSize = @"0";
            diary.downTaskId = -1;
        }
    }
    [[LLDAOBase shardLLDAOBase] updateToDB:diary callback:nil];
}

-(NSString*)mainAttachType
{
    NSString* result = @"";
    for (LLDaoModelDiaryAttachsCell* cell in _attachs) {
//        if (STR_IS_NIL(result)) {
//            result = cell.attachtype;
//        }
        if ([cell.attachlevel isEqualToString:@"1"]) {
            result = cell.attachtype;
            break;
        }
    }
    if (STR_IS_NIL(result)) {
        result = @"0";
    }
    return result;
}

//附件类型，1视频、2音频、3图片、4文字 0无主附件
-(NSString*)mainAttachTypeDesc
{
    NSString* result = @"";
    for (LLDaoModelDiaryAttachsCell* cell in _attachs) {
        if ([cell.attachlevel isEqualToString:@"1"]) {
            result = cell.attachtype;
            break;
        }
    }
    if (STR_IS_NIL(result)) {
        result = @"0";
    }
    int resultInt = [result intValue];
    switch (resultInt)
    {
        case 0:
            result = @"attachNone";
            break;
        case 1:
            result = @"video";
            break;
        case 2:
            result = @"sound";
            break;
        case 3:
            result = @"image";
            break;
            
        default:
            break;
    }
    return result;
}

-(NSString*)mainAttachCreateType
{
    NSString* result = @"";
    for (LLDaoModelDiaryAttachsCell* cell in _attachs) {
        if (STR_IS_NIL(result)) {
            result = cell.createType;
        }
        if ([cell.attachlevel isEqualToString:@"1"]) {
            result = cell.createType;
            break;
        }
    }
    return result;
}

+(void)mergeAttachs:(NSArray*)netAttachs :(NSArray*)localAttachs isSynchronized:(BOOL)isSynchronized
{
    NSMutableArray* exsitAttachIDs = [[NSMutableArray alloc]initWithCapacity:10];
    
    for (LLDaoModelDiaryAttachsCell *netAttachsCell in netAttachs)
    {
        for (LLDaoModelDiaryAttachsCell *localAttachsCell in localAttachs)
        {
            if ([netAttachsCell.attachuuid isEqualToString:localAttachsCell.attachuuid])
            {
                [exsitAttachIDs addObject:netAttachsCell.attachuuid];
                netAttachsCell.localfilePath = localAttachsCell.localfilePath;
                netAttachsCell.localSize = localAttachsCell.localSize;
                netAttachsCell.downLoadFilePath = localAttachsCell.downLoadFilePath;
                netAttachsCell.downLoadSize = localAttachsCell.downLoadSize;
                netAttachsCell.video_type = localAttachsCell.video_type;
                netAttachsCell.photo_type = localAttachsCell.photo_type;
                netAttachsCell.audio_type = localAttachsCell.audio_type;
                //附件类型，1视频、2音频、3图片、4文字
                if ([netAttachsCell.attachtype isEqualToString:@"1"])
                {
                    if (netAttachsCell.attachvideo.count > 0 && localAttachsCell.attachvideo.count > 0) {
                        LLDaoModelDiaryAttachsCellVideopathCell *netVideoAttachsCell = [netAttachsCell.attachvideo objectAtIndex:0];
                        LLDaoModelDiaryAttachsCellVideopathCell *localVideoAttachsCell = [localAttachsCell.attachvideo objectAtIndex:0];
                        if (isSynchronized && ![netVideoAttachsCell.playvideourl isEqualToString:localVideoAttachsCell.playvideourl])
                        {
                            // 删除本地文件修改size
                            netAttachsCell.downLoadFilePath = @"";
                            [LocalResourceModel deleteLocalFile:localAttachsCell.downLoadFilePath];
                            netAttachsCell.downLoadSize = @"0";
                        }
                    }
                    
                }
                else if([netAttachsCell.attachtype isEqualToString:@"2"])
                {
                    if (netAttachsCell.attachaudio.count > 0 && localAttachsCell.attachaudio.count > 0) {
                        LLDaoModelDiaryAttachsCellAttachaudioCell *netAudioAttachsCell = [netAttachsCell.attachaudio objectAtIndex:0];
                        LLDaoModelDiaryAttachsCellAttachaudioCell *localAudioAttachsCell = [localAttachsCell.attachaudio objectAtIndex:0];
                        if (isSynchronized &&![netAudioAttachsCell.audiourl isEqualToString:localAudioAttachsCell.audiourl])
                        {
                            // 删除本地文件修改size
                            netAttachsCell.downLoadFilePath = @"";
                            [LocalResourceModel deleteLocalFile:localAttachsCell.downLoadFilePath];
                            netAttachsCell.downLoadSize = @"0";
                        }
                    }
                }
                else if([netAttachsCell.attachtype isEqualToString:@"3"])
                {
                    if (netAttachsCell.attachimage.count > 0 && localAttachsCell.attachimage.count > 0) {
                        LLDaoModelDiaryAttachsCellAttachimageCell *netImageAttachsCell = [netAttachsCell.attachimage objectAtIndex:0];
                        LLDaoModelDiaryAttachsCellAttachimageCell *localImageAttachsCell = [localAttachsCell.attachimage objectAtIndex:0];
                        if (isSynchronized && ![netImageAttachsCell.imageurl isEqualToString:localImageAttachsCell.imageurl])
                        {
                            // 删除本地文件修改size
                            netAttachsCell.downLoadFilePath = @"";
                            [LocalResourceModel deleteLocalFile:localAttachsCell.downLoadFilePath];
                            netAttachsCell.downLoadSize = @"0";
                        }
                    }
                }
            }
        }
    }
    
    
    
    for (LLDaoModelDiaryAttachsCell *localAttachsCell in localAttachs)
    {
        if (![exsitAttachIDs containsObject:localAttachsCell.attachuuid])
        {
            NSString *localPathDel = localAttachsCell.localfilePath;
            NSString *downLoadPathDel = localAttachsCell.downLoadFilePath;
            
            [LocalResourceModel deleteLocalFile:localPathDel];
            [LocalResourceModel deleteLocalFile:downLoadPathDel];
            
            
        }
        
    }
}

/**
 * 功能：删除本地日记任务
 * 参数：(NSString *)diaryuuid
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-06
 */
+ (void) deleteLocalDiaryTask:(NSString *)diaryuuid block:(void(^)(BOOL result))block
{
    LLDaoModelDiary *llDaoModelDiary = [[LLDaoModelDiary alloc] init];
    LLDAOBase *llDaoBase = [LLDAOBase shardLLDAOBase];
    
    __block LLDaoModelDiary *llDaoModelDiaryBlockResul = nil;
    
    NSMutableDictionary *whereDic = [NSMutableDictionary dictionary];
    [whereDic setObject:diaryuuid forKey:@"diaryuuid"];
    
    [llDaoBase searchAll:llDaoModelDiary
                     dic:whereDic
                callback:^(NSArray *resultArray)
     {
         if (resultArray.count > 0)
         {
             llDaoModelDiaryBlockResul = [resultArray objectAtIndex:0];
         }
     }
     ];
    
    // 删除任务
    if (llDaoModelDiaryBlockResul)
    {
        int uploadTask_taskID = llDaoModelDiaryBlockResul.uploadTask_taskID;             // 上传任务id
        int publishtaskid     = llDaoModelDiaryBlockResul.publishtaskid;             // 发布任务id
        int sharetaskid       = llDaoModelDiaryBlockResul.sharetaskid;             // 分享任务的id
        int favoriteTaskId    = llDaoModelDiaryBlockResul.favoriteTaskId;             // 收藏任务的id
        int downTaskId        = llDaoModelDiaryBlockResul.downTaskId;             // 下载任务的id
        
        int safeboxTaskId     = llDaoModelDiaryBlockResul.safeboxTaskId;           //保险箱任务id
        
        if (uploadTask_taskID > IS_HAVE_TASK_CONDITION)
        {
            [[LLTaskManager sharedLLTaskManager] setTaskNeedDelete:uploadTask_taskID];
        }
        if (publishtaskid     > IS_HAVE_TASK_CONDITION)
        {
            [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskNeedDelete:publishtaskid];
        }
        if (sharetaskid       > IS_HAVE_TASK_CONDITION)
        {
            [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskNeedDelete:sharetaskid];
        }
        if (favoriteTaskId    > IS_HAVE_TASK_CONDITION)
        {
            [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskNeedDelete:favoriteTaskId];
        }
        if (downTaskId        > IS_HAVE_TASK_CONDITION)
        {
            [[LLTaskManager sharedLLTaskManager] setTaskNeedDelete:downTaskId];
        }
        if (safeboxTaskId     > IS_HAVE_TASK_CONDITION) {
            [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskNeedDelete:safeboxTaskId];
        }
        
        llDaoModelDiaryBlockResul.uploadTask_taskID = -1;             // 上传任务id
        llDaoModelDiaryBlockResul.publishtaskid     = -1;             // 发布任务id
        llDaoModelDiaryBlockResul.sharetaskid       = -1;             // 分享任务的id
        llDaoModelDiaryBlockResul.favoriteTaskId    = -1;             // 收藏任务的id
        llDaoModelDiaryBlockResul.downTaskId        = -1;             // 下载任务的id
        llDaoModelDiaryBlockResul.safeboxTaskId     = -1;             // 保险箱任务id
        
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:llDaoModelDiaryBlockResul callback:^(BOOL result)
         {
             block(result);
         }];
    }
    else
    {
        block(YES);
    }
    
}

/**
 * 功能：删除本地日记
 * 参数：(NSString *)diaryId
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-06
 */
+ (void) deleteLocalDiary:(NSString *)diaryuuid block:(void(^)(BOOL result))block
{
    LLDaoModelDiary *llDaoModelDiary = [[LLDaoModelDiary alloc] init];
    LLDAOBase *llDaoBase = [LLDAOBase shardLLDAOBase];
    
    __block LLDaoModelDiary *llDaoModelDiaryBlockResul = nil;
    
    NSMutableDictionary *whereDic = [NSMutableDictionary dictionary];
    [whereDic setObject:diaryuuid forKey:@"diaryuuid"];
    
    [llDaoBase searchAll:llDaoModelDiary
                     dic:whereDic
                callback:^(NSArray *resultArray)
     {
         if (resultArray.count > 0)
         {
             llDaoModelDiaryBlockResul = [resultArray objectAtIndex:0];
         }
     }
     ];
    
    // 删除任务
    if (llDaoModelDiaryBlockResul)
    {
        int uploadTask_taskID = llDaoModelDiaryBlockResul.uploadTask_taskID;             // 上传任务id
        int publishtaskid     = llDaoModelDiaryBlockResul.publishtaskid;             // 发布任务id
        int sharetaskid       = llDaoModelDiaryBlockResul.sharetaskid;             // 分享任务的id
        int favoriteTaskId    = llDaoModelDiaryBlockResul.favoriteTaskId;             // 收藏任务的id
        int downTaskId        = llDaoModelDiaryBlockResul.downTaskId;             // 下载任务的id
        
        int safeboxTaskId     = llDaoModelDiaryBlockResul.safeboxTaskId;           //保险箱任务id
        
        if (uploadTask_taskID > IS_HAVE_TASK_CONDITION)
        {
            [[LLTaskManager sharedLLTaskManager] setTaskNeedDelete:uploadTask_taskID];
        }
        if (publishtaskid     > IS_HAVE_TASK_CONDITION)
        {
            [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskNeedDelete:publishtaskid];
        }
        if (sharetaskid       > IS_HAVE_TASK_CONDITION)
        {
            [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskNeedDelete:sharetaskid];
        }
        if (favoriteTaskId    > IS_HAVE_TASK_CONDITION)
        {
            [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskNeedDelete:favoriteTaskId];
        }
        if (downTaskId        > IS_HAVE_TASK_CONDITION)
        {
            [[LLTaskManager sharedLLTaskManager] setTaskNeedDelete:downTaskId];
        }
        if (safeboxTaskId     > IS_HAVE_TASK_CONDITION) {
            [[LLFreeTaskManager sharedLLFreeTaskManager] setTaskNeedDelete:safeboxTaskId];
        }
    }
    
    // 删除附件
    [LLDaoModelDiary deleteAttachsFiles:diaryuuid];
    
    // 删除本地数据库中纪录
    [llDaoBase deleteToDBWithWhereDic:llDaoModelDiary
                                where:whereDic
                             callback:^(BOOL result)
     {
         if (result) {
             [LLDaoModelDiary deleteAttachsFiles:diaryuuid];
         }
         if (block) {
             block(result);
         }
     }
     ];
}

-(void)removeDumplicate:(NSString*)diaryuuid
{
    if (_duplicate && _duplicate.count > 0 && !STR_IS_NIL(diaryuuid)) {
        for (int i = 0; i<_duplicate.count; i++) {
            LLDaoModelDiaryDuplicateCell* cell = [_duplicate objectAtIndex:i];
            if (!STR_IS_NIL(cell.diaryuuid) && [cell.diaryuuid isEqualToString:diaryuuid]) {
                [_duplicate removeObjectAtIndex:i];
                break;
            }
        }
    }
}

-(NSString*)firstDumplicateDiaryuuid
{
    NSString* result = @"";
    if (_duplicate && _duplicate.count > 0) {
        for (int i = 0; i<_duplicate.count; i++) {
            LLDaoModelDiaryDuplicateCell* cell = [_duplicate objectAtIndex:i];
            if (!STR_IS_NIL(cell.diaryuuid)) {
                result = cell.diaryuuid;
                break;
            }
        }
    }
    return result;
}


-(void)uploadVideoCover
{
    for (LLDaoModelDiaryAttachsCell* cell in _attachs) {
        if ([cell.attachtype isEqualToString:@"1"] && !STR_IS_NIL(cell.attachid)) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:cell.videocover]) {
                UIImage *image = [UIImage imageWithContentsOfFile:cell.videocover];
                CGSize imageSize;
                imageSize.width = 320;
                imageSize.height = 320;
                //UIImage *scaledImage = [Tools imageByScalingAndCroppingForSize:image withTargetSize:imageSize];
                
                UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(320, 0 ) interpolationQuality:kCGInterpolationDefault];
                
                NSData *imageData = UIImageJPEGRepresentation(scaledImage, 1.0);
                NSDictionary *waterjsonData = [[NSDictionary alloc]initWithObjectsAndKeys:APP_USERID,@"userid",@"2",@"upload_pic_type",cell.attachid,@"attachid",nil];
                RequestModel *requestModel = [[RequestModel alloc] initWithUrl:FRONTCOVER_URL params:waterjsonData];
                [HttpRequest doPicPostRequest:requestModel setPic:imageData setPicName:@"headimage.png" setKey:@"photo" mainBlock:^(NSDictionary* response)
                 {
                 }] ;
            }
        }
    }
}


//日记页删除主日记并且同时删除对应的副本
+(void)deleteDiaryAndDumplicateWithTask:(NSString *)diaryuuids
{
    NSMutableArray* uuidarray = [[NSMutableArray alloc] initWithArray:[diaryuuids componentsSeparatedByString:@","]];
    NSMutableArray *duplicateArray = [[NSMutableArray alloc] init];
    for (NSString *diaryuuid in uuidarray) {
        LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromUuid:diaryuuid];
        if (diary.duplicate && diary.duplicate.count > 0) {
            for (LLDaoModelDiaryDuplicateCell *duplicateCell in diary.duplicate) {
                [duplicateArray addObject:duplicateCell.diaryuuid];
            }
        }
    }
    [uuidarray addObjectsFromArray:duplicateArray];
    
    __block NSString* diaryids = @"";
    if (uuidarray && uuidarray.count > 0) {
        [[LLDAOBase shardLLDAOBase] searchAllWithArray:[[LLDaoModelDiary alloc]init] withColumnName:@"diaryuuid" where:uuidarray callback:^(NSArray *resultArray)
         {
             for (LLDaoModelDiary* cell in resultArray) {
                 if (!STR_IS_NIL(diaryids)) {
                     diaryids = [diaryids stringByAppendingFormat:@"%@",@","];
                 }
                 
                 if (!STR_IS_NIL(cell.diaryid)) {
                     [LLDaoModelDiary deleteLocalDiaryTask:cell.diaryuuid block:^(BOOL result) { }];
                     //网络的记录id数组
                     diaryids = [diaryids stringByAppendingFormat:@"%@",cell.diaryid];
                 }
                 else
                 {
                     //本地的直接删除
                     [LLDaoModelDiary deleteLocalDiary :cell.diaryuuid block:nil];
                 }
             }
         }];
    }
    
    //任务形势删除网络id数组
    LLDeleteDiaryTaskInfo* lLDeleteDiaryTaskInfo = [[LLDeleteDiaryTaskInfo alloc] init];
    lLDeleteDiaryTaskInfo.diaryids = diaryids;
    lLDeleteDiaryTaskInfo.newmainDiaryuuids = @"";
    [[LLFreeTaskManager sharedLLFreeTaskManager] addTask:[LLDeleteDiaryTask class ]:[lLDeleteDiaryTaskInfo outPutJson]];
    NSArray* idarray = [diaryids componentsSeparatedByString:@","];
    for (int i =0 ; i<idarray.count; i++) {
        NSString* diaryid = [idarray objectAtIndex:i];
        LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromId:diaryid
                                  ];
        diary.is_delete = @"1";
        diary.updatetimemilli = [GetMessageModel getSystemCurrentTime];
        [[LLDAOBase shardLLDAOBase] updateToDB:diary callback:nil];
    }
}



+(void)deleteDiaryWithTask:(NSString *)diaryuuids
{
    NSArray* uuidarray = [diaryuuids componentsSeparatedByString:@","];
    __block NSString* diaryids = @"";
    __block NSString* newMainDiaryuuids = @"";
    if (uuidarray && uuidarray.count > 0) {
        [[LLDAOBase shardLLDAOBase] searchAllWithArray:[[LLDaoModelDiary alloc]init] withColumnName:@"diaryuuid" where:uuidarray callback:^(NSArray *resultArray)
         {
             for (LLDaoModelDiary* cell in resultArray) {
                 if (!STR_IS_NIL(diaryids)) {
                     diaryids = [diaryids stringByAppendingFormat:@"%@",@","];
                 }
                 if (!STR_IS_NIL(newMainDiaryuuids)) {
                     newMainDiaryuuids = [newMainDiaryuuids stringByAppendingFormat:@"%@",@","];
                 }
                 
                 NSString* newMainDiaryuuid = [cell firstDumplicateDiaryuuid];
                 if (!STR_IS_NIL(newMainDiaryuuid)) {
                     [cell upDumplicateToMainDiary:newMainDiaryuuid];
                     newMainDiaryuuids = [newMainDiaryuuids stringByAppendingFormat:@"%@",newMainDiaryuuid];
                 }
                 
                 if (!STR_IS_NIL(cell.diaryid)) {
                     [LLDaoModelDiary deleteLocalDiaryTask:cell.diaryuuid block:^(BOOL result) { }];
                     //网络的记录id数组
                     diaryids = [diaryids stringByAppendingFormat:@"%@",cell.diaryid];
                 }
                 else
                 {
                     //本地的直接删除
                     [LLDaoModelDiary deleteLocalDiary :cell.diaryuuid block:nil];
                 }
             }
         }];
    }
    
    //任务形势删除网络id数组
    LLDeleteDiaryTaskInfo* lLDeleteDiaryTaskInfo = [[LLDeleteDiaryTaskInfo alloc] init];
    lLDeleteDiaryTaskInfo.diaryids = diaryids;
    lLDeleteDiaryTaskInfo.newmainDiaryuuids = newMainDiaryuuids;
    [[LLFreeTaskManager sharedLLFreeTaskManager] addTask:[LLDeleteDiaryTask class ]:[lLDeleteDiaryTaskInfo outPutJson]];
    NSArray* idarray = [diaryids componentsSeparatedByString:@","];
    for (int i =0 ; i<idarray.count; i++) {
        NSString* diaryid = [idarray objectAtIndex:i];
        LLDaoModelDiary* diary = [LLDaoModelDiary diaryFromId:diaryid
                                  ];
        diary.is_delete = @"1";
        diary.updatetimemilli = [GetMessageModel getSystemCurrentTime];
        [[LLDAOBase shardLLDAOBase] updateToDB:diary callback:nil];
    }
}

//副本从主日记中脱离，成为新日记
-(void)unlinkFromMainDiary
{
    if (!STR_IS_NIL(_resourceuuid))
    {
        //从上往下清理关系
        LLDaoModelDiary* resourceDiary = [LLDaoModelDiary diaryFromUuid:_resourceuuid];
        [resourceDiary removeDumplicate:_diaryuuid];
        
        //从下往上清理关系
        self.resourcediaryid = @"";
        self.resourceuuid = @"";
        
        if (resourceDiary) {
            [[LLDAOBase shardLLDAOBase] updateInsertToDB:resourceDiary callback:nil];
        }
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:self callback:nil];
    }
}

//把指定的副本日记提为主日记，本日记脱离关系
-(void)upDumplicateToMainDiary:(NSString*)dumplicateDiaryuuid
{
    LLDaoModelDiary *newMainllDaoModelDiary = [LLDaoModelDiary diaryFromUuid:dumplicateDiaryuuid];
    if (newMainllDaoModelDiary) {
        //把原日记中的副本移出
        [self removeDumplicate:dumplicateDiaryuuid];
        //原副本日记提为主日记
        newMainllDaoModelDiary.duplicate = _duplicate;
        newMainllDaoModelDiary.resourcediaryid = @"";
        newMainllDaoModelDiary.resourceuuid = @"";
        [[LLDAOBase shardLLDAOBase] updateInsertToDB:newMainllDaoModelDiary callback:nil];
    }
    //原日记所有副本移出
    [_duplicate removeAllObjects];
    [[LLDAOBase shardLLDAOBase] updateInsertToDB:self callback:nil];
}
@end
