//
//  IDSearchController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDSearchController.h"
#import "FTLang.h"

@implementation IDSearchController


#pragma mark View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[super setIsSearchBar:YES];
	
	[self setTitle:[FTLang get:@"search"]];
	
	//[super enableRefreshButton];
	//[super getDataForSearchString:@"poem"];
	
	//[super setData:[NSArray arrayWithObject:@""]];
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        [super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-empty-p@2x.png"]];
    }
    else{
        [super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-empty-l@2x.png"]];
    }
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    [imageView setImage:[UIImage imageNamed:@"search_anim_1@2x.png"]];
    [self.view addSubview:imageView];
    
    [ai setCenter:CGPointMake(self.view.center.x, self.view.center.y-50)];
}

-(void)viewWillAppear:(BOOL)animated{
    background = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                  target:self
                                                selector:@selector(backgroundImage)
                                                userInfo:nil
                                                 repeats:NO];
    [imageView setCenter:self.view.center];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    //[background invalidate];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    
    [super viewDidAppear:animated];
}

-(void)backgroundImage{
    NSLog(@"set background image");
    [self internetActive];
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        if (internetActive) {
            [super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-empty-p@2x.png"]];
            
        } 
        else{
            [super enableBackgroundWithImage:[UIImage imageNamed:@"DD_grandma@2x.png"]];
            
        }
    }
    else{
        if (internetActive) {
            [super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-empty-l@2x.png"]];
            
        }
        else{
            [super enableBackgroundWithImage:[UIImage imageNamed:@"DD_grandma@2x.png"]];
            
        }
    }
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [ai setCenter:self.view.center];
    [imageView setCenter:self.view.center];
    [self backgroundImage];
}



#pragma mark Table delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([data count] > 0) {
		return [super tableView:tableView heightForRowAtIndexPath:indexPath];
	}
	else {
        if (isLandscape) return 217;
		else return 372;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [data count];
	if (count == 0) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setScrollEnabled:FALSE];
        [imageView setHidden:NO];
    }
    else{
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [tableView setScrollEnabled:TRUE];
        [imageView setHidden:YES];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([data count] > 0) {
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
	else {
		static NSString *cellIdentifier = @"EmptyCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
		}
        
		return cell;
	}
}

- (void)doLayoutSubviews {
	[table reloadData];
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
