//
//  LLOldVersionLocalVideoTransport.m
//  VideoShare
//
//  Created by zengchao on 13-8-9.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "LLOldVersionLocalVideoTransport.h"
#import "LLDefines.h"
#import "LLDaoBase.h"
#import "LLDaoModelDiary.h"
#import "LocalResourceModel.h"
#import "Tools.h"
#import "LLDaoModelUser.h"
#import "LLOldBindModel.h"
#import "LLUploadTask.h"
#import "LLTaskManager.h"
#import "JSONKit.h"


@interface UAModel()
@property(nonatomic,strong) NSString* userid;
@property (nonatomic,retain) NSString* portraitUrl;
@property (nonatomic,retain) NSString* nickname;
@property (nonatomic,retain) NSString* sex;
@property (nonatomic,retain) NSString* address;
@property (nonatomic,retain) NSString* birthday;
@property (nonatomic,retain) NSString* signature;
@property (nonatomic,retain) NSString* snsid;
@property (nonatomic,retain) NSString* snstype; //第三方的类型(“snstype”:”1”  “1”景象、”2”新浪微博、”3”腾讯微博)
@property (nonatomic,retain) NSString* equipmentid;


@end

@implementation UAModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.userid=[aDecoder decodeObjectForKey:@"userid"];
        self.portraitUrl=[aDecoder decodeObjectForKey:@"portraiturl"];
        self.nickname=[aDecoder decodeObjectForKey:@"nickname"];
        self.sex=[aDecoder decodeObjectForKey:@"sex"];
        self.address=[aDecoder decodeObjectForKey:@"address"];
        self.birthday=[aDecoder decodeObjectForKey:@"birthday"];
        self.signature=[aDecoder decodeObjectForKey:@"tag"];
        self.snsid=[aDecoder decodeObjectForKey:@"snsid"];
        self.snstype=[aDecoder decodeObjectForKey:@"snstype"];
        self.equipmentid = [aDecoder decodeObjectForKey:@"equipmentid"];
        self.snstype = [aDecoder decodeObjectForKey:@"snstype"];
    }
    return self;
}


@end

@implementation ListMyDiaryIdResponseData
-(void)setResponseModelFromDic:(NSDictionary*)dataDictionary
{
    [super setResponseModelFromDic:dataDictionary];
    [self safeSetValuesForKeysWithDictionary:dataDictionary];
}

@end


@interface LLOldVersionLocalVideoTransport()
@property(nonatomic,strong) NSArray* diaryidArray;
@property(nonatomic,strong) NSString* videoPath;
@property(nonatomic,strong) NSString* frontcoverPath;
@end


@implementation LLOldVersionLocalVideoTransport


static id instance;
+(LLOldVersionLocalVideoTransport *)sharedInstance
{
    @synchronized(instance)
    {
        if (!instance)
        {
            instance=[[self alloc]init];
        }
    }
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        self.diaryidArray = nil;
        self.allDiaryDownloaded = NO;
        self.videoPath=[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
        self.frontcoverPath=[[SandboxFile GetDocumentPath] stringByAppendingPathComponent:@"frontcover"];
    }
    return self;
}

-(BOOL)isFinishStep1
{
    BOOL result = NO;
    NSString* value = [[NSUserDefaults standardUserDefaults] objectForKey:@"OldVersionDataTransport2_2To3_0Step1"];
    if ([UN_NIL(value) isEqualToString:@"1"]) {
        result = YES;
    }
    return result;
}

-(void)finishStep1
{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"OldVersionDataTransport2_2To3_0Step1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isFinishStep2
{
    BOOL result = NO;
    NSString* value = [[NSUserDefaults standardUserDefaults] objectForKey:@"OldVersionDataTransport2_2To3_0Step2"];
    if ([UN_NIL(value) isEqualToString:@"1"]) {
        result = YES;
    }
    return result;
}

-(void)finishStep2
{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"OldVersionDataTransport2_2To3_0Step2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isFinishStep3
{
    BOOL result = NO;
    NSString* value = [[NSUserDefaults standardUserDefaults] objectForKey:@"OldVersionDataTransport2_2To3_0Step3"];
    if ([UN_NIL(value) isEqualToString:@"1"]) {
        result = YES;
    }
    return result;
}

-(void)finishStep3
{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"OldVersionDataTransport2_2To3_0Step3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isFinishStep4
{
    BOOL result = NO;
    NSString* value = [[NSUserDefaults standardUserDefaults] objectForKey:@"OldVersionDataTransport2_2To3_0Step4"];
    if ([UN_NIL(value) isEqualToString:@"1"]) {
        result = YES;
    }
    return result;
}

-(void)finishStep4
{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"OldVersionDataTransport2_2To3_0Step4"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)doTransportStep1
{
    if ([self isFinishStep1] == NO) {
        @try {
            [self readOldUserInfo];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [self finishStep1];
        }
    }
}

-(void)doTransportStep2
{
    if ([self isFinishStep1]==YES && [self isFinishStep2] == NO) {
        @try {
            [self moveFileAndCreateDiary];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [self finishStep2];
        }
    }
}

-(void)doTransportStep3
{
    if ([self isFinishStep1]==YES && [self isFinishStep2]==YES && [self isFinishStep3] == NO) {
        @try {
            [self upDateOldDiaryWithUserInfo];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [self finishStep3];
        }
    }
}

-(void)doTransportStep4
{
    if ([self isFinishStep1]==YES &&[self isFinishStep2]==YES &&[self isFinishStep3] == YES && [self isFinishStep4] == NO) {
        @try {
            [self checkMissAndCreateUploadTask:^(BOOL result)
             {
                 if (result == YES) {
                     [self finishStep4];
                 }
             }];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

-(void)readOldUserInfo
{
    NSString* file = [NSString stringWithFormat:@"%@/Documents/UAModel",NSHomeDirectory()];
    if ([[NSFileManager defaultManager] fileExistsAtPath: file]) {
        UAModel* uAModel=[NSKeyedUnarchiver unarchiveObjectWithFile: file ];
        
        LLDaoModelUser* user = [[LLDaoModelUser alloc]init];
        user.userid = uAModel.userid;                      // 用户id
        user.fingerPassword = @"";              // 保险箱密码
        user.firstPhone = @"";                  // 绑定look的手机号
        user.secondPhone= @"";                 // 绑定保险箱密码的手机号
        user.emailAddress = @"";                 // 绑定的email地址
        
        user.isSafeBoxOpen = @"n";               // 保险箱是否是打开的 y：打开 n：关闭
        user.safeBoxOpenRemainNum = @"5";//保险箱剩余输入次数
        
        user.isBindSina = @"0";   //是否绑定了新浪微博  0：未绑定  1：绑定打开  2：绑定关闭
        user.bindSinaAuthInfo = @"";  //新浪授权信息
        user.isBindTC = @"0";   //是否绑定了腾讯微博  0：未绑定  1：绑定打开  2：绑定关闭
        user.bindTCAuthInfo=@"";  //腾讯授权信息
        user.isBindRENREN = @"0";   //是否绑定了人人网  0：未绑定  1：绑定打开  2：绑定关闭
        user.bindRENRENAuthInfo = @"";  //人人网授权信息
        user.binddingEmail = @"";  //绑定的邮箱地址
        user.binddingEmailStatus = @"";  //绑定邮箱的激活状态
        user.binddingPhone = @"";  //绑定的手机号
        
        user.nickname = UN_NIL(uAModel.nickname);  //昵称
        if([@"1" isEqualToString:uAModel.snstype]){//2.2新浪
            user.logintype = @"1" ; //3.0新浪
        }else if([@"6" isEqualToString:uAModel.snstype]){//2.2腾讯
            user.logintype = @"6" ; //3.0腾讯
        }
        else
        {
            user.logintype = @"101";
        }
        
        user.headimageurl = UN_NIL(uAModel.portraitUrl); //头像地址
        user.sex = UN_NIL(uAModel.sex); //性别
        user.address = UN_NIL(uAModel.address);  //地址
        user.birthdate = UN_NIL(uAModel.birthday); //生日
        user.signature = UN_NIL(uAModel.signature); //签名
        user.app_downloadurl = @""; //looklook官方下载地址
        user.mood = @"1"; //心情
        
        user.privmsg_type= @"1";//谁可以给我发私信，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
        user.friends_type= @"1"; //谁可以看我的朋友关系，1全部人可见（黑名单人除外）2关注人可见  4仅自己可见
        user.diary_type= @"2"; //谁可以看我内容（日记和评论），1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
        user.position_type= @"2"; //谁可以看我的位置，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
        user.audio_type= @"2"; //谁可以听我的语音，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见
        user.audio_encrypt_type= @""; //加密类型， audio_type=2或4，有效
        user.launch_type= @"1"; //启动1观看模式 2摄影模式
        user.sysc_type= @"2";//"1"  //数据同步， 2仅WIFI 3任何网络
        
        user.coverimageurl = @"";//用户空间封面
        
        user.officialUsersJsonStr =@""; // 官方用户列表Json串
        user.taskListAlive = 1; //1全部开始，0全部暂停
        
        
        
        LocalResourceModel* tmpFileModel = [[LocalResourceModel alloc]init];
        [tmpFileModel initWithUserID:user.userid];
        
        if(tmpFileModel.llDataBaseFile.length > 0){
            LLDAOBase* dao =[[LLDAOBase alloc]init];
            [dao create:tmpFileModel.llDataBaseFile];
            [dao updateInsertToDB:user callback:nil];
            LLOldBindModel* lLOldBindModel = [[LLOldBindModel alloc]init];
            [lLOldBindModel refreshFromLocalRecord:dao SnsType:uAModel.snstype];
        }
        
        if (!STR_IS_NIL(user.userid)) {
            APP_USERID = user.userid;
            APP_EQUIPMENTID = uAModel.equipmentid;
            [[NSUserDefaults standardUserDefaults] setValue:APP_USERID forKey:@"loginguserid"]; //当前登录的用户id
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

}


-(void)moveFileAndCreateDiary
{
    NSMutableDictionary* uploadDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"uploadDic"]];
    
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_videoPath error:NULL];
    
    for (NSString *aPath in contentOfFolder) {
        NSString * folderPath = [_videoPath stringByAppendingPathComponent:aPath];
        
        NSString* sourceid = [folderPath lastPathComponent];
        
        NSString* fullpath = [self checkOldVersionValidFolder :sourceid];
        
        if (!STR_IS_NIL(fullpath)) {
            NSDictionary* dic = [uploadDic valueForKey:sourceid];
            
            if (dic) {
                NSString* diaryid = [dic valueForKey:@"videoid"];
                NSString* userid = [dic valueForKey:@"userid"];
                int over = [[dic valueForKey:@"over"] intValue];
                if (!STR_IS_NIL(sourceid) && !STR_IS_NIL(userid))
                {
                    LocalResourceModel* tmpFileModel = [[LocalResourceModel alloc]init];
                    [tmpFileModel initWithUserID:userid];
                    if (!STR_IS_NIL(diaryid) && over == 1) {
                        //视频文件移动到3.0目录
                        NSString* destPath = [[[tmpFileModel.videosShootPath stringByAppendingPathComponent:diaryid] stringByAppendingPathComponent:diaryid] stringByAppendingPathExtension:@"mp4"];
                        
                        [SandboxFile CreateList:tmpFileModel.videosShootPath ListName:diaryid];
                        
                        [[NSFileManager defaultManager]moveItemAtPath:fullpath toPath:destPath error:nil];
                        [[NSFileManager defaultManager] removeItemAtPath:[fullpath stringByDeletingLastPathComponent] error:nil];
                        
                        //封面移动到3.0目录
                        NSString* frontCoverFullPath = [[_frontcoverPath stringByAppendingPathComponent:sourceid] stringByAppendingPathExtension:@"png"];
                        NSString* destFrontCoverFullPath = [[tmpFileModel.frontCoverPath stringByAppendingPathComponent:diaryid] stringByAppendingPathExtension:@"png"];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:frontCoverFullPath]) {
                            [[NSFileManager defaultManager]moveItemAtPath:frontCoverFullPath toPath:destFrontCoverFullPath error:nil];
                        }
                        else
                        {
                            //没封面，生成一个
                            UIImage* image = [Tools thumbnailImageForVideoSyn:destPath atPersent:1];
                            if(image)
                            {
                                [Tools saveImage:image :destFrontCoverFullPath];
                            }
                            else
                            {
                                destFrontCoverFullPath = @"";
                            }
                        }
                        
                        //数据库插入记录
                        [self transportToNewVersion :destPath:destFrontCoverFullPath:diaryid:userid:1];
                        
                    }
                    else
                    {
                        //视频文件移动到3.0目录
                        NSString* destPath = [[[tmpFileModel.videosShootPath stringByAppendingPathComponent:sourceid] stringByAppendingPathComponent:sourceid] stringByAppendingPathExtension:@"mp4"];
                        
                        [SandboxFile CreateList:tmpFileModel.videosShootPath ListName:sourceid];
                        
                        [[NSFileManager defaultManager]moveItemAtPath:fullpath toPath:destPath error:nil];
                        [[NSFileManager defaultManager] removeItemAtPath:[fullpath stringByDeletingLastPathComponent] error:nil];
                        
                        //封面移动到3.0目录
                        NSString* frontCoverFullPath = [[_frontcoverPath stringByAppendingPathComponent:sourceid] stringByAppendingPathExtension:@"png"];
                        NSString* destFrontCoverFullPath = [[tmpFileModel.frontCoverPath stringByAppendingPathComponent:sourceid] stringByAppendingPathExtension:@"png"];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:frontCoverFullPath]) {
                            [[NSFileManager defaultManager]moveItemAtPath:frontCoverFullPath toPath:destFrontCoverFullPath error:nil];
                        }
                        else
                        {
                            //没封面，生成一个
                            UIImage* image = [Tools thumbnailImageForVideoSyn:destPath atPersent:1];
                            if (image) {
                                [Tools saveImage:image :destFrontCoverFullPath];
                            }
                            else
                            {
                                destFrontCoverFullPath = @"";
                            }
                        }
                        
                        //数据库插入记录
                        [self transportToNewVersion :destPath:destFrontCoverFullPath:sourceid:userid:0];
                    }
                }
            }
            else
            {
                //丢失的视频，放入最后登录的用户里
                NSString* userid = APP_USERID;
                NSString* sourceid = [[fullpath lastPathComponent] stringByDeletingPathExtension];
                
                if (!STR_IS_NIL(userid) && !STR_IS_NIL(sourceid)) {
                    
                    LocalResourceModel* tmpFileModel = [[LocalResourceModel alloc]init];
                    [tmpFileModel initWithUserID:userid];
                    //视频文件移动到3.0目录
                    NSString* destPath = [[[tmpFileModel.videosShootPath stringByAppendingPathComponent:sourceid] stringByAppendingPathComponent:sourceid] stringByAppendingPathExtension:@"mp4"];
                    
                    [SandboxFile CreateList:tmpFileModel.videosShootPath ListName:sourceid];
                    
                    [[NSFileManager defaultManager]moveItemAtPath:fullpath toPath:destPath error:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:[fullpath stringByDeletingLastPathComponent] error:nil];
                    
                    //封面移动到3.0目录
                    NSString* frontCoverFullPath = [[_frontcoverPath stringByAppendingPathComponent:sourceid] stringByAppendingPathExtension:@"png"];
                    NSString* destFrontCoverFullPath = [[tmpFileModel.frontCoverPath stringByAppendingPathComponent:sourceid] stringByAppendingPathExtension:@"png"];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:frontCoverFullPath]) {
                        [[NSFileManager defaultManager]moveItemAtPath:frontCoverFullPath toPath:destFrontCoverFullPath error:nil];
                    }
                    else
                    {
                        //没封面，生成一个
                        UIImage* image = [Tools thumbnailImageForVideoSyn:destPath atPersent:1];
                        if (image) {
                            [Tools saveImage:image :destFrontCoverFullPath];
                        }
                        else
                        {
                            destFrontCoverFullPath = @"";
                        }
                    }
                    
                    //数据库插入记录
                    [self transportToNewVersion :destPath:destFrontCoverFullPath:sourceid:userid:0];
                }
            }
        }
        
        
        
        
    }

}



-(void)transportToNewVersion:(NSString*)fullpath:(NSString*)destFrontCoverFullPath:(NSString*)diaryid:(NSString*)userid:(int)over
{
    [self createVideoDiary :fullpath :destFrontCoverFullPath:diaryid:userid :over];
}

-(NSString*)checkOldVersionValidFolder:(NSString*)sourceid
{
    NSString* result = @"";
    NSString* tmp =[[[_videoPath stringByAppendingPathComponent:sourceid] stringByAppendingPathComponent:sourceid]stringByAppendingPathExtension:@"mp4"];
    if([[NSFileManager defaultManager] fileExistsAtPath:tmp])
    {
        result = tmp;
    }
    return result;
}

-(void)createVideoDiary:(NSString*)filename:(NSString*)destFrontCoverFullPath:(NSString*)diaryid:(NSString*)userid:(int)over
{
    //创建一个附件
    LLDaoModelDiaryAttachsCell* attachsCell = [self createAttachVideo :filename:destFrontCoverFullPath:over];
    
    //创建一条日记实粒
    LLDaoModelDiary* diary = [self createNewDiaryOfAttach:attachsCell:userid:over];

    //更新数据库
    [self updateDiary:diary];
}


-(LLDaoModelDiaryAttachsCell*)createAttachVideo:(NSString*)localFile:(NSString*)destFrontCoverFullPath:(int)over
{
    LLDaoModelDiaryAttachsCell* attachsCell = [[LLDaoModelDiaryAttachsCell alloc]init];
    [attachsCell createDefault];
    

    attachsCell.videocover = destFrontCoverFullPath;

    attachsCell.attachuuid = [[localFile stringByDeletingLastPathComponent] lastPathComponent]; 
    if (over == 1) {
        attachsCell.attachid = attachsCell.attachuuid;
    }
    attachsCell.attachtype = @"1";//附件类型，1视频、2音频、3图片、4文字
    attachsCell.createType = @"1";
    
    attachsCell.localSize = [NSString stringWithFormat:@"%lld",[Tools calculatefolderSizeAtPath:localFile]];
    [attachsCell setLocalPath:localFile];
    attachsCell.attachlevel = @"1";
    
    attachsCell.video_type = @"0";
    
    attachsCell.attach_latitude = @"";
    attachsCell.attach_logitude = @"";

    
    LLDaoModelDiaryAttachsCellVideopathCell* videopathCell = [[LLDaoModelDiaryAttachsCellVideopathCell alloc]init];
    [attachsCell.attachvideo addObject:videopathCell];
    return attachsCell;
}

-(LLDaoModelDiary*)createNewDiaryOfAttach:(LLDaoModelDiaryAttachsCell*)AttachsCell:(NSString*)userid:(int)over
{
    LLDaoModelDiary* lLDaoModelDiary = [[LLDaoModelDiary alloc]init];
    
    lLDaoModelDiary.diaryuuid = AttachsCell.attachuuid;
    if (over == 1) {
        lLDaoModelDiary.diaryid = lLDaoModelDiary.diaryuuid;
    }
    
    lLDaoModelDiary.userid = userid;
    lLDaoModelDiary.diary_status = @"-2";    // 未发布
    
    if (over == 0) {
        lLDaoModelDiary.upload_status = @"-4";    //未上传
        lLDaoModelDiary.synchronization_status = @"0";//未同步
    }
    else
    {
        lLDaoModelDiary.upload_status = @"-3";    //已上传
        lLDaoModelDiary.synchronization_status = @"1";//已同步
    }
    
    
    lLDaoModelDiary.latitude = @"";
    lLDaoModelDiary.longitude = @"";
    lLDaoModelDiary.position = @"";
    lLDaoModelDiary.offset = @"";
    lLDaoModelDiary.addresscode = @"";
    lLDaoModelDiary.position_source = @"";
    [lLDaoModelDiary.attachs removeAllObjects];
    [lLDaoModelDiary.attachs addObject:AttachsCell];
    lLDaoModelDiary.downTaskId = -1;
    
    
    lLDaoModelDiary.headimageurl = @"";
    lLDaoModelDiary.nickname = @"";
    lLDaoModelDiary.mood = @"1";
    lLDaoModelDiary.sex = @"2";  
    lLDaoModelDiary.position_status = @"1";
    lLDaoModelDiary.publish_status = @"1";
    
    lLDaoModelDiary.updatetimemilli = @"0";
    lLDaoModelDiary.diarytimemilli = [self getCreatetime:AttachsCell.localfilePath];
    
    return lLDaoModelDiary;
}

-(void)updateDiary:(LLDaoModelDiary*)lLDaoModelDiary
{
    if (lLDaoModelDiary) {
        LocalResourceModel* tmpFileModel = [[LocalResourceModel alloc]init];
        [tmpFileModel initWithUserID:lLDaoModelDiary.userid];
        if(tmpFileModel.llDataBaseFile.length > 0){
            LLDAOBase* dao =[[LLDAOBase alloc]init];
            [dao create:tmpFileModel.llDataBaseFile];
            lLDaoModelDiary.fromOldversion2_2 = @"1";
            [dao updateInsertToDB:lLDaoModelDiary callback:nil];
        }
    }
}

-(NSString*)getCreatetime:(NSString*)fileFullPath
{
    NSString* result = @"";
    NSDictionary * dicAttr=nil;
    NSDate *createDate=nil;
    dicAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:fileFullPath error:NULL];
    if(dicAttr)
    {
        createDate =[dicAttr fileCreationDate];
        if(createDate)
        {
            NSTimeInterval currentTimeSine1970 = [createDate timeIntervalSince1970];
            NSNumber *number = [NSNumber numberWithDouble:(long long)(currentTimeSine1970*1000)];
            result = [number stringValue];
        }
    }
    return result;
}

//用户信息写入日记
-(void)upDateOldDiaryWithUserInfo
{
    NSString* userid = APP_USERID;
    
    if (!STR_IS_NIL(userid)) {
        LocalResourceModel* tmpFileModel = [[LocalResourceModel alloc]init];
        [tmpFileModel initWithUserID:userid];
        
        if(tmpFileModel.llDataBaseFile.length > 0){
            LLDAOBase* dao =[[LLDAOBase alloc]init];
            [dao create:tmpFileModel.llDataBaseFile];
            
            
            NSString* sqlWhereStr = [NSString stringWithFormat:@"userid = \'%@\' AND fromOldversion2_2 = \'1\'", userid];
            
            [dao searchAll:[[LLDaoModelDiary alloc] init] where:sqlWhereStr callback:^(NSArray *resultArray)
             {
                 
                 for (int i = 0; i < resultArray.count; i++) {
                     LLDaoModelDiary* diary = [resultArray objectAtIndex:i];
                     
                     __block LLDaoModelUser *llDaoModelUser = nil;
                     
                     [dao searchWhere:[[LLDaoModelUser alloc] init]
                               String:[NSString stringWithFormat:@"userid = \'%@\'",userid]
                              orderBy:nil
                               offset:0
                                count:1
                             callback:^(NSArray *resultArray)
                      {
                          
                          if (resultArray.count > 0)
                          {
                              llDaoModelUser = [resultArray objectAtIndex:0];
                          }
                      }
                      ];
                     
                     if (llDaoModelUser)
                     {
                         diary.headimageurl = llDaoModelUser.headimageurl;
                         diary.nickname = llDaoModelUser.nickname;
                         diary.mood = llDaoModelUser.mood;
                         diary.sex = llDaoModelUser.sex;
                         
                         [dao updateInsertToDB:diary callback:nil];
                     }
                 }
                 
                 
             }];
            
        }
        
    }

}



//复查遗漏的
-(void)checkMissAndCreateUploadTask:(void (^)(BOOL))block
{
    NSString* userid = APP_USERID;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDic setValue:userid forKey:@"userid"];
    RequestModel *requestModel = [[RequestModel alloc] initWithUrl:LISTMYDIARYID_URL
                                                            params:paramDic
                                  ];
    [[RIAWebRequestLib riaWebRequestLib] fetchDataFromNet:requestModel
                                           dataModelClass:[ListMyDiaryIdResponseData class]
                                                mainBlock:^(BaseData *responseModel)
     {
         if (responseModel.responseStatusCode == RIA_RESPONSE_CODE_SUCCESS){
             NSString* diaryids = ((ListMyDiaryIdResponseData*)responseModel).diaryids;
             NSArray* array = [diaryids componentsSeparatedByString:@","];
             
             NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:10];
             
             for (int i = 0; i<array.count; i++) {
                 NSString* diaryid = [array objectAtIndex:i];
                 if(!STR_IS_NIL(diaryid))
                 {
                     diaryid = [diaryid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 }
                 if (!STR_IS_NIL(diaryid)) {
                     [newArray addObject:diaryid];
                 }
             }
             
             
             
             if (!STR_IS_NIL(userid)) {
                 LocalResourceModel* tmpFileModel = [[LocalResourceModel alloc]init];
                 [tmpFileModel initWithUserID:userid];
                 
                 if(tmpFileModel.llDataBaseFile.length > 0){
                     LLDAOBase* dao =[[LLDAOBase alloc]init];
                     [dao create:tmpFileModel.llDataBaseFile];
                     
                     
                     NSMutableArray* needUploadArray = [[NSMutableArray alloc]initWithCapacity:10];
                     
                     NSString* sqlWhereStr = [NSString stringWithFormat:@"userid = \'%@\' AND fromOldversion2_2 = \'1\'", userid];
                     
                     [dao searchAll:[[LLDaoModelDiary alloc] init] where:sqlWhereStr callback:^(NSArray *resultArray)
                     {
                         
                         for (int i = 0; i < resultArray.count; i++) {
                             LLDaoModelDiary* diary = [resultArray objectAtIndex:i];
                             
                             if (![newArray containsObject:diary.diaryid] ) {
                                 [needUploadArray addObject:diary];
                             }
                         }
                         
                         
                     }];
                     
                     for (int i = 0; i<needUploadArray.count; i++) {
                         LLDaoModelDiary* diary = [needUploadArray objectAtIndex:i];
                         diary.upload_status = @"-4";    //未上传
                         diary.synchronization_status = @"0";//未同步
                         [dao updateInsertToDB:diary callback:nil];
                         //添加上传任务
                         
                         
                         
                         
                             if ([[diary mainAttachCreateType] isEqualToString:@"1"]) {
                                 //创建上传任务实粒
                                 LLUploadTaskInfo* lLUploadTaskInfo = [self createTask :diary:5];
                                 if([[diary mainAttachType] isEqualToString:@"1"])
                                 {
                                     lLUploadTaskInfo.mainAttachType = @"video";
                                 }
                                 else if([[diary mainAttachType] isEqualToString:@"3"])
                                 {
                                     lLUploadTaskInfo.mainAttachType = @"image";
                                 }
                                 if (!STR_IS_NIL(lLUploadTaskInfo.mainAttachType)) {
                                     //关联任务id
                                     diary.uploadTask_taskID = [self addToTaskManager:lLUploadTaskInfo];
                                     //更新数据库
                                     [self updateDiary:diary];
                                     [self setTaskInfoImageForShowGot:diary];
                                 }
                             }
                         
                     }
                     
                     
                     
                     
                 }
             }
             block(YES);
         }
         else
         {
             block(NO);
         }
     }];
}


-(LLUploadTaskInfo*)createTask:(LLDaoModelDiary*)lLDaoModelDiary:(int)fileinterval
{
    LLUploadTaskInfo* lLUploadTaskInfo = [[LLUploadTaskInfo alloc]init];
    lLUploadTaskInfo.fileinterval = fileinterval;
    lLUploadTaskInfo.createStructureRequestData = [[CreateStructureRequestData alloc]init];
    [lLUploadTaskInfo.createStructureRequestData createFromModelDiary:lLDaoModelDiary];
    lLUploadTaskInfo.createStructureRequestData.operate_diarytype = @"1";//新建
    lLUploadTaskInfo.totalSize = [lLDaoModelDiary localSize];
    return lLUploadTaskInfo;
}

-(int)addToTaskManager:(LLUploadTaskInfo*)lLUploadTaskInfo
{
    return [[LLTaskManager sharedLLTaskManager] addTask:[LLUploadTask class]:[lLUploadTaskInfo outPutJson]];
}

-(void)setTaskInfoImageForShowGot:(LLDaoModelDiary*)diary
{
    if (diary) {
        NSString* taskInfo = [[LLTaskManager sharedLLTaskManager] taskInfo:diary.uploadTask_taskID];
        if (!STR_IS_NIL(taskInfo)) {
            LLUploadTaskInfo* lLUploadTaskInfo = [LLUploadTaskInfo customClassWithProperties:[taskInfo mutableObjectFromJSONString]];
            lLUploadTaskInfo.imageForShow = [diary imageForShow];
            [[LLTaskManager sharedLLTaskManager] setTaskInfo:diary.uploadTask_taskID :[lLUploadTaskInfo outPutJson]:@"imageForShowGot"];
        }
    }
}
@end
