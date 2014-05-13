//
//  LLOldVersionLocalVideoTransport.h
//  VideoShare
//
//  Created by zengchao on 13-8-9.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UAModel : NSObject<NSCoding>
@end


@interface ListMyDiaryIdResponseData : BaseData

@property (nonatomic, strong) NSString *diaryids;

@end

@interface LLOldVersionLocalVideoTransport : NSObject
+(LLOldVersionLocalVideoTransport *)sharedInstance;
-(void)doTransportStep1;
-(void)doTransportStep2;
-(void)doTransportStep3;
-(void)doTransportStep4;
-(BOOL)isFinish;
@property(nonatomic,assign) BOOL allDiaryDownloaded;
@end
