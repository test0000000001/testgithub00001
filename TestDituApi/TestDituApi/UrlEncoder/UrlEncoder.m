//
//  UrlEncoder.m
//  VideoShare
//
//  Created by xu dongsheng on 13-5-23.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "UrlEncoder.h"

@implementation UrlEncoder

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return outputStr;
}

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
