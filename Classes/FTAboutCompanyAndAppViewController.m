//
//  FTAboutCompanyAndAppViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 24/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAboutCompanyAndAppViewController.h"
#import "FTAboutHeaderView.h"
#import "IDHomeTableViewCell.h"


@implementation FTAboutCompanyAndAppViewController

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[super getDataFromBundlePlist:@"About.plist"];
	[super createTableView];
}

- (void)doLayoutSubviews {
	[table reloadData];
}

#pragma mark Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 83;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSString *imgName = @"";
	if (isLandscape) imgName = @"";
	return [[[[FTAboutHeaderView alloc] initWithImage:[UIImage imageNamed:imgName]] autorelease] frame].size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section != 0 || isLandscape) return nil;
	NSString *imgName = @"";
	if (isLandscape) imgName = @"";
	return [[[FTAboutHeaderView alloc] initWithImage:[UIImage imageNamed:imgName]] autorelease];
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
		//[cell.imageView setBackgroundColor:[UIColor clearColor]];
		[cell.imageView.layer setCornerRadius:4];
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
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
		
	}
}


@end
