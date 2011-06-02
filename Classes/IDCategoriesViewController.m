//
//  IDCategoriesViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDCategoriesViewController.h"
#import "FTTableHeaderView.h"
#import "IDAdultCheck.h"
#import "IDCategoriesTableViewCell.h"
#import "IDFavouriteCategories.h"


@implementation IDCategoriesViewController

@synthesize currentCategory;
@synthesize currentCategoryPath;


#pragma mark Data

- (void)fillWithData {
	if ([categoriesData count] == 0) {
		[super getDataFromBundlePlist:@"Categories.plist"];
		categoriesData = [[NSArray alloc] initWithArray:data];
		[super setData:nil];
		
		[super setIsSearchBar:NO];
		
		currentCategoryPath = @"";
	}
	else [super setIsSearchBar:YES];
	
	
	
	[super getDataForCategory:currentCategoryPath];
}

#pragma mark View delegate methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self fillWithData];
	
	[super createTableView];
	[table reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Memory management

- (void)dealloc {
	[currentCategory release];
    [super dealloc];
}

#pragma mark Table view

- (void)configureCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
	if (indexPath.section == 0) {
		NSDictionary *d = [categoriesData objectAtIndex:indexPath.row];
		NSString *path = [currentCategoryPath stringByAppendingPathComponent:[d objectForKey:@"path"]];
		[(IDCategoriesTableViewCell *)cell setCategoryPath:path];
		[(IDCategoriesTableViewCell *)cell setCategoryData:d];
		[(IDCategoriesTableViewCell *)cell setIsFavourite:[IDFavouriteCategories isFavouriteCategory:path]];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
	if ([data count] > 0) return 2;
	else return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 1 && [data count] == 0) return nil;
	NSString *catName = [currentCategory objectForKey:@"name"];
	if (section == 0) {
		if (catName) {
			catName = [NSString stringWithFormat:@"%@%@", [FTLang get:@"subcategoriesincat"], catName];
		}
		else {
			catName = [FTLang get:@"subcategoriesinmaincat"];
		}
		return catName;
	}
	else {
		NSString *itemsName;
		if (catName) {
			itemsName = [NSString stringWithFormat:@"%@%@", [FTLang get:@"itemsincategory"], catName];
		}
		else {
			itemsName = [FTLang get:@"itemsinmaincat"];
		}
		return itemsName;
	}
}

- (void)enablingTableEdit:(BOOL)edit {
	//[table reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 1 && [data count] == 0) return nil;
	FTTableHeaderView *v = [[FTTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
	NSString *catName = [self tableView:tableView titleForHeaderInSection:section];
	[v.titleLabel setText:catName];
	[v.backgroundImageView setImage:[UIImage imageNamed:@"DA_topbar.png"]];
	return [v autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return [categoriesData count];
	if (section == 0) return [categoriesData count];
	else return [data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) return 68;
	else return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return [super tableView:tableView categoryCellForRowAtIndexPath:indexPath];
	}
	else {
		return [super tableView:tableView itemCellForRowAtIndexPath:indexPath];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		[super launchCategoryInTableView:tableView withIndexPath:indexPath andCurrentCategoryPath:currentCategoryPath];
	}
	else {
		[super launchItemInTableView:tableView withIndexPath:indexPath];
	}
}


@end
