//
//  recoderDelegate.h
//  EfAVWriter
//
//  Created by penggang xi on 6/5/13.
//
//

#import <Foundation/Foundation.h>

@protocol recoderDelegate <NSObject>

- (void) finishSmallFile:(NSString*)allpath;
- (void) finishBigFile:(NSString*)allpath;

- (void) voiceRecognition:(unsigned char*)data size:(int)nsize;

@end
