//
//  FTDownloader.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDownloader.h"
#import "AFNetworking.h"
#import "FTFeedDownloadOperation.h"


@interface FTDownloader ()

@property (nonatomic, strong) FTFeedDownloadOperation *singleItemOperation;
@property (nonatomic, strong) NSOperationQueue *downloadOperationQueue;

@end


@implementation FTDownloader


#pragma mark Initialization

+ (FTDownloader *)sharedDownloader {
    static FTDownloader *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[FTDownloader alloc] init];
	});
	return shared;
}

- (id)init {
    self = [super init];
    if (self) {
        _downloadOperationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark Downloading

- (void)setupOperation:(FTFeedDownloadOperation *)operation forProgressBlock:(void (^)(CGFloat))progressHandler andSuccessBlock:(void (^)(NSData *, NSError *))successHandler {
    [operation setResponseSerializer:[[AFXMLParserResponseSerializer alloc] init]];
    NSMutableSet *types = [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    [types addObject:@"application/rss+xml"];
    [operation.responseSerializer setAcceptableContentTypes:types];
    if (progressHandler) {
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            progressHandler(((100.0f * totalBytesRead) * totalBytesExpectedToRead));
        }];
    }
    if (successHandler) {
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            successHandler(responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error.localizedDescription);
            successHandler(nil, error);
        }];
    }
}

- (void)downloadFileWithUrl:(NSString *)urlString withProgressBlock:(void (^)(CGFloat))progressHandler andSuccessBlock:(void (^)(NSData *, NSError *))successHandler {
    FTFeedDownloadOperation *operation = [[FTFeedDownloadOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self setupOperation:operation forProgressBlock:progressHandler andSuccessBlock:successHandler];
    [_downloadOperationQueue addOperation:operation];
}

+ (void)downloadFileWithUrl:(NSString *)urlString withProgressBlock:(void (^)(CGFloat))progressHandler andSuccessBlock:(void (^)(NSData *, NSError *))successHandler {
    [[FTDownloader sharedDownloader] downloadFileWithUrl:urlString withProgressBlock:progressHandler andSuccessBlock:successHandler];
}

- (void)downloadSingleFileWithUrl:(NSString *)urlString withProgressBlock:(void (^)(CGFloat))progressHandler andSuccessBlock:(void (^)(NSData *, NSError *))successHandler {
    if (_singleItemOperation) {
        [_singleItemOperation cancel];
        _singleItemOperation = nil;
    }
    _singleItemOperation = [[FTFeedDownloadOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self setupOperation:_singleItemOperation forProgressBlock:progressHandler andSuccessBlock:successHandler];
    [_singleItemOperation start];
}

+ (void)downloadSingleFileWithUrl:(NSString *)urlString withProgressBlock:(void (^)(CGFloat))progressHandler andSuccessBlock:(void (^)(NSData *, NSError *))successHandler {
    [[FTDownloader sharedDownloader] downloadSingleFileWithUrl:urlString withProgressBlock:progressHandler andSuccessBlock:successHandler];
}


@end
