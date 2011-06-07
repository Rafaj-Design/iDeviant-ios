//
//  FTImagePage.h
//  LazyLoadingTest
//
//  Created by Ondrej Rafaj on 04/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPage.h"


@interface FTImagePage : FTPage {
	
	UIImageView *imageView;
	
}

@property (nonatomic, retain) UIImageView *imageView;

- (void)imageNamed:(NSString *)imageName;

- (void)imageWithUrl:(NSURL *)url;


@end
