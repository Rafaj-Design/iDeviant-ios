//
//  NSString+Tools.m
//
//  Created by Ondrej Rafaj on 16/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "NSString+Tools.h"


@implementation NSString (Tools)

+ (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [params keyEnumerator]) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            for (NSString *subKey in value) {
                NSString *escaped = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[value objectForKey:subKey], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, escaped]];
            }
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            for (NSString *subValue in value) {
                NSString *escaped = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)subValue, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, escaped]];
            }
        }
        else {
            NSString *escaped = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[params objectForKey:key], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped]];
        }
    }
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)stringByStrippingHTML:(NSString *)inputString {
    NSMutableString *outString;
    if (inputString) {
        outString = [[NSMutableString alloc] initWithString:inputString];
        if ([inputString length] > 0) {
            NSRange r;
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
                [outString deleteCharactersInRange:r];
            }      
        }
    }
    return outString; 
}

- (NSString *)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;
    while ((i < [self length]) && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}


@end
