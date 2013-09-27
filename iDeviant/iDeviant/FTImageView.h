//
//  FTImageView.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTImageView : UIImageView

@property (nonatomic, strong) NSString *urlString;

- (id)initWithDefaultImage:(UIImage *)image andUrlString:(NSString *)urlString;


@end
