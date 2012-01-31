//
//  IDHomeController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDHomeController.h"
#import <QuartzCore/QuartzCore.h>
#import "IDHomeTableViewCell.h"
#import "FTSimpleDB.h"
#import "IDConfig.h"
#import "IDFavouriteCategories.h"

@implementation IDHomeController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    UIColor *color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
	UIImage *img = [UIImage imageNamed:@"DA_topbar.png"];
	[img drawInRect:CGRectMake(0, 0, 10, 10)];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setTintColor:color];
	
	if ([FTSimpleDB getNumberOfItemsInDb:kSystemHomeMenuDbName] == 0) {
		[super getDataFromBundlePlist:@"Home.plist"];
		for (NSDictionary *d in data) {
			[FTSimpleDB addItemToBottom:d intoDb:kSystemHomeMenuDbName];
		}
	} else
		[super setData:[FTSimpleDB getItemsFromDb:kSystemHomeMenuDbName]];
	
	[super createTableView];
	[super setTitle:@"iDeviant"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuerte-logo.png"]];
	
    [logo positionAtX:self.view.center.x-100 andY:-65];  
    
	[logo setBackgroundColor:[UIColor clearColor]];
    
    [table addSubview:logo];
	[logo release];
    
    if (YES) {
		[super setData:[FTSimpleDB getItemsFromDb:kSystemHomeMenuDbName]];
		[table reloadData];
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [table removeSubviews];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuerte-logo.png"]];
	
    [logo positionAtX:self.view.center.x-100 andY:-65];  
    
	[logo setBackgroundColor:[UIColor clearColor]];
    
    [table addSubview:logo];
	[logo release];
    
    if (YES) {
		[super setData:[FTSimpleDB getItemsFromDb:kSystemHomeMenuDbName]];
		[table reloadData];
	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    IDHomeTableViewCell *cell = (IDHomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	NSDictionary *d = [data objectAtIndex:indexPath.section];
	
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IDHomeTableViewCell" owner:nil options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[IDHomeTableViewCell class]]) {
                cell = (IDHomeTableViewCell *)oneObject;
                break;
            }
        }
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		[cell.cellTitleLabel setText:[IDLang get:[d objectForKey:@"name"]].uppercaseString];
		[cell.cellTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:23]];
		
		[cell.cellDetailLabel setText:[IDLang get:[d objectForKey:@"description"]].uppercaseString];
		[cell.cellDetailLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:14]];
		
		[cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
		
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		
		[cell.iconImageView setImage:[UIImage imageNamed:[d objectForKey:@"icon"]]];
		[cell.imageView.layer setCornerRadius:4];
    }
	
	[cell setBackgroundColor:[UIColor clearColor]];
	
	if ([[d objectForKey:@"requiresConnection"] boolValue] && !internetActive) {
		[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-x.png"]];
	}
	else {
		[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-white.png"]];
	}
    if (([[d objectForKey:@"FVRT"] boolValue]) && [[IDFavouriteCategories dataForFavorites]count]==0){
        [cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-x.png"]];
    }
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
		[cell.background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_shade-land"]]];
	else {
		[cell.background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_shade"]]];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	
	NSDictionary *d = [data objectAtIndex:indexPath.section];
	if ([[d objectForKey:@"requiresConnection"] boolValue] && !internetActive)
		[super displayMessage:@"requiresinternetconnection"];
	else if (([[d objectForKey:@"FVRT"] boolValue]) && [[IDFavouriteCategories dataForFavorites]count]==0)
        [super displayMessage:IDLangGet(@"nonefavorites")];
    else {
		IDViewController *c = (IDViewController *)[[NSClassFromString([d objectForKey:@"controller"]) alloc] init];
		if (c) {
			[c inheritConnectivity:internetActive];
			
			if ([[d objectForKey:@"controller"] isEqualToString:@"IDCategoriesViewController"])
				if (!internetActive)
					[super displayMessage:@"requiresinternetconnection"];
			
			[c setTitle:[d objectForKey:@"name"]];
            [self.navigationController pushViewController:c animated:YES];
			[c release];
            if ([[d objectForKey:@"requiresConnection"] boolValue])
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		}
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
