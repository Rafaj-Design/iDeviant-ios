//
//  FTDetailTextViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDetailTextViewController.h"

@interface FTDetailTextViewController ()

@end

@implementation FTDetailTextViewController


#pragma mark Creating elements

- (void)createTextView {
    [self.view setBackgroundColor:[UIColor randomColor]];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTextView];
}


@end
