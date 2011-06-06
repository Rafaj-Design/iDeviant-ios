//
//  IDHomeController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDHomeController.h"
#import "IDLandscapeFavoritesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IDHomeTableViewCell.h"
#import "FTSimpleDB.h"
#import "Configuration.h"


@implementation IDHomeController


#pragma mark Layout

- (void)doControllerCheck {
	if (isLandscape && NO) {
		IDLandscapeFavoritesViewController *c = [[IDLandscapeFavoritesViewController alloc] init];
		[c setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self presentModalViewController:c animated:YES];
		[c release];
	}
}

#pragma mark Table view delegate method

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
		[cell.cellTitleLabel setText:[FTLang get:[d objectForKey:@"name"]].uppercaseString];
		[cell.cellTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:23]];
		
		[cell.cellDetailLabel setText:[FTLang get:[d objectForKey:@"description"]].uppercaseString];
		[cell.cellDetailLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:14]];
		
		[cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
		
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		
		[cell.iconImageView setImage:[UIImage imageNamed:[d objectForKey:@"icon"]]];
		//[cell.imageView setBackgroundColor:[UIColor clearColor]];
		[cell.imageView.layer setCornerRadius:4];
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
	NSLog(@"Data: %@", d);
	//[cell setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"bcg-cell.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:27]]];
	if ([[d objectForKey:@"requiresConnection"] boolValue] && !internetActive) {
		[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-x.png"]];
	}
	else {
		[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-white.png"]];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	NSDictionary *d = [data objectAtIndex:indexPath.section];
	if ([[d objectForKey:@"requiresConnection"] boolValue] && !internetActive) {
		[super displayMessage:@"requiresinternetconnection"];
	}
	else {
		UIViewController *c = (UIViewController *)[[NSClassFromString([d objectForKey:@"controller"]) alloc] init];
		if (c) {
			[c setTitle:[d objectForKey:@"name"]];
			[self.navigationController pushViewController:c animated:YES];
			[c release];
		}
	}
}

#pragma mark View delegate methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([FTSimpleDB getNumberOfItemsInDb:kSystemHomeMenuDbName] == 0) {
		[super getDataFromBundlePlist:@"Home.plist"];
		for (NSDictionary *d in data) {
			[FTSimpleDB addItemToBottom:d intoDb:kSystemHomeMenuDbName];
		}
	}
	else {
		[super setData:[FTSimpleDB getItemsFromDb:kSystemHomeMenuDbName]];
	}
	
	[super createTableView];
	[super setTitle:@"appname"];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fuerte-logo.png"]];
	[logo positionAtX:60 andY:-65];
	[logo setBackgroundColor:[UIColor clearColor]];
	[table addSubview:logo];
	[logo release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self doControllerCheck];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self doControllerCheck];
}

#pragma mark Table view delegate & data source methods

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	if (section == 0) {
//		UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
//		[v setBackgroundColor:[UIColor greenColor]];
//		return v;
//	}
//	else return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	return 60;
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
