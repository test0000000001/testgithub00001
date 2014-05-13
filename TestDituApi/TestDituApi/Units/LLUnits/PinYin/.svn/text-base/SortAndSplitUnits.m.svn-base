//
//  SortAndSplitUnits.m
//  VideoShare
//
//  Created by tangyx on 13-6-14.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "SortAndSplitUnits.h"
#import "SortAndSplitData.h"
@implementation SortAndSplitUnits
+ (NSDictionary*)getSortAndSplitFrom:(NSMutableArray *)arrToSort{
    NSMutableDictionary* returnDic = [NSMutableDictionary dictionary];
    for(int i = 0; i < [arrToSort count]; i++) {
        id object = [arrToSort objectAtIndex:i];
        if(![object isKindOfClass:[SortAndSplitData class]]){
            NSLog(@"object is not kindOfClass");
            return returnDic;
        }
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sortSplitKey" ascending:YES]];
    [arrToSort sortUsingDescriptors:sortDescriptors];
 
    for(int index = 0; index < [arrToSort count]; index++){
        SortAndSplitData* data = [arrToSort objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:data.sortSplitKey];
        NSString *sr= [strchar substringToIndex:1];
        NSMutableArray* array = [returnDic objectForKey:sr];
        if(!array){
            array = [NSMutableArray array];
            [returnDic setObject:array forKey:sr];
        }
        [array addObject:data];
    }
//    return arrayForArrays;
    return returnDic;
}
+(NSString*)getFristCharString:(NSString *)string{
    if(string && ![string isEqualToString:@""]){
        //join the pinYin
        NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                         pinyinFirstLetter([string characterAtIndex:0])]uppercaseString];
        if( ![[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] containsObject:singlePinyinLetter]){
            return @"#";
        }
        return singlePinyinLetter;
    } else {
        return @"#";
    }
}
@end
