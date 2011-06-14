//
//  IGAMemTools.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IGAMemTools : NSObject {
	
}

+ (void)logMemory:(NSString *)ident;

+ (void)logMemoryInFunction:(id)function;

+ (natural_t)getAvailableMemory;

@end