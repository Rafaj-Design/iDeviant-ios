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
#import "IDFavouriteCategories.h"
#import "aboutPage.h"
//#import "JCO.h"


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
	//NSLog(@"Data: %@", d);
	//[cell setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"bcg-cell.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:27]]];
	if ([[d objectForKey:@"requiresConnection"] boolValue] && !internetActive) {
		[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-x.png"]];
	}
	else {
		[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-white.png"]];
	}
    if (([[d objectForKey:@"FVRT"] boolValue]) && [[IDFavouriteCategories dataForFavorites]count]==0){
        [cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-x.png"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	NSDictionary *d = [data objectAtIndex:indexPath.section];
	if ([[d objectForKey:@"requiresConnection"] boolValue] && !internetActive) {
		[super displayMessage:@"requiresinternetconnection"];
	}
	else if (([[d objectForKey:@"FVRT"] boolValue]) && [[IDFavouriteCategories dataForFavorites]count]==0) {
        [super displayMessage:@"nonefavorites"];
    }else{
		IDViewController *c = (IDViewController *)[[NSClassFromString([d objectForKey:@"controller"]) alloc] init];
		if (c) {
			//[c inheritConnectivity:internetActive];
			[c setTitle:[d objectForKey:@"name"]];
            [self.navigationController pushViewController:c animated:YES];
			[c release];
            if ([[d objectForKey:@"requiresConnection"] boolValue]){
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            }
		}
	}
}

#pragma mark Jira reporting



- (void)initializeJiraChecks {

    self.navigationItem.rightBarButtonItem =  [[[UIBarButtonItem alloc] initWithTitle:[FTLang get:@"About"] style:UIBarButtonItemStyleBordered target:self action:@selector(showFeedback)] autorelease];
    
    
    /*
    self.navigationItem.leftBarButtonItem =
    [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showPastFeedback)] autorelease];
     */
}

-(void) showFeedback {
    aboutPage *AC = [[aboutPage alloc] initWithNibName:@"aboutPage" bundle:nil];
    [self.navigationController pushViewController:AC animated:YES];
    [AC release];
}

-(void) showPastFeedback {
    //[self presentModalViewController:[[JCO instance] issuesViewController] animated:YES];
}


#pragma mark View delegate methods

- (void)viewDidLoad {
    
    //==
	
    UIColor *color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
	UIImage *img = [UIImage imageNamed:@"DA_topbar.png"];
	[img drawInRect:CGRectMake(0, 0, 10, 10)];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
	[self.navigationController.navigationBar setTintColor:color];
	
    //==
    
    
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
	[super setTitle:@"iDeviant"];
    
	
	[self initializeJiraChecks];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self doControllerCheck];
    
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
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

-(void)viewWillDisappear:(BOOL)animated{
    [table removeSubviews];
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
