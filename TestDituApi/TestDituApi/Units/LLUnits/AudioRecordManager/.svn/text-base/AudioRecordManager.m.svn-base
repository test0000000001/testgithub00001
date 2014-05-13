//
//  RecordManager.m
//  VideoShare
//
//  Created by xu dongsheng on 13-6-7.
//  Copyright (c) 2013年 zengchao. All rights reserved.
//

#import "AudioRecordManager.h"
#import "LocalResourceModel.h"

@implementation AudioRecordManager

+ (AudioRecordManager *) audioRecordManagerWithOuterDelegate:(id<recoderDelegate>)outerDelegate{
    AudioRecordManager* rm = [[AudioRecordManager alloc]init];
    #if !(TARGET_IPHONE_SIMULATOR)
    rm->_audioRecorderApi = [[AudioRecoderUseApi alloc]initWithDelegate:outerDelegate];
    #endif
    return rm;
}

- (void) startRecodeAudio:(NSString*)path id:(NSString*)fileid cat:(BOOL)bcat{
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
#if !(TARGET_IPHONE_SIMULATOR)
    if ([self.audioRecorderApi isRecode]) {
        [self.audioRecorderApi stopRecodeAudio];
    }else{
        [self.audioRecorderApi startRecodeAudio:path fileID:fileid cat:bcat];
    }
#endif
}

- (void) stopRecodeAudio{
    [[UIApplication sharedApplication]setIdleTimerDisabled:NO];
    #if !(TARGET_IPHONE_SIMULATOR)
    if ([self.audioRecorderApi isRecode]) {
        [self.audioRecorderApi stopRecodeAudio];
    }
    #endif
}

- (void) pauseRecodeAudio{
    #if !(TARGET_IPHONE_SIMULATOR)
    if([self.audioRecorderApi isRecode]){
        [self.audioRecorderApi pauseRecodeAudio];
    }
    #endif
}

- (void) resumeRecodeAudio{
    #if !(TARGET_IPHONE_SIMULATOR)
    if ([self.audioRecorderApi isPaused]) {
        [self.audioRecorderApi resumeRecodeAudio];
    }
    #endif
}

- (BOOL) isRecode{
     return [self.audioRecorderApi isRecode];
}

- (BOOL) isPaused{
     return [self.audioRecorderApi isPaused];
}
@end
