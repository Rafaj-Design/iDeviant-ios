//
//  FTDailyDeviationsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDailyDeviationsViewController.h"


@interface FTDailyDeviationsViewController ()

@end


@implementation FTDailyDeviationsViewController


#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [super getDataForParams:@"special:dd"];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
}

#pragma mark Getters

- (FTConfigFeedType)feedType {
    return FTConfigFeedTypeNone;
}


@end
