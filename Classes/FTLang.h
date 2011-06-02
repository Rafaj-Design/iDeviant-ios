//
//  FTLang.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 14/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTLang : NSObject {
    
}

+ (NSString *)get:(NSString *)key c:(NSString *)comment;

+ (NSString *)get:(NSString *)key;

+ (void)printLanguageDebug;


@end
