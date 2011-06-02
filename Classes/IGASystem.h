//
//  IGASystem.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IGASystem : NSObject {

}

+ (void)log:(NSString *)message withFunction:(char *)function andLine:(int)line;

+ (void)log:(NSString *)message withFunction:(char *)function;

+ (void)log:(NSString *)message;


@end
