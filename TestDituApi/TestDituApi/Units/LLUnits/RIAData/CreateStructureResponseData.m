//
//  CreateStructureResponseData.m
//  VideoShare
//
//  Created by zengchao on 13-6-3.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "CreateStructureResponseData.h"
#import "NSObject+ABJsonConverter.h"
#import "DiaryData.h"
#import "LLDaoModelDiary.h"
#import "Tools.h"
#import "LLDefines.h"

@implementation CreateStructureRequestAttachData
-(id)init
{
    if (self = [super init]) {
        self.createType = @"1";               //附件形成类型,1正常,n分段
        self.nuid = @"0";//已上传了几段
    }
    return self;
}
@end

@implementation CreateStructureRequestData
-(id)init
{
    if (self = [super init]) {
        self.attachs = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    CreateStructureRequestData* returnObject = [super customClassWithProperties:properties];
    [Tools arrayToClass:returnObject.attachs :[CreateStructureRequestAttachData class]];
    return returnObject;
}

-(void)createDefault
{
    self.userid = APP_USERID;
    self.diaryid = @"";
    self.diaryuuid = @"";
    self.resourcediaryid = @"";
    
    CreateStructureRequestAttachData* createStructureRequestAttachData = [[CreateStructureRequestAttachData alloc] init];
    createStructureRequestAttachData.attachid = @"";
    createStructureRequestAttachData.attachuuid = @"";
    createStructureRequestAttachData.content = @"";
    createStructureRequestAttachData.attach_type = @"";
    createStructureRequestAttachData.audio_type = @"";
    createStructureRequestAttachData.level = @"";
    createStructureRequestAttachData.attach_logitude = @"";
    createStructureRequestAttachData.attach_latitude = @"";
    createStructureRequestAttachData.suffix = @"";
    createStructureRequestAttachData.Operate_type = @"";
    
    self.attachs = [[NSMutableArray alloc] initWithCapacity:10];
    [_attachs addObject:createStructureRequestAttachData];
    self.tags = @"";
    self.logitude = @"";
    self.latitude = @"";
}

-(void)createFromModelDiary:(LLDaoModelDiary*)lLDaoModelDiary
{
    self.userid = lLDaoModelDiary.userid;
    self.diaryid = lLDaoModelDiary.diaryid;
    self.diaryuuid = lLDaoModelDiary.diaryuuid;
    self.resourcediaryid = @"";
    self.resourcediaryuuid = @"";
    self.userselectposition = lLDaoModelDiary.position; //用户自己选位置
    self.userselectlogitude = lLDaoModelDiary.longitude;//用户自己选经度
    self.userselectlatitude = lLDaoModelDiary.latitude; //用户自己选维度
    self.position_source = lLDaoModelDiary.position_source;
    self.addresscode = lLDaoModelDiary.addresscode;
    self.offset = lLDaoModelDiary.offset;
    self.createtime = lLDaoModelDiary.diarytimemilli;
    self.isShortSoundRecognizedToText = lLDaoModelDiary.isShortSoundRecognizedToText;
    
    self.attachs = [[NSMutableArray alloc] initWithCapacity:10];
    for (LLDaoModelDiaryAttachsCell* cell in lLDaoModelDiary.attachs) {
        CreateStructureRequestAttachData* createStructureRequestAttachData = [[CreateStructureRequestAttachData alloc] init];
        createStructureRequestAttachData.attachid = cell.attachid;
        createStructureRequestAttachData.attachuuid = cell.attachuuid;
        createStructureRequestAttachData.content = cell.content;
        createStructureRequestAttachData.attach_type = cell.attachtype;
        createStructureRequestAttachData.level = cell.attachlevel;
        createStructureRequestAttachData.audio_type = cell.audio_type;
        //最后拦截，解决短录音audio_type因为一些不确定因素偶尔为@“”，导致无法上传的问题
        if(STR_IS_NIL(createStructureRequestAttachData.audio_type) && [@"2" isEqualToString:createStructureRequestAttachData.attach_type]){
            //短录音，传过来的audio_type为空串时
             createStructureRequestAttachData.audio_type = @"1";
        }
        createStructureRequestAttachData.attach_logitude = cell.attach_logitude;
        createStructureRequestAttachData.attach_latitude = cell.attach_latitude;
        createStructureRequestAttachData.suffix = [cell suffix];
        createStructureRequestAttachData.Operate_type = cell.Operate_type;
        createStructureRequestAttachData.createType = cell.createType;
        createStructureRequestAttachData.video_type = UN_NIL(cell.video_type);
        createStructureRequestAttachData.photo_type = UN_NIL(cell.photo_type);
        
        //容错
        if(STR_IS_NIL(createStructureRequestAttachData.photo_type) && [@"3" isEqualToString:createStructureRequestAttachData.attach_type] && [@"1" isEqualToString:createStructureRequestAttachData.level]){
           createStructureRequestAttachData.photo_type = @"0";
        }
        [_attachs addObject:createStructureRequestAttachData];
    }

    self.tags = [lLDaoModelDiary tagsString];
    self.logitude = lLDaoModelDiary.longitude;
    self.latitude = lLDaoModelDiary.latitude;
}

@end



@implementation CreateStructureResponseAttachData
@end

@implementation CreateStructureResponseData

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

+(id)customClassWithProperties:(id)properties
{
    CreateStructureResponseData* returnObject = [super customClassWithProperties:properties];
    [Tools arrayToClass:returnObject.attachs :[CreateStructureResponseAttachData class]];
    return returnObject;
}

- (void)setResponseModelFromDic:(NSDictionary*)dataDictionary{
    [super setResponseModelFromDic:dataDictionary];
    if (dataDictionary) {
        [self safeSetValuesForKeysWithDictionary:dataDictionary];
        [Tools arrayToClass:self.attachs :[CreateStructureResponseAttachData class]];
    }
}

@end
