//
//  transcodeDelegate.h
//  EfAVWriter
//
//  Created by penggang xi on 6/28/13.
//
//

#import <Foundation/Foundation.h>

@protocol transcodeDelegate <NSObject>

@optional
/**
 @name:dataReady 转码时数据回调，暂时只用于转pcm来语音识别时使用
 @param:data 存储pcm数据。
 @param:datasize data的长度
 @param:obj 使用回调的对象。用该变量来判断不同对象的回调。
 **/
- (void)dataReady:(unsigned char*)data size:(int)datasize ower:(void*)obj;
/**
 @name:transcodeFinish  当转码完成时
 @param:obj 使用回调对象的对象。
 **/
- (void)transcodeFinish:(void*)obj;

@end
