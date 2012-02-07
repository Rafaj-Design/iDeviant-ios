//
//  IDFavoritesController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDFavoritesController.h"
#import "IDFavouriteCategories.h"
#import "IDJustItemsViewController.h"
#import "IDAdultCheck.h"
#import "IDImageDetailViewController.h"


@implementation IDFavoritesController

#pragma mark Data

- (void)fillWithData {
	[categoriesData release];
	categoriesData = [IDFavouriteCategories dataForFavorites];
	[categoriesData retain];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"favorites"];
//	
//	[super enableRefreshButton];
	[super enableEditButton];
//	[super getDataForSearchString:@"nude"];
	
	//IDFavoriteCategoriesTableViewCell
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Table view delegate methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		if ([categoriesData count] > 0) return [IDLang get:@"myfavoritecategories"];
	}
	else {
		if ([data count] > 0) return [IDLang get:@"myfavoriteitems"];
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [super tableView:tableView categoryCellForRowAtIndexPath:indexPath withNibFile:@"IDFavoriteCategoriesTableViewCell"];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView beginUpdates];
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (indexPath.section == 0) {
			NSDictionary *d = [categoriesData objectAtIndex:indexPath.row];
			[IDFavouriteCategories toggleIsFavouriteCategory:[d objectForKey:@"fullPath"] withCategoryData:d];
		}
		[self fillWithData];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	[tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
		if (internetActive) {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			NSDictionary *d = [categoriesData objectAtIndex:indexPath.row];
			IDJustItemsViewController *c = [[IDJustItemsViewController alloc] init];
			[c inheritConnectivity:internetActive];
			[c setJustCategory:[d objectForKey:@"fullPath"]];
			[c setTitle:[d objectForKey:@"name"]];
			[self.navigationController pushViewController:c animated:YES];
			[c release];
		}
		else {
			[super displayMessage:@"requiresinternetconnection"];
		}
	}
	else {
		MWFeedItem *item = [data objectAtIndex:indexPath.row];
		BOOL canAccess = YES;
		if ([item.rating isEqualToString:@"adult"]) {
			if (![IDAdultCheck canAccessAdultStuff]) canAccess = NO;
		}
		if (canAccess) {
			if ([item.contents count] > 0) {
//				NSLog(@"Contents: %@", item.contents);
				IDImageDetailViewController *c = [[IDImageDetailViewController alloc] init];
				[c inheritConnectivity:internetActive];
				[c setImageUrl:[[item.thumbnails objectAtIndex:0] objectForKey:@"url"]];
				[self.navigationController pushViewController:c animated:YES];
				[c release];
			}
		}
		else {
			
		}
	}
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
