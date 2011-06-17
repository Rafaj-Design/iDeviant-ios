//
//  IDHorizontalItems.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHorizontalTableView.h"


@interface IDHorizontalItems : UIView <FTHorizontalTableViewDelegate, FTHorizontalTableViewDataSource> {
    
	FTHorizontalTableView *table;
	
	NSArray *data;
	
}


@property (nonatomic, retain) FTHorizontalTableView *table;

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)imageData;


@end
