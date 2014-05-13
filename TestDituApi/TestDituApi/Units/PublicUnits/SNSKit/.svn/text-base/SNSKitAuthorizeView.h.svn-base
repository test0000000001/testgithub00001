//
//  SNSKitAuthorizeView.h
//  SNSKit
//
//  Created by wenjie-mac on 12-12-4.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
//腾讯的一堆错误相关的东东
#define TCWBSDKErrorDomain       @"TCSDKErrorDomain"  //生成error对象时的自定义domain
#define TCWBSDKErrorCodeKey      @"TCSDKErrorCodeKey" //error对应的键值
typedef enum{
	TCWBErrorCodeInterface	 = 100,
	TCWBErrorCodeSDK         = 101,
}TCWBErrorCode;

typedef enum{
	TCWBSDKErrorCodeParseError       = 200,     //解析错误
	TCWBSDKErrorCodeRequestError     = 201,     //请求错误
	TCWBSDKErrorCodeAccessError      = 202,     //返回accesstoken错误
	TCWBSDKErrorCodeAuthorizeError	 = 203,     //认证错误
}TCWBSDKErrorCode;

@protocol SNSKitAuthorizeViewDelegate;

@interface SNSKitAuthorizeView : UIView<UIWebViewDelegate>
{
    UIWebView *webView;
    UIButton *closeButton;
    UIView *modalBackgroundView;
    UIActivityIndicatorView *indicatorView;//旋转进度轮
    UIInterfaceOrientation previousOrientation;
    
//    id<SNSKitAuthorizeViewDelegate> delegate;
    
    NSString *appRedirectURI;//回调页
    NSDictionary *authParams;//认证信息
    
    int type;
}

@property (nonatomic, strong) id<SNSKitAuthorizeViewDelegate> delegate;

- (id)initWithAuthParams:(NSDictionary *)params
                delegate:(id<SNSKitAuthorizeViewDelegate>)delegate
                 snstype:(int)type;

- (void)show;
- (void)hide;

@end

@protocol SNSKitAuthorizeViewDelegate <NSObject>
//成功回调
- (void)authorizeView:(SNSKitAuthorizeView *)authView
didRecieveAuthorizationCode:(NSString *)code;
//报错回调
- (void)authorizeView:(SNSKitAuthorizeView *)authView
 didFailWithErrorInfo:(NSDictionary *)errorInfo;
//取消回调
- (void)authorizeViewDidCancel:(SNSKitAuthorizeView *)authView;
@end
