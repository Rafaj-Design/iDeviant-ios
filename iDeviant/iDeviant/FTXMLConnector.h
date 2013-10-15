//
//  FTXMLConnector.h
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTDADataObject.h"


typedef void(^FTXMLConnectionCompletionHandler) (NSError *error);


@interface FTXMLConnector : NSObject

@property (nonatomic, readonly) NSOperationQueue *apiOperationQueue;

+ (FTXMLConnector *)sharedConnector;

+ (void)connectWithObject:(FTDADataObject *)connectionObject andSuccessDelegate:(FTXMLConnectionCompletionHandler)success;


@end
