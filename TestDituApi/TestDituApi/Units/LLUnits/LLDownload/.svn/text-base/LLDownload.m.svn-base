//
//  LLDownload.m
//  xFeng4
//
//  Created by zc on 12-6-26.
//  Copyright 2012 cmmobi. All rights reserved.
//

#import "LLDownload.h"
#import "HttpRequest.h"
#import "LocalResourceModel.h"
@interface LLDownload()

@property (nonatomic, weak) id<LLDownloadDelegate> delegate;

@end

@implementation LLDownload
-(id)initWithDelegate:(id<LLDownloadDelegate>)delegate;
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate method
//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小，可以显示下载进度多少字节
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* name = [[request.userInfo objectForKey:@"ASI_netWorkQueue_name"] description];
    if([name isEqualToString:self.name])
    {
        [_delegate downloadFailed:NO DownloadUrl:self.downloadurl Name:self.name LocalfilePath:self.localfilePath];
    }
    
}

//ASIHTTPRequestDelegate,下载完成时,执行的方法
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString* name = [[request.userInfo objectForKey:@"ASI_netWorkQueue_name"] description];
    if([name isEqualToString:self.name])
    {
        NSLog(@"closedself.downloadurl = url=%@，localfilePath=%@，name=", self.downloadurl, self.localfilePath);
        [_delegate downloadClosed:NO  DownloadUrl:self.downloadurl Name:self.name LocalfilePath:self.localfilePath];
    }
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
//    [_delegate infoChanged:bytes DownloadUrl:self.downloadurl Name:self.name LocalfilePath:self.localfilePath];

}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
//    [_delegate infoChanged:newLength DownloadUrl:self.downloadurl Name:self.name LocalfilePath:self.localfilePath];
    //[_delegate infoChanged:newLength];
}

- (void)setProgress:(float)newProgress
{
    self.percent = newProgress;
    [_delegate downloadProgress:newProgress DownloadUrl:_downloadurl Name:_name LocalfilePath:_localfilePath];
}



-(void)download:(NSString*)url:(NSString*)localfilePath:(NSString*)name
{
    
    self.downloadurl = url;
    self.localfilePath = localfilePath;
    self.name = name;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//判断temp文件夹是否存在
	BOOL fileExists = [fileManager fileExistsAtPath:localfilePath];
	if (!fileExists) {//如果不存在说创建,因为下载时,不会自动创建文件夹
		[fileManager createDirectoryAtPath:localfilePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    self.request = nil; 

    self.request = [[ASIHTTPRequest alloc] initWithURL:[[NSURL alloc] initWithString:@""]];
    
    _request.delegate = self;
    
    NSString* savePath = [[localfilePath stringByAppendingPathComponent:name] stringByAppendingPathExtension:[url pathExtension]];
    
    NSString *tempPath = [savePath stringByAppendingPathExtension:@"ASItmp"];
    
    //设置文件保存路径
    [_request setDownloadDestinationPath:savePath];
    //设置临时文件路径
	[_request setTemporaryFileDownloadPath:tempPath];
    
    //设置进度条的代理,
	[_request setDownloadProgressDelegate:self];
    
    
    [_request setShowAccurateProgress:YES];
    
    //设置是是否支持断点下载
    [_request setAllowResumeForFileDownloads:YES];
    
    [_request setShouldContinueWhenAppEntersBackground:YES];
    
    //设置基本信息
	[_request setUserInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"ASI_netWorkQueue_name",nil]];
    //连续下载内容时可能导致当前下载的内容是下载的上次内容，所以需要重定向一下url，自动重定向url不起作用
    [_request redirectToURL:[[NSURL alloc] initWithString:url]];

//    [_request setUseCookiePersistence:NO];
//    NSLog(@"_request.urlself.downloadurl =%@", _request.url);
//    [_request startSynchronous];
    [_request startAsynchronous];
//    NSLog(@"_request startAsynchronous_request.urlself.downloadurl =%@", _request.url);
//    NSLog(@"self.downloadurl =%@ ,localfilePath=%@，name=%@ ,savePath = %@ , tempPath = %@", self.downloadurl, self.localfilePath,self.name,savePath,tempPath);
}

-(void)deleteDownload
{
    [_request clearDelegatesAndCancel];
}

@end
