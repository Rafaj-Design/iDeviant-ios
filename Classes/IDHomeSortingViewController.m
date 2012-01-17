//
//  IDHomeSortingViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 23/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDHomeSortingViewController.h"
#import "IDHomeTableViewCell.h"
#import "FTSimpleDB.h"
#import "Configuration.h"


@implementation IDHomeSortingViewController


#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [super viewDidLoad];
	
	[super setData:[FTSimpleDB getItemsFromDb:kSystemHomeMenuDbName]];
	[super createTableView];
	[table setEditing:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [data count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	[FTSimpleDB moveTableItem:sourceIndexPath to:destinationIndexPath inDb:kSystemHomeMenuDbName];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    FTTableViewCell *cell = (FTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	NSDictionary *d = [data objectAtIndex:indexPath.row];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IDHomeSortCell" owner:nil options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[FTTableViewCell class]]) {
                cell = (FTTableViewCell *)oneObject;
                break;
            }
        }
		[cell.cellTitleLabel setText:[IDLang get:[d objectForKey:@"name"]].uppercaseString];
		[cell.cellTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:16]];
		
		[cell.cellDetailLabel setText:[IDLang get:[d objectForKey:@"description"]].uppercaseString];
		[cell.cellDetailLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:14]];
		
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		[cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
		
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		
		//[cell.imageView setImage:[UIImage imageNamed:[d objectForKey:@"icon"]]];
		//[cell.imageView.layer setCornerRadius:4];
		
        
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
