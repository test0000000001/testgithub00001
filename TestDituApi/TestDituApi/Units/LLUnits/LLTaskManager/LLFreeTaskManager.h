//
//  LLFreeTaskManager.h
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLTaskBase.h"

@interface LLFreeTaskManager : NSObject
+(LLFreeTaskManager *)sharedLLFreeTaskManager;
-(int)addTask:(Class)taskClass:(NSString*)taskInfo;
-(void)setTaskNeedDelete:(int)taskID;
-(int)count;
-(void)setTaskContinue:(int)taskID;
-(void)setTaskPause:(int)taskID;
-(void)setTaskInfo:(int)taskID:(NSString*)taskInfo:(NSString*)changeReason;
-(void)startTask;
-(void)reSetAllTaskAlive;
-(void)reSetAllTaskSleep;
-(void)stopTask;
-(void)reSetTasksFromDataBase;
//销毁单例
+(void)attemptDealloc;
@end
