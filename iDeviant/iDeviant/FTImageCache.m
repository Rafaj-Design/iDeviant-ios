//
//  FTImageCache.m
//
//  Created by Ondrej Rafaj on 03/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTImageCache.h"
#import "FTDownload.h"
#import "GCNetworkReachability.h"


static inline NSString *FTImageCacheDirectory() {
	static NSString *_FTImageCacheDirectory;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *cachesDirectory = [paths objectAtIndex:0];
		_FTImageCacheDirectory = [cachesDirectory stringByAppendingPathComponent:@"FTImageCache"];
	});
	return _FTImageCacheDirectory;
}

inline static NSString *keyForURL(NSURL *url) {
	return [url absoluteString];
}

static inline NSString *cachePathForKey(NSString *key) {
    return [FTDownload fileForUrlString:key andCacheLifetime:FTDownloadCacheLifetimeForever];
}

@interface FTImageCache()

@property (strong, nonatomic) NSOperationQueue *diskOperationQueue;
@property (strong, nonatomic) NSOperationQueue *downloadOperationQueue;
@property (nonatomic, strong) GCNetworkReachability *reachability;
@property (nonatomic) GCNetworkReachabilityStatus reachabilityStatus;

@end

@implementation FTImageCache


#pragma mark - Object lifecycle

+ (FTImageCache *)sharedCache {
    static FTImageCache *_sharedCache = nil;
	static dispatch_once_t onceToken;
    
	dispatch_once(&onceToken, ^{
		_sharedCache = [[FTImageCache alloc] init];
	});
    
	return _sharedCache;
}

- (id)init {
    self = [super init];
    if (self) {
        _diskOperationQueue = [[NSOperationQueue alloc] init];
        [_diskOperationQueue setMaxConcurrentOperationCount:2];
        
        _downloadOperationQueue = [[NSOperationQueue alloc] init];
        [_downloadOperationQueue setMaxConcurrentOperationCount:2];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:FTImageCacheDirectory() withIntermediateDirectories:YES attributes:nil error:NULL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        _reachability = [GCNetworkReachability reachabilityWithHostName:@"http://www.deviantart.com"];
        
        [_reachability startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status) {
            _reachabilityStatus = status;
        }];
    }
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_reachability stopMonitoringNetworkReachability];
}

- (void)didReceiveMemoryWarningNotification:(NSNotification *)notification {
    [self removeAllObjects];
}


#pragma mark - Public API / overrides

- (void)removeAllImagesOnCompletion:(void (^)(BOOL success))completionBlock {
    [self removeAllObjects];
    if ([self allowsEvictionOfPersistedImages]) {
        [self purgePersistedImageDirectoryOnCompletion:^(BOOL success) {
            if (completionBlock) completionBlock(success);
        }];
    } else {
        if (completionBlock) completionBlock(YES);
    }
}

- (void)removeImageForURL:(NSURL *)url onCompletion:(void (^)(BOOL success))completionBlock {
    [self removeObjectForKey:keyForURL(url)];
    if ([self allowsEvictionOfPersistedImages]) {
        [self removePersistedImageForKey:keyForURL(url) onCompletion:^(BOOL success) {
            if (completionBlock) completionBlock(success);
        }];
    } else {
        if (completionBlock) completionBlock(YES);
    }
}

- (void)imageForURL:(NSURL *)url success:(void (^)(UIImage *image))successBlock failure:(void (^)(NSError* error))failureBlock progress:(void (^)(CGFloat progress))progressBlock {
    
    NSString *key = keyForURL(url);
    
    if (key) {
        UIImage *cachedImage = [self cachedImageForKey:key];
        
        if (cachedImage) {
            if (successBlock) successBlock(cachedImage);
        }
        else {
            [self downloadCacheAndPersistImageForURL:url key:key success:^(UIImage *image) {
                if (successBlock) successBlock(image);
            } failure:^(NSError *error) {
                if (failureBlock) failureBlock(error);
            } progress:^(CGFloat progress) {
                if (progressBlock) progressBlock(progress);
            }];
        }
    }
}


#pragma mark - Helper methods

- (BOOL)allowsEvictionOfPersistedImages {
    switch (_evictionPolicy) {
        case FTImageCacheDiskEvictionPolicyAlwaysAllow:
            return YES;
            break;
        case FTImageCacheDiskEvictionPolicyOnlineOnly:
            return _reachabilityStatus != GCNetworkReachabilityStatusNotReachable;
            break;
        default:
            return YES;
            break;
    }
}


#pragma mark Network operations

- (void)downloadCacheAndPersistImageForURL:(NSURL *)url
                                       key:(NSString *)key
                                   success:(void (^)(UIImage *image))successBlock
                                   failure:(void (^)(NSError* error))failureBlock
                                  progress:(void (^)(CGFloat progress))progressBlock {
    
    FTDownload *imageDownload = [[FTDownload alloc] initWithURL:[url absoluteString] cacheLifetime:FTDownloadCacheLifetimeNone success:^(NSData *data) {
        UIImage *image = [UIImage imageWithData:data];
        if (image && [image isKindOfClass:[UIImage class]]) {
            [self setImage:image forKey:key];
            [self persistData:data forKey:key];
            if (successBlock) successBlock(image);
        } else {
            if (failureBlock) {
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:[NSString stringWithFormat:@"Failed to init image with data from for URL: %@", url] forKey:NSLocalizedDescriptionKey];
                NSError* error = [NSError errorWithDomain:@"FTImageCacheErrorDomain" code:1 userInfo:errorDetail];
                failureBlock(error);
            }
        }
    } failure:^(NSError *error) {
        if (failureBlock) failureBlock(error);
    } progress:^(CGFloat progress) {
        if (progressBlock) progressBlock(progress);
    }];
    [_downloadOperationQueue addOperation:imageDownload];
}


#pragma mark Cache operations

- (void) setImage:(UIImage *)image forKey:(NSString *)key {
	if (image) {
		[super setObject:image forKey:key];
	}
}

- (UIImage *)cachedImageForKey:(NSString *)key {
    UIImage *cachedImageForKey = nil;
    if (key) {
        id cachedObjectForKey = [super objectForKey:key];
        cachedImageForKey = [cachedObjectForKey isKindOfClass:[UIImage class]] ? (UIImage *)cachedObjectForKey : nil;
        if (cachedImageForKey == nil) {
            cachedImageForKey = [self persistedImageForKey:key];
            if(cachedImageForKey) [self setImage:cachedImageForKey forKey:key];
        }
    }
    return cachedImageForKey;
}


#pragma mark Disk operations

- (UIImage *)persistedImageForKey:(NSString *)key {
	UIImage *imageFromDisk = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:cachePathForKey(key) options:0 error:NULL]];
	return imageFromDisk;
}

- (void)persistData:(NSData *)data forKey:(NSString *)key {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachePath = cachePathForKey(key);
        NSInvocation *writeInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(writeData:toPath:)]];
        
        __weak NSData *weakData = data;
        
        [writeInvocation setTarget:self];
        [writeInvocation setSelector:@selector(writeData:toPath:)];
        [writeInvocation setArgument:&weakData atIndex:2];
        [writeInvocation setArgument:&cachePath atIndex:3];
        
        [self performDiskWriteOperation:writeInvocation];
    });
}

- (void)purgePersistedImageDirectoryOnCompletion:(void (^)(BOOL success))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:FTImageCacheDirectory() error:&error];
        BOOL success = NO;
        if (error == nil) {
            success = YES;
            for (NSString *path in directoryContents) {
                NSString *fullPath = [FTImageCacheDirectory() stringByAppendingPathComponent:path];
                if (![fileMgr removeItemAtPath:fullPath error:&error]) {
                    success = NO;
                    break;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) completionBlock(success);
        });
    });
}

- (void)removePersistedImageForKey:(NSString *)key onCompletion:(void (^)(BOOL success))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(key) error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) completionBlock(error == nil);
        });
    });
}

- (void)writeData:(NSData*)data toPath:(NSString *)path {
	[data writeToFile:path atomically:YES];
}

- (void)performDiskWriteOperation:(NSInvocation *)invocation {
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
	[_diskOperationQueue addOperation:operation];
}


@end
