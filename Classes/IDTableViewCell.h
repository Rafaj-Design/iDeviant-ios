//
//  IDTableViewCell.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTTableViewCell.h"


@interface IDTableViewCell : FTTableViewCell {
    
	UIImageView *accessoryArrow;
	
	NSString *itemPath;
	NSString *categoryPath;
	
}

@property (nonatomic, retain) IBOutlet UIImageView *accessoryArrow;

@property (nonatomic, retain) NSString *itemPath;
@property (nonatomic, retain) NSString *categoryPath;


@end
