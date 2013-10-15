//
//  FTXMLConnector.m
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTXMLConnector.h"
#import "AFNetworking.h"


@implementation FTXMLConnector


#pragma mark Request object

+ (NSURLRequest *)requestForDataObject:(FTDADataObject *)dataObject {
    return nil;
}

#pragma mark Connections

+ (void)connectWithObject:(FTDADataObject *)connectionObject andSuccessDelegate:(FTXMLConnectionCompletionHandler)success {
    FTXMLConnector *connector = [self sharedConnector];
}

+ (void)stopLoadingAll {
    if ([[self sharedConnector] apiOperationQueue]) {
        [[[self sharedConnector] apiOperationQueue] cancelAllOperations];
    }
}

#pragma mark Initialization

+ (FTXMLConnector *)sharedConnector {
    static FTXMLConnector *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FTXMLConnector alloc] init];
    });
    return shared;
}

- (id)init {
    self = [super init];
    if (self) {
        _apiOperationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

@end
