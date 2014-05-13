//
//  ImageCacheManager.m
//  xFeng4
//
//  Created by 李勇 on 11-8-20.
//  Copyright 2011 cmmobi. All rights reserved.
//

#import "ImageCacheManager.h"
#import "ASIHTTPRequest.h"
#import "DebugLog.h"
#import "Tools.h"
#import <objc/runtime.h>
#import "LLGlobalService.h"
#import "UIImage+Resize.h"
#import "LocalResourceModel.h"
#import "ToolsUnite.h"

@implementation UIImageView (ImageCacheManager)
@dynamic indexPath;
static const char *assocKey = "UIImageView  associated object key";
- (NSIndexPath*)indexPath{
    return objc_getAssociatedObject(self, assocKey);
}
- (void) setIndexPath: (NSIndexPath*) aIndexPath
{
    objc_setAssociatedObject(self, assocKey, aIndexPath,OBJC_ASSOCIATION_RETAIN);
}

// add by Shu Peng
- (void)setImageURL:(NSURL *)url placeholderImage:(UIImage *)placeholder successBlock:(SuccessBlock)successBlock failedBlock:(FailureBlock)failedBlock
{
    __block NSString *urlStr = [url absoluteString];
    self.image = placeholder;
    if (!STR_IS_NIL(urlStr)) {
        
        // 如果是本地文件，立即返回。
        if ([urlStr hasPrefix:@"file://"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:[url path]];
            self.image = image;
            
            if (successBlock) {
                successBlock(image);
            }
            return;
        }
        
        // 如果缓存容量大于50，则以前的缓存全清空。作者只清空了字典，但是文件并没有清空？
        [ImageCacheManager  checkImageCache];
        
        
        // 判断是否已经缓存，为什么不是判断文件夹中是否包含该文件名？而是通过字典？
        UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
        if (imageCache) {
            // 获取到的 image
            self.image = imageCache;
            
            if (successBlock) {
                successBlock(imageCache);
            }
        }
        // 如果没有缓存
        else
        {
            // 在全局队列中异步执行下载任务
            self.image = placeholder;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *filePath = [document stringByAppendingPathComponent:[ImageCacheManager getImageCachePath:nil]];
                // 需要替换URL中的"/"字符, 因为要保存为文件名
                NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:filePath]) {
                    NSError *error;
                    if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                        debug_NSLog(@"%@",[error localizedDescription]);
                    };
                }
                UIImage *image = nil;
                
                // 检查路径中是否包含该文件名
                if (![fileManager fileExistsAtPath:fileName]) {
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                    [request setTimeOutSeconds:300];
                    
                    // 利用ASIHTTPRequest同步执行下载任务
                    [request startSynchronous];
                    NSData *imageData = [request responseData];
                    
                    // 如果下载并解析成功，则写入文件
                    if (imageData) {
                        image = [UIImage imageWithData:imageData];
                        if (image) {
                            [imageData writeToFile:fileName atomically:YES];
                        }
                    }
                    
                }
                // 在路径中没有找到该文件名
                else
                    image = [[UIImage alloc] initWithContentsOfFile:fileName];
                
                // 在Main Thread中执行Block，
                // 如果文件已找到，或已经下载成功则执行Success， 否则为Failed
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                        // 原始 image
                        UIImageView *originImageView = [[UIImageView alloc] initWithFrame:self.frame];
                        originImageView.image = self.image;
                        [self.superview insertSubview:originImageView belowSubview:self];
                        
                        // 获取到的 image
                        self.image = image;
                        self.alpha = 0;
                        
                        [UIView animateWithDuration:0.4 animations:^{
                            originImageView.alpha = 0;
                            self.alpha = 1;
                        } completion:^(BOOL finished) {
                            [originImageView removeFromSuperview];
                        }];
                        
                        if (successBlock) {
                            successBlock(image);
                        }
                    }
                    else{
                        if (failedBlock) {
                            failedBlock([NSError errorWithDomain:@"INVALID_DOMAIN" code:-2 userInfo:@{@"errorDescription": @"文件下载错误"}]);
                        }
                    }
                });
            });
        }
        
    }
    else
    {
        if (failedBlock) {
            failedBlock([NSError errorWithDomain:@"INVALID_DOMAIN" code:-1 userInfo:@{@"errorDescription": @"无效URL"}]);
        }
    }
}
@end

@implementation ImageCacheManager
static NSString *imageCacheFilePath = @"imageCache";
static NSString *document;

+(void)getDocumentsPath{
	if (document == nil) {
		document =  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	}
}
+(void)addPlayImageToImageView:(UIImageView *)myImageView{
	UIImageView *playImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bf_k.png"]];
	playImage.frame = myImageView.bounds;
	playImage.tag = 1001;
	[myImageView addSubview:playImage];
}


+(void)setImageToTableViewImage:(NSString *)urlStr imageView:(UIImageView *)myImageView:(NSIndexPath *)indexPath{
    NSIndexPath* indexPathOld = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    if (!STR_IS_NIL(urlStr)) {
        [ImageCacheManager checkImageCache];
        UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
        if(!imageCache || ![urlStr hasPrefix:@"http"]){
            imageCache = [[UIImage alloc] initWithContentsOfFile:urlStr];
        }
        
        if (imageCache) {
            myImageView.image = imageCache;
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (document == nil) {
                    [ImageCacheManager getDocumentsPath];
                }
                NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
                NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:filePath]) {
                    NSError *error;
                    if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                        debug_NSLog(@"%@",[error localizedDescription]);
                    };
                }
                UIImage *image = nil;
                if (![fileManager fileExistsAtPath:fileName]) {
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                    [request setTimeOutSeconds:300];
                    
                    [request startSynchronous];
                    NSData *imageData = [request responseData];
                    
                    if (imageData) {
                        image = [UIImage imageWithData:imageData];
                        if (image) {
                            [imageData writeToFile:fileName atomically:YES];
                        }
                    }
                    
                    //[imageData release];
                }
                else
                    image = [[UIImage alloc] initWithContentsOfFile:fileName];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        if (myImageView.indexPath && myImageView.indexPath.row == indexPathOld.row && myImageView.indexPath.section == indexPathOld.section) {
                            myImageView.image = image;
                        }
                        @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                    }
                });
            });
        }
    }
}

+(void)setImageToLocationOrURL:(NSString *)urlStr imageView:(UIImageView *)myImageView{
    if ([urlStr hasPrefix:@"file://"]) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSURL URLWithString:urlStr]path]];
        myImageView.image = image;
        return;
    }else{
        [ImageCacheManager setImageToImage:urlStr imageView:myImageView];
    }
}
+(UIImage*)getImageFromLocation:(NSString*)urlStr{
    UIImage *image = nil;
    if ([urlStr hasPrefix:@"http:"]) {
        if (document == nil) {
            [ImageCacheManager getDocumentsPath];
        }
        NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
        NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            NSError *error;
            if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
            };
        }
        if ([fileManager fileExistsAtPath:fileName]) {
            image = [[UIImage alloc] initWithContentsOfFile:UN_NIL(fileName)];
            if (OBJ_IS_NIL(image)) {
                image = [[UIImage alloc] initWithContentsOfFile:UN_NIL(urlStr)];
            }
        }
    }
    return image;
}

+(void)setImageForCover:(NSString *)urlStr imageView:(UIImageView *)myImageView indexPath:(NSIndexPath*)indexPath{
    if (!STR_IS_NIL(urlStr)) {
        NSIndexPath* indexPathOld = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        __block UIImage *image = nil;
        [ImageCacheManager checkImageCache];
        UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
        if (imageCache) {
            myImageView.image = imageCache;
        }
        else
        {
            [ImageCacheManager urlToLocal:urlStr :^(NSString* filename)
             {
                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                     image = [[UIImage alloc] initWithContentsOfFile:UN_NIL(filename)];
                     if (OBJ_IS_NIL(image)) {
                         image = [[UIImage alloc] initWithContentsOfFile:UN_NIL(urlStr)];
                     }
                     if (!OBJ_IS_NIL(image)) {
                         if (image.size.width > 200) {
                             //[Tools saveImage:image :[[LocalResourceModel getFrontCoverPath] stringByAppendingFormat:@"test1.png"]];
                             image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(200, 0 ) interpolationQuality:kCGInterpolationDefault];
                             //[Tools saveImage:image :[[LocalResourceModel getFrontCoverPath] stringByAppendingFormat:@"test.png"]];
                         }
                         if(image){
                             @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                             if (myImageView.indexPath && myImageView.indexPath.row == indexPathOld.row && myImageView.indexPath.section == indexPathOld.section) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     myImageView.image = image;
                                 });
                             }
                         }
                         
                     }
                     
                 });
             }];
        }
    }
}

+(void)setImageToImage:(NSString *)urlStr imageView:(UIImageView *)myImageView{
    if (!STR_IS_NIL(urlStr)) {
        __block UIImage *image = nil;
        [ImageCacheManager checkImageCache];
        UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
        if (imageCache) {
            myImageView.image = imageCache;
        }
        else
        {
            [ImageCacheManager urlToLocal:urlStr :^(NSString* filename)
             {
                 image = [[UIImage alloc] initWithContentsOfFile:UN_NIL(filename)];
                 if (OBJ_IS_NIL(image)) {
                     image = [[UIImage alloc] initWithContentsOfFile:UN_NIL(urlStr)];
                 }
                 if (!OBJ_IS_NIL(image)) {
                     if (image.size.width > 200) {
                         //[Tools saveImage:image :[[LocalResourceModel getFrontCoverPath] stringByAppendingFormat:@"test1.png"]];
                         image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(200, 0 ) interpolationQuality:kCGInterpolationDefault];
                         //[Tools saveImage:image :[[LocalResourceModel getFrontCoverPath] stringByAppendingFormat:@"test.png"]];
                     }
                     if(image){
                         myImageView.image = image;
                         @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                     }
                     
                 }
             }];
        }
    }
}

+(void)setImageToImageWithoutScale:(NSString *)urlStr imageView:(UIImageView *)myImageView{
    if (!STR_IS_NIL(urlStr)) {
        __block UIImage *image = nil;
        [ImageCacheManager checkImageCache];
//        UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
        UIImage* imageCache = nil;
        if (imageCache) {
            myImageView.image = imageCache;
        }
        else
        {
            [ImageCacheManager urlToLocal:urlStr :^(NSString* filename)
             {
                 if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                     image = [[UIImage alloc] initWithContentsOfFile:UN_NIL(filename)];
                 }
                 if (OBJ_IS_NIL(image)) {
                     if ([[NSFileManager defaultManager] fileExistsAtPath:urlStr]) {
                         image = [[UIImage alloc] initWithContentsOfFile:UN_NIL(urlStr)];
                     }
                 }
                 if (!OBJ_IS_NIL(image)) {
                     if(image){
                         //xpg change.
#if !(TARGET_IPHONE_SIMULATOR)
                         myImageView.image = [ToolsUnite zoomImageToScreen:image];
#else
                         myImageView.image = image;
#endif
//                         @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                     }
                     
                 }
             }];
        }
    }
}


+(void)setUrlToRoundedCornerImage:(NSString *)urlStr imageView:(UIImageView *)myImageView{
    [ImageCacheManager checkImageCache];
    UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
    if (imageCache) {
        myImageView.image = imageCache;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (document == nil) {
                [ImageCacheManager getDocumentsPath];
            }
            NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
            NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                NSError *error;
                if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                    debug_NSLog(@"%@",[error localizedDescription]);
                };
            }
            UIImage *image = nil;
            if (![fileManager fileExistsAtPath:fileName]) {
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [request setTimeOutSeconds:300];
                
                [request startSynchronous];
                NSData *imageData = [request responseData];
                
                if (imageData) {
                    image = [UIImage imageWithData:imageData];
                    image = [Tools createRoundedCornerImageWithoutBorder:image :image.size.width/40.0f ];
                    if (image) {
                        NSData *imageData = UIImagePNGRepresentation(image);
                        [imageData writeToFile:fileName atomically:YES];
                    }
                }
                
                //[imageData release];
            }
            else
                image = [[UIImage alloc] initWithContentsOfFile:fileName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    myImageView.image = image;
                    @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                }
            });
        });
    }
    
}

+(void)setUrlToRoundedCornerImage:(NSString *)urlStr imageView:(UIImageView *)myImageView cornerRadius:(float)cornerRadius{
    [ImageCacheManager checkImageCache];
    UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
    if (imageCache) {
        myImageView.image = imageCache;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (document == nil) {
                [ImageCacheManager getDocumentsPath];
            }
            NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
            NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                NSError *error;
                if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                    debug_NSLog(@"%@",[error localizedDescription]);
                };
            }
            UIImage *image = nil;
            if (![fileManager fileExistsAtPath:fileName]) {
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [request setTimeOutSeconds:300];
                
                [request startSynchronous];
                NSData *imageData = [request responseData];
                
                if (imageData) {
                    image = [UIImage imageWithData:imageData];
                    image = [Tools createRoundedCornerImageWithoutBorder:image :image.size.width/cornerRadius];
                    if (image) {
                        NSData *imageData = UIImagePNGRepresentation(image);
                        [imageData writeToFile:fileName atomically:YES];
                    }
                }
                
                //[imageData release];
            }
            else
                image = [[UIImage alloc] initWithContentsOfFile:fileName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    myImageView.image = image;
                    @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                }
            });
        });
    }
    
}


+(void)setImageToImage:(NSString *)urlStr mainBlock:(void (^)(UIImage* image,int delay))mainBlock{
    if (!STR_IS_NIL(urlStr)) {
        [ImageCacheManager checkImageCache];
        UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
        if (imageCache) {
            mainBlock(imageCache,0);
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (document == nil) {
                    [ImageCacheManager getDocumentsPath];
                }
                NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
                NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:filePath]) {
                    NSError *error;
                    if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                        debug_NSLog(@"%@",[error localizedDescription]);
                    };
                }
                UIImage *image = nil;
                if (![fileManager fileExistsAtPath:fileName]) {
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                    [request setTimeOutSeconds:300];
                    
                    [request startSynchronous];
                    NSData *imageData = [request responseData];
                    
                    if (imageData) {
                        image = [UIImage imageWithData:imageData];
                        if (image) {
                            [imageData writeToFile:fileName atomically:YES];
                        }
                    }
                    
                    //[imageData release];
                }
                else
                    image = [[UIImage alloc] initWithContentsOfFile:fileName];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                    }
                    mainBlock(image,1);
                });
            });
        }
        
    }
    else
    {
        mainBlock(nil,0);
    }
    
}



+(void)saveImage:(NSData*)imageData withUrlStr:(NSString*)urlStr{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (document == nil) {
            [ImageCacheManager getDocumentsPath];
        }
        NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
        NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            NSError *error;
            if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                debug_NSLog(@"%@",[error localizedDescription]);
            };
        }
        if (![fileManager fileExistsAtPath:fileName]) {
            [imageData writeToFile:fileName atomically:YES];
        }
    });
    
}

+(void)downloadImageAndSave:(NSString *)urlStr{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (document == nil) {
            [ImageCacheManager getDocumentsPath];
        }
        NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
        NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            NSError *error;
            if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                debug_NSLog(@"%@",[error localizedDescription]);
            };
        }
        UIImage *image = nil;
        if (![fileManager fileExistsAtPath:fileName]) {
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [request setTimeOutSeconds:300];
            
            [request startSynchronous];
		    NSData *imageData = [request responseData];
            
            if (imageData) {
                image = [UIImage imageWithData:imageData];
                if (image) {
                    [imageData writeToFile:fileName atomically:YES];
                }
            }
            
            //[imageData release];
        }
    });
}

+(NSString*)getImageCachePath:(NSString *)urlStr{
    if (document == nil) {
		[ImageCacheManager getDocumentsPath];
	}
	NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
	NSString *localCachePath = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
    return localCachePath;
}

+(void)setImageToLeftMovieImage:(NSString *)urlStr imageView:(UIImageView *)myImageView{
    [ImageCacheManager checkImageCache];
    UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
    if (imageCache) {
        myImageView.image = imageCache;
    }
    else
    {
        if (document == nil) {
            [ImageCacheManager getDocumentsPath];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
            NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                NSError *error;
                if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                    debug_NSLog(@"%@",[error localizedDescription]);
                };
            }
            UIImage *image = nil;
            if (![fileManager fileExistsAtPath:fileName]) {
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [request setTimeOutSeconds:300];
                [request startSynchronous];
                NSData *imageData = [request responseData];
                if (imageData) {
                    image = [UIImage imageWithData:imageData];
                    if (image) {
                        [imageData writeToFile:fileName atomically:YES];
                    }
                }
                //[imageData release];
            }
            else
                image = [[UIImage alloc] initWithContentsOfFile:fileName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    myImageView.image = image;
                    @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                }
            });
        });
    }
    
    
}

+(void)setImageToButton:(NSString *)urlStr button:(UIButton *)imageButton{
    [ImageCacheManager checkImageCache];
    UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
    if (imageCache) {
        [imageButton setImage:imageCache forState:UIControlStateNormal];
    }
    else
    {
        if (document == nil) {
            [ImageCacheManager getDocumentsPath];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
            NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                NSError *error;
                if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                    debug_NSLog(@"%@",[error localizedDescription]);
                };
            }
            UIImage *image = nil;
            if (![fileManager fileExistsAtPath:fileName]) {
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [request setTimeOutSeconds:300];
                [request startSynchronous];
                NSData *imageData = [request responseData];
                if (imageData) {
                    image = [UIImage imageWithData:imageData];
                    if (image) {
                        [imageData writeToFile:fileName atomically:YES];
                    }
                }
                //[imageData release];
            }
            else
                image = [[UIImage alloc] initWithContentsOfFile:fileName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    [imageButton setImage:image forState:UIControlStateNormal];
                    @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                }
            });
        });
        
    }
    
}

+(void)setImageToButton:(NSString *)urlStr button:(UIButton *)imageButton mainBlock:(void (^)(UIImage *image))mainBlock{
    [ImageCacheManager checkImageCache];
    UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
    if (imageCache) {
        [imageButton setImage:imageCache forState:UIControlStateNormal];
        mainBlock(imageCache);
    }
    else
    {
        if (document == nil) {
            [ImageCacheManager getDocumentsPath];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
            NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                NSError *error;
                if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                    debug_NSLog(@"%@",[error localizedDescription]);
                };
            }
            UIImage *image = nil;
            if (![fileManager fileExistsAtPath:fileName]) {
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [request setTimeOutSeconds:300];
                [request startSynchronous];
                NSData *imageData = [request responseData];
                if (imageData) {
                    image = [UIImage imageWithData:imageData];
                    if (image) {
                        [imageData writeToFile:fileName atomically:YES];
                    }
                }
                //[imageData release];
            }
            else
                image = [[UIImage alloc] initWithContentsOfFile:fileName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    [imageButton setImage:image forState:UIControlStateNormal];
                    @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                }
                mainBlock(image);
            });
        });
        
    }
    
}

+(void)setImageToButtonBackground:(NSString *)urlStr button:(UIButton *)imageButton{
    [ImageCacheManager checkImageCache];
    UIImage* imageCache = [[LLGlobalService sharedLLGlobalService].imageCacheDic objectForKey:urlStr];
    if (imageCache) {
        [imageButton setBackgroundImage:imageCache forState:UIControlStateNormal];
    }
    else
    {
        if (document == nil) {
            [ImageCacheManager getDocumentsPath];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
            NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                NSError *error;
                if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                    debug_NSLog(@"%@",[error localizedDescription]);
                };
            }
            UIImage *image = nil;
            if (![fileManager fileExistsAtPath:fileName]) {
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [request setTimeOutSeconds:300];
                [request startSynchronous];
                NSData *imageData = [request responseData];
                if (imageData) {
                    image = [UIImage imageWithData:imageData];
                    if (image) {
                        [imageData writeToFile:fileName atomically:YES];
                    }
                }
                //[imageData release];
            }
            else
                image = [[UIImage alloc] initWithContentsOfFile:fileName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    [imageButton setBackgroundImage:image forState:UIControlStateNormal];
                    @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){[[LLGlobalService sharedLLGlobalService].imageCacheDic setValue:image forKey:urlStr];}
                }
            });
        });
    }
}

+(void)clearCache{
	if (document == nil) {
		[ImageCacheManager getDocumentsPath];
	}
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSError *error;
		if (![fileManager removeItemAtPath:filePath error:&error]) {
			debug_NSLog(@"remove cache error:%@",[error localizedDescription]);
		};
	});
}

+(void)checkImageCache
{
    @try {
        @synchronized([LLGlobalService sharedLLGlobalService].imageCacheDic){
            if ([[[LLGlobalService sharedLLGlobalService].imageCacheDic allKeys] count] > 50) {
                [[LLGlobalService sharedLLGlobalService].imageCacheDic removeAllObjects];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

/**
 * 功能：清除某个key下的文件
 * 参数：imgkey
 * 返回值：空
 
 * 创建者：capry chen
 * 创建日期：2013-07-18
 */
+(void)clearImgByKey:(NSString *) imgKey
{
    [[LLGlobalService sharedLLGlobalService].imageCacheDic removeObjectForKey:imgKey];
}

+(void)urlToLocal:(NSString*)urlStr :(void (^)(NSString *fileName))block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        __block BOOL result = NO;
        if ([urlStr hasPrefix:@"http:"]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (document == nil) {
                    [ImageCacheManager getDocumentsPath];
                }
                NSString *filePath = [ document stringByAppendingPathComponent:imageCacheFilePath];
                NSString *fileName = [filePath stringByAppendingPathComponent:[urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""]] ;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:filePath]) {
                    NSError *error;
                    if (![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                    };
                }
                UIImage *image = nil;
                if (![fileManager fileExistsAtPath:fileName]) {
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
                    [request setTimeOutSeconds:300];
                    
                    [request startSynchronous];
                    NSData *imageData = [request responseData];
                    if (imageData) {
                        image = [UIImage imageWithData:imageData];
                        if (image) {
                            [imageData writeToFile:fileName atomically:YES];
                            result = YES;
                        }
                    }
                }
                else
                {
                    result = YES;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(result == YES? fileName:@"");
                });
            });
        }
        else
        {
            block(@"");
        }

    });
}
@end
