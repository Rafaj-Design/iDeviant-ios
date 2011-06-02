//
//  IDHomeTableViewCell.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 10/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDTableViewCell.h"


@interface IDHomeTableViewCell : IDTableViewCell {
    
	UIImageView *backgroundImageView;
	UIImageView *iconImageView;
	
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *iconImageView;


@end
