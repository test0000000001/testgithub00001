//
//  SortAndSplitUnits.h
//  VideoShare
//
//  Created by tangyx on 13-6-14.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortAndSplitUnits : NSObject
+ (NSDictionary*)getSortAndSplitFrom:(NSMutableArray *)arrToSort;
+(NSString*)getFristCharString:(NSString *)string;
@end
