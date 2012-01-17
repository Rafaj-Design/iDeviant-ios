//
//  IDLang.m
//  iDeviant
//
//  Created by Adam Horacek on 17.01.12.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "IDLang.h"

@implementation IDLang

+ (NSString *)get:(NSString *)key {
    return NSLocalizedString(key, @"");
}

@end
