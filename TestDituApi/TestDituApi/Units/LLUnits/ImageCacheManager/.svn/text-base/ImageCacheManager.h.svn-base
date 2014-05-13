//
//  ImageCacheManager.h
//  xFeng4
//
//  Created by 李勇 on 11-8-20.
//  Copyright 2011 cmmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (ImageCacheManager)
@property(nonatomic,strong)NSIndexPath* indexPath;

// add by Shu Peng
typedef void(^SuccessBlock)(UIImage *image);
typedef void(^FailureBlock)(NSError *error);
- (void)setImageURL:(NSURL *)url placeholderImage:(UIImage *)placeholder successBlock:(SuccessBlock)block failedBlock:(FailureBlock)block;
@end


@interface ImageCacheManager : NSObject {
	
}
+(void)setImageToButton:(NSString *)urlStr button:(UIButton *)imageButton;
+(void)setImageToButton:(NSString *)urlStr button:(UIButton *)imageButton mainBlock:(void (^)(UIImage *image))mainBlock;
+(void)setImageToTableViewImage:(NSString *)urlStr imageView:(UIImageView *)myImageView :(NSIndexPath *)indexPath;
+(void)setImageForCover:(NSString *)urlStr imageView:(UIImageView *)myImageView indexPath:(NSIndexPath*)indexPath;
+(void)setImageToImage:(NSString *)urlStr imageView:(UIImageView *)myImageView;
+(void)setImageToImageWithoutScale:(NSString *)urlStr imageView:(UIImageView *)myImageView;
+(void)setUrlToRoundedCornerImage:(NSString *)urlStr imageView:(UIImageView *)myImageView;

+(void)setUrlToRoundedCornerImage:(NSString *)urlStr imageView:(UIImageView *)myImageView cornerRadius:(float)cornerRadius;
+(void)saveImage:(NSData*)imageData withUrlStr:(NSString*)urlStr;
+(void)setImageToImage:(NSString *)urlStr mainBlock:(void (^)(UIImage* image,int delay))mainBlock;
+(UIImage*)getImageFromLocation:(NSString*)urlStr;
+(void)setImageToLocationOrURL:(NSString*)urlStr imageView:(UIImageView*)myImageView;
+(void)setImageToLeftMovieImage:(NSString *)urlStr imageView:(UIImageView *)myImageView;
+(void)addPlayImageToImageView:(UIImageView *)myImageView;
+(void)setImageToButtonBackground:(NSString *)urlStr button:(UIButton *)imageButton;
+(void)clearCache;
+(void)downloadImageAndSave:(NSString *)urlStr;
+(NSString*)getImageCachePath:(NSString *)urlStr;

// add by Shu Peng
+(void)checkImageCache;
/**
 * 功能：清除某个key下的文件
 * 参数：imgkey
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-07-18
 */
+(void)clearImgByKey:(NSString *) imgKey;

+(void)urlToLocal:(NSString*)urlStr :(void (^)(NSString *fileName))block;
@end
