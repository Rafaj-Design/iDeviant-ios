//
//  FTImageCache.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 03/09/2013.
//  Copyright (c) 2013 Wilson Fletcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTImageCache : NSCache

// OnlineOnly policy will not remove images persisted to disk unless the API is reachable
typedef enum _FTImageCacheDiskEvictionPolicy {
    FTImageCacheDiskEvictionPolicyAlwaysAllow,
    FTImageCacheDiskEvictionPolicyOnlineOnly
} FTImageCacheDiskEvictionPolicy;

@property (nonatomic) FTImageCacheDiskEvictionPolicy evictionPolicy;

+ (FTImageCache *)sharedCache;
- (void)imageForURL:(NSURL *)url success:(void (^)(UIImage *image))successBlock failure:(void (^)(NSError* error))failureBlock progress:(void (^)(CGFloat progress))progressBlock;
- (void)removeAllImagesOnCompletion:(void (^)(BOOL success))completionBlock;
- (void)removeImageForURL:(NSURL *)url onCompletion:(void (^)(BOOL success))completionBlock;


@end
