//
//  IDHorizontalItems.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDHorizontalItems.h"
#import "FTHorizontalTableViewCell.h"


@implementation IDHorizontalItems

@synthesize table;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)imageData {
    self = [super initWithFrame:frame];
    if (self) {
		data = imageData;
		[data retain];
		
		table = [[FTHorizontalTableView alloc] initWithFrame:self.bounds];
		[table setShowsHorizontalScrollIndicator:NO];
		[table setHorizontalDelegate:self];
		[table setDataSource:self];
		[table setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:table];
		
		[self setBackgroundColor:[UIColor redColor]];
		
		[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    return self;
}

#pragma mark Memory management

- (void)dealloc {
	[table release];
	[data release];
    [super dealloc];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(FTHorizontalTableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(FTHorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 50;
}

- (FTHorizontalTableViewCell *)tableView:(FTHorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellId = @"CellId";
	FTHorizontalTableViewCell *cell = (FTHorizontalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell = [[[FTHorizontalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
		[cell.textLabel setText:@"Lorem"];
	}
	return cell;
}


@end
