//
//  NSString+Tools.h
//
//  Created by Ondrej Rafaj on 16/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Tools)

+ (NSString *)serializeParams:(NSDictionary *)params;
+ (NSString *)stringByStrippingHTML:(NSString *)inputString;
- (NSString *)stringByTrimmingLeadingWhitespace;

+ (NSDate *)stringDateFromString:(NSString *)string;
+ (NSString *)stringDateFromDate:(NSDate *)date;


@end
