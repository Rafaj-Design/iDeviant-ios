//
//  FTDownloader.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTDownloader : NSObject

+ (FTDownloader *)sharedDownloader;

+ (void)downloadFileWithUrl:(NSString *)urlString withProgressBlock:(void (^)(CGFloat progress))progressHandler andSuccessBlock:(void (^)(NSData *data, NSError *error))successHandler;
+ (void)downloadSingleFileWithUrl:(NSString *)urlString withProgressBlock:(void (^)(CGFloat progress))progressHandler andSuccessBlock:(void (^)(NSData *data, NSError *error))successHandler;


@end
