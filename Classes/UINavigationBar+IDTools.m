//
//  UINavigationBar+IDTools.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 14/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "UINavigationBar+IDTools.h"


@implementation UINavigationBar (UINavigationBar_IDTools)

- (void)drawRect:(CGRect)rect {
	UIColor *color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
	UIImage *img = [UIImage imageNamed:@"DA_topbar.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[self setTintColor:color];
}

@end
