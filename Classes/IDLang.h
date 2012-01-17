//
//  IDLang.h
//  iDeviant
//
//  Created by Adam Horacek on 17.01.12.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTLang.h"

#define IDLangGet(key) [IDLang get:(key)] 

@interface IDLang : FTLang

+ (NSString *)get:(NSString *)key;

@end
