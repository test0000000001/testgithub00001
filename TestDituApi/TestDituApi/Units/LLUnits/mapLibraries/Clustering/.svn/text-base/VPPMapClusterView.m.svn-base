//
//  VPPMapClusterView.m
//  VideoShare
//
//  Created by xu dongsheng on 13-2-21.
//  Copyright (c) 2013年 cmmobi. All rights reserved.
//

#import "VPPMapClusterView.h"
#import "VPPMapCluster.h"
#import <QuartzCore/QuartzCore.h>

@implementation VPPMapClusterView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier annStyle:(ANNOTATION_STYLE)annStyle{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        NSString* imageName = @"3_pin";
//        if(annStyle == ANNOTATION_RED){
//          imageName = @"fujin";
//        }else if(annStyle == ANNOTATION_STAR){
//          imageName = @"me_with_count";
//        }
        self.image = [UIImage imageNamed:imageName];
        self.frame = CGRectMake(0, 0, 25,33);
        _label = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 14, 12)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:11];
        _label.textAlignment = UITextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}


- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.image = [UIImage imageNamed:@"pin"];
        self.frame = CGRectMake(0, 0, 25,33);
        _label = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 14, 12)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:11];
        _label.textAlignment = UITextAlignmentCenter;
        [self addSubview:_label];
    }
    
    return self;
}


- (void) setTitle:(NSString *)title {
    if(title.length > 2){
        _label.textAlignment = UITextAlignmentLeft;
        _label.font = [UIFont boldSystemFontOfSize:8];
    }else{
        _label.textAlignment = UITextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:11];
    }
    _label.text = title;
}

- (NSString *) title {
    return _label.text;
}

@end