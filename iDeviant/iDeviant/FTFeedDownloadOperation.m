//
//  FTFeedDownloadOperation.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTFeedDownloadOperation.h"


@implementation FTFeedDownloadOperation


#pragma mark Operation settings

+ (NSSet *)acceptableContentTypes {
    NSMutableSet *types = [NSMutableSet set];
    [types addObject:@"application/rss+xml"];
    [types addObject:@"application/xhtml+xml"];
    [types addObject:@"text/xml"];
    [types addObject:@"application/xml"];
    [types addObject:@"text/html"];
    return types;
}


@end
