//
//  LLTaskBase.h
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLDaoModelTask.h"

@protocol LLTaskBaseDelegate
@optional
-(void)taskFinished:(int)taskID:(BOOL)error;//出错了error传YES
-(void)taskPaused:(int)taskID;
-(void)deletedTaskFinish:(int)taskID;
@end

@interface LLTaskBase : NSObject
{
    int _taskID;
    NSString* _taskInfo;
    __weak id<LLTaskBaseDelegate> _delegate;
}
@property (nonatomic,assign) int taskID;
@property (nonatomic,strong) NSString* taskInfo;

-(void)set_Delegate:(id<LLTaskBaseDelegate>)delegate;
-(void)taskInfoChanged:(NSString*)taskInfo:(NSString*)changeReason;
-(void)startTask;
-(void)taskNeedDelete;
-(float)percent;
-(NSString*)imageFile;
-(NSString*)sizeInTotal;
@end
