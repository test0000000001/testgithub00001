//
//  LLOldBindModel.h
//  VideoShare
//
//  Created by zengchao on 13-8-10.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindCell : NSObject<NSCoding>
{
    NSString* _type;
    NSString* _binded;
    NSString* _opened;
    NSString* _name;
    NSString* _snsid;
}
@property(nonatomic,retain) NSString* type;
@property(nonatomic,retain) NSString* binded;
@property(nonatomic,retain) NSString* opened;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* snsid;
@end

@interface LLOldBindModel : NSObject
{
    NSMutableArray* _bindedList;
}
@property(nonatomic,retain) NSMutableArray* bindedList;
//从本地记录加载更新微博绑定列表
-(void)refreshFromLocalRecord:(LLDAOBase*)dao SnsType:(NSString*)snstype;

@end
