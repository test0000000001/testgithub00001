//
//  CreateStructureResponseData.h
//  VideoShare
//
//  Created by zengchao on 13-6-3.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "BaseData.h"
@class LLDaoModelDiary;
@interface CreateStructureRequestAttachData : NSObject
@property (nonatomic,strong) NSString* attachid;
@property (nonatomic,strong) NSString* attachuuid;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* attach_type;//1视频 2音频 3图片 4文字
@property (nonatomic,strong) NSString* audio_type;//1原音，2加密音，attach_type=2有效
@property (nonatomic,strong) NSString* level;
@property (nonatomic,strong) NSString* attach_logitude;
@property (nonatomic,strong) NSString* attach_latitude;
@property (nonatomic,strong) NSString* suffix;
@property (nonatomic,strong) NSString* Operate_type;
//客户端添加，纪录上传任务进度
@property (nonatomic,strong) NSString* createType;               //附件形成类型,1正常,n分段
@property (nonatomic,strong) NSString* nuid;//已上传了几段
@property (nonatomic,strong) NSString* video_type;//0高清1普请
@property (nonatomic,strong) NSString* photo_type;

@end

@interface CreateStructureRequestData : NSObject
@property (nonatomic,strong) NSString* userid;
@property (nonatomic,strong) NSString* diaryid;
@property (nonatomic,strong) NSString* diaryuuid;
@property (nonatomic,strong) NSString* operate_diarytype;//操作类型，1新建，2更新，3保存副本（另存为）
@property (nonatomic,strong) NSString* resourcediaryid;
@property (nonatomic,strong) NSString* resourcediaryuuid;
@property (nonatomic,strong) NSMutableArray* attachs;
@property (nonatomic,strong) NSString* tags;
@property (nonatomic,strong) NSString* logitude;
@property (nonatomic,strong) NSString* latitude;
//add by xudongsheng
@property (nonatomic,strong) NSString* userselectposition; //用户自己选位置
@property (nonatomic,strong) NSString* userselectlogitude;//用户自己选经度
@property (nonatomic,strong) NSString* userselectlatitude; //用户自己选维度

@property (nonatomic,strong) NSString* position_source;//位置来源，1 GPS 2基站 ,可以为空
@property (nonatomic,strong) NSString* addresscode;//地址的国际码,可以为空
@property (nonatomic,strong) NSString* offset;//位置偏移量

@property (nonatomic,strong) NSString* createtime;//8月6日添加,时间以客户端为准

@property (nonatomic,strong)NSString* isShortSoundRecognizedToText;//标记短录音是否已经被识别为文字(附件为短录音时有效)  1:已识别成功 0:识别失败

-(void)createDefault;
-(void)createFromModelDiary:(LLDaoModelDiary*)lLDaoModelDiary;
@end


@interface CreateStructureResponseAttachData : NSObject
@property (nonatomic,strong) NSString* attachid;
@property (nonatomic,strong) NSString* attachuuid;
@property (nonatomic,strong) NSString* path;
@end


@interface CreateStructureResponseData : BaseData
@property (nonatomic,strong) NSString* status;
@property (nonatomic,strong) NSString* ip;
@property (nonatomic,strong) NSString* port;
@property (nonatomic,strong) NSString* spacesize;
@property (nonatomic,strong) NSString* maxsize;
@property (nonatomic,strong) NSString* diaryid;
@property (nonatomic,strong) NSString* diaryuuid;
@property (nonatomic,strong) NSMutableArray* attachs;

@property (nonatomic,strong) NSString* diaryupdatetime;
@end
