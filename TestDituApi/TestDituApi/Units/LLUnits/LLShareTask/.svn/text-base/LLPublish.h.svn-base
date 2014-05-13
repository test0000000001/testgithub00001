//
//  LLPublish.h
//  VideoShare
//
//  Created by tangyx on 13-6-20.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelWithRIARequestLib.h"
//@protocol LLPublishDelegate <NSObject>
//
//-(void)publishFinished:(BOOL)error;
//-(void)cancelPublishFinished:(BOOL)error;
//@end

@interface LLPublish : BaseModelWithRIARequestLib

//@property(nonatomic,weak)id<LLPublishDelegate>delegate;

-(void) publishDiary:(NSString *)diaryID userid:(NSString *)userid publishType:(NSString *)publishType diaryType:(NSString *)diaryType positionType:(NSString *)positionType audioType:(NSString *)audioType  block:(void(^)(RIA_RESPONSE_CODE result)) block;
-(void) cancelPublishDiary:(NSString *)diaryID userid:(NSString *)userid publishType:(NSString *)publishType diaryType:(NSString *)diaryType positionType:(NSString *)positionType audioType:(NSString *)audioType  block:(void(^)(RIA_RESPONSE_CODE result)) block;
@end
