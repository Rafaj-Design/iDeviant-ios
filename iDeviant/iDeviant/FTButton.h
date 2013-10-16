//
//  FTButton.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTButton : UIButton

- (BOOL)isRetina;
- (BOOL)isBigPhone;
- (CGFloat)screenHeight;
- (BOOL)isOS7;

- (void)setupView;
- (void)createAllElements;


@end
