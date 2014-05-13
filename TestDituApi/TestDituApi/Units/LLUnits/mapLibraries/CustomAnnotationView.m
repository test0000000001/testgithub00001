//
//  CustomAnnotationView.m
//  VideoShare
//
//  Created by dongsheng xu on 12-12-7.
//  Copyright (c) 2012年 cmmobi. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //大头针的图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.backgroundColor = [UIColor redColor];
        [imageView setImage:[UIImage imageNamed:@"datouzhen"]];
        [self addSubview:imageView];
    }
    
    return self;
}

@end
