//
//  IDCategoriesViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDViewController.h"

@interface IDCategoriesViewController : IDViewController {
	
	NSDictionary *currentCategory;
	NSString *currentCategoryPath;
	
}

@property (nonatomic, retain) NSDictionary *currentCategory;
@property (nonatomic, retain) NSString *currentCategoryPath;

- (void)fillWithData;

@end
