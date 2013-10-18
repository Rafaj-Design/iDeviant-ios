//
//  FTStarButton.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTButton.h"


@interface FTStarButton : FTButton

@property (nonatomic) FTConfigFeedType feedType;
@property (nonatomic, strong) NSDictionary *categoryData;
@property (nonatomic, strong) NSString *fullPath;


@end
