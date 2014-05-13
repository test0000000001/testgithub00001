//
//  LLTaskBase.m
//  VideoShare
//
//  Created by zengchao on 13-6-13.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "LLTaskBase.h"

@interface LLTaskBase()


@property(nonatomic,weak) id<LLTaskBaseDelegate> delegate;
@end


@implementation LLTaskBase

-(void)set_Delegate:(id<LLTaskBaseDelegate>)delegate
{
    self.delegate = delegate;
}

-(void)taskInfoChanged:(NSString*)taskInfo:(NSString*)changeReason
{
    self.taskInfo = taskInfo;
}

-(void)startTask
{
    //子类实现
}

//执行完毕后此对象
-(void)taskNeedDelete
{
    
}


@end
