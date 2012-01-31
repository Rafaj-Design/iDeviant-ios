//
//  IDItemsViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDViewController.h"


@interface IDItemsViewController : IDViewController {

	NSString *predefinedSearchTerm;
	NSString *predefinedCategory;
}

@property (nonatomic, retain) NSString *predefinedSearchTerm;
@property (nonatomic, retain) NSString *predefinedCategory;

- (id)initWithSearch:(NSString *)search andCategory:(NSString *)category;
- (id)initWithSearch:(NSString *)search;
- (id)initWithCategory:(NSString *)category;

@end
