//
//  LLDaoModelDiary.h
//  VideoShare
//
//  Created by zengchao on 13-5-27.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLDaoModelBase.h"


@interface LLDaoModelDiaryTagCell:NSObject
@property (nonatomic,strong) NSString* id;
@property (nonatomic,strong) NSString* name;
@end

@interface LLDaoModelDiarySnsCell:NSObject
@property (nonatomic,strong) NSString* snscontent;
@property (nonatomic,strong) NSString* sharetime;
@property (nonatomic,strong) NSMutableArray* shareinfo;
@end

@interface LLDaoModelDiarySnsCellShareinfoCell:NSObject
@property (nonatomic,strong) NSString* snstype;
@property (nonatomic,strong) NSString* snsid;
@property (nonatomic,strong) NSString* weiboid;
@end

//活动
@interface LLDaoModelDiaryActiveCell:NSObject
@property (nonatomic,strong) NSString* activeid;                //
@property (nonatomic,strong) NSString* activename;              //
@property (nonatomic,strong) NSString* starttime;               //
@property (nonatomic,strong) NSString* endtime;                 //
@property (nonatomic,strong) NSString* introduction;            //
@property (nonatomic,strong) NSString* add_way;                 //
@property (nonatomic,strong) NSString* rule;                    //
@property (nonatomic,strong) NSString* prize;                   //
@property (nonatomic,strong) NSString* picture;                 //
@property (nonatomic,strong) NSString* isjoin;                  //
@property (nonatomic,strong) NSString* iseffective;             //
@end

//附件
@interface LLDaoModelDiaryAttachsCell:NSObject
@property (nonatomic,strong) NSString* attachuuid;
@property (nonatomic,strong) NSString* createType;               // 附件形成类型,1正常,n分段
@property (nonatomic,strong) NSString* localfilePath;            // 本地生成
@property (nonatomic,strong) NSString* downLoadFilePath;         // 下载下来的附件路径
@property (nonatomic,strong) NSString* localSize;                // 本地size
@property (nonatomic,strong) NSString* downLoadSize;             // 下载文件的size
@property (nonatomic,strong) NSString* audio_type;//1原音2加密

@property (nonatomic,strong) NSString* attachid;
@property (nonatomic,strong) NSString* attachtype;              //附件类型，1视频、2音频、3图片、4文字
@property (nonatomic,strong) NSString* video_type;  //视频类别（0高清、1普清、） attach_type=1有效
@property (nonatomic,strong) NSString* photo_type;  //图片类别，1有标 0无标 attach_type=3有效
@property (nonatomic,strong) NSString* content;                 // 内容
@property (nonatomic,strong) NSString* videocover;              // 视频封面
@property (nonatomic,strong) NSString* is_encrypt;              // 原音可见范围，1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见，attachtype=2有效
@property (nonatomic,strong) NSString* attachlevel;//附件级别,区分是主文件还是辅助文件。1主内容、0辅内容
@property (nonatomic,strong) NSMutableArray* attachimage;
@property (nonatomic,strong) NSString* playtime;//音频为秒"9"，视频为冒号隔开"00:00:12"
@property (nonatomic,strong) NSMutableArray* attachaudio;
@property (nonatomic,strong) NSString* attachtimemilli;
@property (nonatomic,strong) NSString* playtimes;
@property (nonatomic,strong) NSMutableArray* attachvideo;
@property (nonatomic,strong) NSString* pic_width;
@property (nonatomic,strong) NSString* pic_height;
@property (nonatomic,strong) NSString* show_width;
@property (nonatomic,strong) NSString* show_height;

@property (nonatomic,strong) NSString* attach_logitude;          //经纬度,服务器缺少
@property (nonatomic,strong) NSString* attach_latitude;

//add by xudongsheng 辅助冗余字段，不参与数据库表结构，方便日记model转换成CreateStructureRequestAttachData方便
@property (nonatomic,strong) NSString* Operate_type;//附件上传操作类型"//1增加 2更新 3删除

-(NSString*)suffix;
-(void)createDefault;
-(void)setLocalPath:(NSString*)localPath;
@end

//附件图片
@interface LLDaoModelDiaryAttachsCellAttachimageCell:NSObject
@property (nonatomic,strong) NSString* imageurl;
@property (nonatomic,strong) NSString* imagetype;
@property (nonatomic,strong) NSString* imagesize;  // 附件大小（单位B）
@end

//附件声音
@interface LLDaoModelDiaryAttachsCellAttachaudioCell:NSObject
@property (nonatomic,strong) NSString* audiourl;
@property (nonatomic,strong) NSString* audiotype;    // 音频类型1原音 2加密音
@property (nonatomic,strong) NSString* audiosize;    // 附件大小（单位B）

@end

//附件视频
@interface LLDaoModelDiaryAttachsCellVideopathCell:NSObject
@property (nonatomic,strong) NSString* videotype;   //（1高清、2普清、0原视频）
@property (nonatomic,strong) NSString* playvideourl;
@property (nonatomic,strong) NSString* videosize;   // 附件大小（单位B）
@end


@interface LLDaoModelDiaryDuplicateCell:NSObject
@property (nonatomic,strong) NSString* diaryid;                 //
@property (nonatomic,strong) NSString* diaryuuid;                 //
@property (nonatomic,strong) NSString* duplicatename;           //
@end

@interface PlatformUrlCell:NSObject
@property (nonatomic,strong) NSString* snstype;                 //0:looklook社区 1:新浪微博 2:人人网 6:腾讯微博
@property (nonatomic,strong) NSString* url;                     //链接地址
@end         


@interface LLDaoModelDiary : LLDaoModelBase

@property (nonatomic, strong) NSString* fromOldversion2_2;

// add by capry chen
@property (nonatomic, strong) NSString* localThirdShareMesHistory;               // 本地第三方分享文字历史纪录

@property (nonatomic, strong) NSString* diaryuuid;               // 日记的本地id
@property (nonatomic, assign) int uploadTask_taskID;             // 上传任务id
@property (nonatomic, strong) NSString *isFavorite;              // 是否p收藏 y:已收藏 n:未收藏
@property (nonatomic, strong) NSString *position_source;//位置来源，1 GPS 2基站 ,可以为空
@property (nonatomic,strong) NSString* addresscode; //地址的国际码,可以为空

@property (nonatomic, strong) NSString *resourcediaryid;    //日记为副本时有效，所关联主日记id
@property (nonatomic, strong) NSString *resourceuuid;    //日记为副本时有效，所关联主日记uuid
@property (nonatomic, strong) NSString* is_delete;
@property (nonatomic, strong) NSString *is_publish_status;      // 是否发布过 0:未发布 1:已发布

//下面同服务器协议
@property (nonatomic,strong) NSString* weight;                  // 权重值
@property (nonatomic,strong) NSString* size;                    // 日记大小（单位M）
@property (nonatomic,strong) NSString* nickname;                // 昵称",  //日记主人昵称
@property (nonatomic,strong) NSString* headimageurl;            // 日记主人头像地址

@property (nonatomic,strong) NSMutableArray* platformurls;      // 不同的社区类型拥有不同的分享URL

@property (nonatomic,strong)NSString* isShortSoundRecognizedToText;//标记短录音是否已经被识别为文字(附件为短录音时有效)  1:已识别成功 0:识别失败
@property (nonatomic,strong) NSString* join_safebox;            // 是否加入保险箱，1是 0否
@property (nonatomic,strong) NSString* weather;                 // 天气
@property (nonatomic,strong) NSString* weather_info;            // 天气描述
@property (nonatomic,strong) NSString* mood;                    // 心情
@property (nonatomic,strong) NSString* publishid;               // 微博表id
@property (nonatomic,strong) NSString* diaryid;                 // 日记ID
@property (nonatomic,strong) NSString* userid;                  // 用户id
@property (nonatomic,strong) NSString* diarytimemilli;          // 日记建立毫秒数
@property (nonatomic,strong) NSString* updatetimemilli;         // 日记修改毫秒数
@property (nonatomic,strong) NSString* introduction;            // 简介，base64编码
@property (nonatomic,strong) NSString* publish_status;          // 1全部人可见 2关注人可见 3指定人可见 4仅自己可见
@property (nonatomic,strong) NSString* position_status;         // 1全部人可见（黑名单人除外） 2关注人可见  4仅自己可见，PUBLISH_status=1有效
@property (nonatomic,strong) NSMutableArray* sns;               // json字串
@property (nonatomic,strong) NSString* snscollect_sina;         // "1231,12312,12312",// 所有分享到新浪的微博id
@property (nonatomic,strong) NSString* snscollect_tencent;      // "12312,1231,12312",// 所有分享到腾讯的微博id总和
@property (nonatomic,strong) NSString* iscollect;               // 1：已收藏，0：未收藏"
@property (nonatomic,strong) NSMutableArray* tags;              // json字串
@property (nonatomic,strong) NSString* position;                // 位置信息，base64编码
@property (nonatomic,strong) NSString* longitude;               // 经度
@property (nonatomic,strong) NSString* latitude;                // 纬度
@property (nonatomic, strong) NSString *offset;             //位置偏移量

@property (nonatomic,strong) NSString* sex;                     // 0男，1女， 2未知
@property (nonatomic,strong) NSString* signature;               // 个性签名,base64编码的
@property (nonatomic,strong) NSString* diary_status;            // 1 "0无效（删除） 1新建 2 发布 -1 在任务队列中正在发布中(本地加的与服务器无关）-2 未发布
@property (nonatomic,strong) NSString* upload_status;           // -2（正在上传）-3(已上传) －4(未上传）
@property (nonatomic,strong) NSString* synchronization_status;  // 0(未同步) 1(已同步）
@property (nonatomic,strong) NSString* enjoycount;              // 喜欢数
@property (nonatomic,strong) NSString* location_status;         // 位置状态，0：保密，1不保密
@property (nonatomic,strong) NSString* commentcount;            // 评论数
@property (nonatomic,strong) NSString* forwardcount;            // 转发数
@property (nonatomic,strong) NSString* collectcount;            // 收藏数
@property (nonatomic,strong) NSMutableArray* attachs;           // 附件
@property (nonatomic,strong) LLDaoModelDiaryActiveCell* active;
@property (nonatomic,strong) NSMutableArray* duplicate;         // 副本
@property (nonatomic,assign) int publishtaskid;                 // 发布任务id
@property (nonatomic,assign) int sharetaskid;                   // 分享任务的id
@property (nonatomic,assign) int favoriteTaskId;                // 收藏任务的id
@property (nonatomic,assign) int downTaskId;                    // 下载任务的id
@property (nonatomic,assign) int safeboxTaskId;                    // 加入取消保险箱任务的id
+(NSString*)fetchLocalFilePath:(NSString*)localDiaryID;
-(NSString*)imageForShow;//从附件里找一张图片，或视频截图用于相册
-(NSString*)tagsString;
-(void)setLocalPath:(NSString*)localPath :(NSString*)attachUUid;
-(NSString*)localPath;
-(NSString*)localSize;
-(long long)partOflocalSize:(int)index;
+(LLDaoModelDiary*)diaryFromUuid:(NSString*)uuid;
+(LLDaoModelDiaryAttachsCellVideopathCell*)getVideoAttach:(NSString*)diaryuuid :(NSString*)attachuuid;
+(LLDaoModelDiaryAttachsCellAttachaudioCell*)getAudioAttach:(NSString*)diaryuuid :(NSString*)attachuuid;
+(LLDaoModelDiaryAttachsCellAttachimageCell*)getImageAttach :(NSString*)diaryuuid :(NSString*)attachuuid;
-(NSString*)lastAttachUUid;
-(void)setCoverImage:(NSString*)imageFile :(NSString*)attachUUid;
+(void)setUploadStatus:(NSString*)diaryuuid :(NSString*)upLoadStatus;
+(void)setDiaryStatus:(NSString*)diaryuuid :(NSString*)diaryStatus;
+(void)deleteAttachsFiles:(NSString*)diaryuuid;
//附件类型，1视频、2音频、3图片、4文字 0无主附件
-(NSString*)mainAttachType;
-(NSString*)mainAttachTypeDesc;
-(NSString*)mainAttachCreateType;
+(void)mergeAttachs:(NSArray*)netAttachs :(NSArray*)localAttachs isSynchronized:(BOOL)isSynchronized;//localAttachs加到netAttachs中，多余的附件删除
+ (void) deleteLocalDiary:(NSString *)diaryuuid block:(void(^)(BOOL result))block;
-(void)uploadVideoCover;
+(LLDaoModelDiary*)diaryFromId:(NSString*)diaryid;
+(void)deleteDiaryWithTask:(NSString *)diaryuuids;
+(void)deleteDiaryAndDumplicateWithTask:(NSString *)diaryuuids;
/**
 * 功能：删除本地日记任务
 * 参数：(NSString *)diaryuuid
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-06-06
 */
+ (void) deleteLocalDiaryTask:(NSString *)diaryuuid block:(void(^)(BOOL result))block;

//取第一个副本
-(NSString*)firstDumplicateDiaryuuid;
//从主日记中解除某个副本
-(void)removeDumplicate:(NSString*)diaryuuid;
//副本从主日记中脱离，成为新日记
-(void)unlinkFromMainDiary;
//把指定的副本日记提为主日记，本日记脱离关系
-(void)upDumplicateToMainDiary:(NSString*)dumplicateDiaryuuid;
@end
