//
//  IDCategoriesTableViewCell.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 10/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDTableViewCell.h"


@class IDCategoriesTableViewCell;

@protocol IDCategoriesTableViewCellDelegate <NSObject>

- (void)didClickFavoritesCategoryButton:(IDCategoriesTableViewCell *)cell;

@end


@interface IDCategoriesTableViewCell : IDTableViewCell {
    
	UIButton *selectButton;
	
	UIButton *favoritesStarButton;
	
	id <IDCategoriesTableViewCellDelegate> delegate;
	
	BOOL isFavorite;
	
	NSDictionary *categoryData;
	
}

@property (nonatomic, retain) IBOutlet UIButton *selectButton;

@property (nonatomic, retain) IBOutlet UIButton *favoritesStarButton;

@property (nonatomic, assign) id <IDCategoriesTableViewCellDelegate> delegate;

@property (nonatomic, retain) NSDictionary *categoryData;


- (IBAction)didSelectCategory:(UIButton *)sender;

- (IBAction)didClickFavouritesButton:(UIButton *)sender;

- (void)setIsFavourite:(BOOL)favourite;


@end
