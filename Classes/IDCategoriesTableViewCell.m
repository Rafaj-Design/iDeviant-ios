//
//  IDCategoriesTableViewCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 10/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDCategoriesTableViewCell.h"
#import "IDFavouriteCategories.h"


@implementation IDCategoriesTableViewCell

@synthesize selectButton;
@synthesize favoritesStarButton;
@synthesize delegate;
@synthesize categoryData;


#pragma mark Initialization

- (id)init {
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		
	}
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
    }
    return self;
}

#pragma mark Settings

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[UIView beginAnimations:nil context:nil];
	if (editing) {
		[accessoryArrow setAlpha:0];
	}
	else {
		[accessoryArrow setAlpha:1];
	}
	[UIView commitAnimations];
}

#pragma mark Memory management

- (void)dealloc {
	[selectButton release];
	[favoritesStarButton release];
	[categoryData release];
    [super dealloc];
}

#pragma mark Button actions

- (void)setIsFavourite:(BOOL)favourite {
	if (favourite) {
		[self.favoritesStarButton setImage:[UIImage imageNamed:@"DA_fav-on.png"] forState:UIControlStateNormal];
	}
	else {
		[self.favoritesStarButton setImage:[UIImage imageNamed:@"DA_fav-off.png"] forState:UIControlStateNormal];
	}
	isFavorite = favourite;
	
	NSLog(@"Category path: %@", categoryPath);
}

- (IBAction)didSelectCategory:(UIButton *)sender {
	[self setIsFavourite:!isFavorite];
	[IDFavouriteCategories toggleIsFavouriteCategory:categoryPath withCategoryData:categoryData];
}

- (IBAction)didClickFavouritesButton:(UIButton *)sender {
	if ([delegate respondsToSelector:@selector(didClickFavoritesCategoryButton:)]) {
		[delegate didClickFavoritesCategoryButton:self];
	}
}


@end
