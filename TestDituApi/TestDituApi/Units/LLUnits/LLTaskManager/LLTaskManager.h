//
//  LLTaskManager.h
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLTaskBase.h"

@interface LLTaskManager : NSObject
@property(nonatomic,assign) int taskIDOfPriorityFlag;
@property(nonatomic,assign) BOOL taskListAlive;
+(LLTaskManager *)sharedLLTaskManager;
-(void)startTask;
-(int)addTask:(Class)taskClass:(NSString*)taskInfo;
-(void)setTaskNeedDelete:(int)taskID;
-(int)count;
-(LLTaskBase*)taskAtIndex:(int)index;
-(void)setTaskContinue:(int)taskID;
-(void)setTaskPause:(int)taskID;
-(void)setTaskInfo:(int)taskID:(NSString*)taskInfo:(NSString*)changeReason;
-(void)IndexToID:(int)index:(void (^)(BOOL b,int taskID))block;
-(void)IDToIndex:(int)taskID:(void (^)(BOOL b,int index))block;
-(void)bringTaskToFirst:(int)taskID;
-(int)taskIDOfPriorityFlag;
-(void)setPriorityFlag:(int)taskID;
-(BOOL)isTaskAlive:(int)taskID;
-(BOOL)isTaskPriorityFlag:(int)taskID;
-(LLDaoModelTask*)task:(int)taskID;
-(NSString*)taskInfo:(int)taskID;//根据任务id取任务信息
-(void)reSetAllTaskAlive;
-(void)stopTask;
-(void)reSetAllTaskSleep;
-(void)reSetTasksFromDataBase;
+(void)attemptDealloc;   //销毁单例
@end
