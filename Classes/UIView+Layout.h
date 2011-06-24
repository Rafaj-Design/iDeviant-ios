//
//  UIView+Layout.h
//  FTLibrary
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (Layout)

- (double)width;
- (void)setWidth:(double)width;

- (double) height;
- (void)setHeight:(double)height;

- (CGSize) size;
- (void)setSize:(CGSize)size;

- (CGPoint) origin;
- (double) xPosition;
- (double) yPosition;
- (double) baselinePosition;

- (void)positionAtX:(double)xValue;
- (void)positionAtY:(double)yValue;
- (void)positionAtX:(double)xValue andY:(double)yValue;

- (void)positionAtX:(double)xValue andY:(double)yValue withWidth:(double)width;
- (void)positionAtX:(double)xValue andY:(double)yValue withHeight:(double)height;

- (void)positionAtX:(double)xValue withHeight:(double)height;

- (void)removeSubviews;

- (void)centerInSuperView;
- (void)aestheticCenterInSuperView;

- (void)bringToFront;
- (void)sendToBack;


@end
