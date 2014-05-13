//
//  SortAndSplitData.m
//  VideoShare
//
//  Created by tangyx on 13-6-14.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "SortAndSplitData.h"

@implementation SortAndSplitData
@synthesize sortSplitKey,sortSplitString;
-(void)setSortSplitString:(NSString *)string{
    sortSplitString = string;
    if(string && ![string isEqualToString:@""]){
        //join the pinYin
        NSString *pinYinResult = [NSString string];
        for(int j = 0;j < string.length; j++) {
            NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                             pinyinFirstLetter([string characterAtIndex:j])]uppercaseString];
            pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
        }
        self.sortSplitKey = pinYinResult;
    } else {
        self.sortSplitKey = @"#";
    }
}
@end
