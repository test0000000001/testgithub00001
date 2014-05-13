//
//  LLDownload.h
//  xFeng4
//
//  Created by zc on 12-6-26.
//  Copyright 2012 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"
#import "ASIHTTPRequest.h"

@protocol LLDownloadDelegate
@optional
-(void)downloadClosed:(BOOL)error  DownloadUrl:(NSString*)downloadurl Name:(NSString*)name
        LocalfilePath:(NSString*)localfilePath;
-(void)downloadFailed:(BOOL)error  DownloadUrl:(NSString*)downloadurl Name:(NSString*)name
        LocalfilePath:(NSString*)localfilePath;
-(void)infoChanged:(long long)partialLength DownloadUrl:(NSString*)downloadurl Name:(NSString*)name
LocalfilePath:(NSString*)localfilePath;

-(void)downloadProgress:(float)percent DownloadUrl:(NSString*)downloadurl Name:(NSString*)name
     LocalfilePath:(NSString*)localfilePath;
@end

@interface LLDownload : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate> {
	
}
@property (nonatomic, strong) NSString* downloadurl;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* localfilePath;
@property (nonatomic, assign) float percent;
@property(nonatomic,strong) ASIHTTPRequest *request;

-(id)initWithDelegate:(id<LLDownloadDelegate>)delegate;
-(void)download:(NSString*)url:(NSString*)localfilePath:(NSString*)name;
-(void)deleteDownload;

@end
