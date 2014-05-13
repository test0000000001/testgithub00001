//
//  NSObjectExtraForLLDao.h
//  VideoShare
//
//  Created by zengchao on 13-5-23.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(LLGetPropertys)
+(NSDictionary*)getPropertysByColumn; //返回 该类的所有属性 不上溯到 父类
+(NSDictionary *)getPropertysByLine;
+(void)getSelfPropertys:(NSMutableArray *)pronames protypes:(NSMutableArray *)protypes isGetSuper:(BOOL)isGetSuper;//获取自身的属性 是否获取父类
@end