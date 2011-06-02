//
//  IDJustItemsViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 28/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDItemsViewController.h"


@interface IDJustItemsViewController : IDItemsViewController {
    
	NSString *justCategory;
	
	NSString *justGallery;
	
	NSString *justSearch;
	
}

@property (nonatomic, retain) NSString *justCategory;

@property (nonatomic, retain) NSString *justGallery;

@property (nonatomic, retain) NSString *justSearch;


@end
