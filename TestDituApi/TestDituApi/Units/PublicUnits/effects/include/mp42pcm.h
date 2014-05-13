//
//  mp42pcm.h
//  EfAVWriter
//
//  Created by penggang xi on 6/28/13.
//
//

#import <Foundation/Foundation.h>

@interface mp42pcm : NSObject

- (id)initWithDelegate:(id)pdelegate;


//开始转码
- (BOOL) start:(NSString*)filename;
//停止转码
- (void) stop;

@end