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

+ (NSString *)urlStringForParams:(NSString *)params andFeedType:(FTConfigFeedType)feedType;
+ (NSString *)urlStringForSearch:(NSString *)searchTerm withCategory:(NSString *)categoryPath andFeedType:(FTConfigFeedType)feedType;

+ (void)downloadFileWithUrl:(NSString *)urlString withProgressBlock:(void (^)(CGFloat progress))progressHandler andSuccessBlock:(void (^)(id data, NSError *error))successHandler;
+ (void)downloadSingleFileWithUrl:(NSString *)urlString withProgressBlock:(void (^)(CGFloat progress))progressHandler andSuccessBlock:(void (^)(id data, NSError *error))successHandler;


@end
